//
//  HHYRuntimeMethod.m
//  RunTime
//
//  Created by 华惠友 on 2018/12/3.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "HHYRuntimeMethod.h"
#import "HHYRuntimeMethodHelper.h"
#import <objc/runtime.h>

@interface HHYRuntimeMethod () {
    HHYRuntimeMethodHelper *_helper;
}
@end

@implementation HHYRuntimeMethod

+ (instancetype)object {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _helper = [[HHYRuntimeMethodHelper alloc] init];
    }
    
    return self;
}

- (void)test {
    [self performSelector:@selector(method2)];
}
/**
 消息转发
 当一个对象能接收一个消息时，就会走正常的方法调用流程。但如果一个对象无法接收指定消息时，又会发生什么事呢？默认情况下，如果是以 [object message]的方式调用方法，如果object无法响应message消息时，编译器会报错。但如果是以perform…的形式来调用，则需要等到运 行时才能确定object是否能接收message消息。如果不能，则程序崩溃。
 通常，当我们不能确定一个对象是否能接收某个消息时，会先调用respondsToSelector:来判断一下
 if ([self respondsToSelector:@selector(method)]) {
    [self performSelector:@selector(method)];
 }
 当一个对象无法接收某一消息时，就会启动所谓”消息转发(message forwarding)“机制，通过这一机制，我们可以告诉对象如何处理未知的消息。默认情况下，对象接收到未知的消息，会导致程序崩溃.
 
 消息转发机制基本上分为三个步骤：
 1.动态方法解析 + (BOOL)resolveInstanceMethod:(SEL)sel
 2.备用接收者   - (id)forwardingTargetForSelector:(SEL)aSelector
 3.完整转发    - (void)forwardInvocation:(NSInvocation *)anInvocation
 */

/**
 一. 动态方法解析
对象在接收到未知的消息时，首先会调用所属类的类方法+resolveInstanceMethod:(实例方法)或者+resolveClassMethod:(类方法)。在这个方法中，我们有机会为该未知消息新增一个”处理方法”“。不过使用该方法的前提是我们已经 实现了该”处理方法”，只需要在运行时通过class_addMethod函数动态添加到类里面就可以了。
 */
/**
void functionForMethod1(id self, SEL _cmd) {
    NSLog(@"resolveInstanceMethod:%@, %p", self, _cmd);
}
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString isEqualToString:@"method2"]) {
        // 动态添加方法, 这里是为method2在当前类中添加执行方法functionForMethod1,我们已经实现了该方法,该方法两个参数self, _cmd, 对应的types 为 @: => 对象本身 方法
        class_addMethod(self.class, @selector(method2), (IMP)functionForMethod1, "@:");
    }
    return [super resolveInstanceMethod:sel];
}
 */

/**
 二. 备用接受者
 如果在上一步无法处理消息，则Runtime会继续调以下方法：
 - (id)forwardingTargetForSelector:(SEL)aSelector
 
 如果一个对象实现了这个方法，并返回一个非nil的结果，则这个对象会作为消息的新接收者，且消息会被分发到这个对象。当然这个对象不能是self自身，否则就是出现无限循环。当然，如果我们没有指定相应的对象来处理aSelector，则应该调用父类的实现来返回结果。
 使用这个方法通常是在对象内部，可能还有一系列其它对象能处理该消息，我们便可借这些对象来处理消息并返回，这样在对象外部看来，还是由该对象亲自处理了这一消息。
 这一步合适于我们只想将消息转发到另一个能处理该消息的对象上。但这一步无法对消息进行处理，如操作消息的参数和返回值。
 */
/**
- (id)forwardingTargetForSelector:(SEL)aSelector {

    NSLog(@"forwardingTargetForSelector");
    NSString *selectorString = NSStringFromSelector(aSelector);
    // 将消息转发给_helper来处理, _helper对象实现了method2这个方法
    if ([selectorString isEqualToString:@"method2"]) {
        return _helper;
    }
    return [super forwardingTargetForSelector:aSelector];
}
*/


/**
 三. 完整消息转发
 如果在上一步还不能处理未知消息，则唯一能做的就是启用完整的消息转发机制了。此时会调用以下方法：
 - (void)forwardInvocation:(NSInvocation *)anInvocation
 
 运行时系统会在这一步给消息接收者最后一次机会将消息转发给其它对象。对象会创建一个表示消息的NSInvocation对象，把与尚未处理的消息 有关的全部细节都封装在anInvocation中，包括selector，目标(target)和参数。我们可以在forwardInvocation方法中选择将消息转发给其它对象。
 
 forwardInvocation:方法的实现有两个任务：
 1.定位可以响应封装在anInvocation中的消息的对象。这个对象不需要能处理所有未知消息。
 2.使用anInvocation作为参数，将消息发送到选中的对象。anInvocation将会保留调用结果，运行时系统会提取这一结果并将其发送到消息的原始发送者。
 不过，在这个方法中我们可以实现一些更复杂的功能，我们可以对消息的内容进行修改，比如追回一个参数等，然后再去触发消息。另外，若发现某个消息不应由本类处理，则应调用父类的同名方法，以便继承体系中的每个类都有机会处理此调用请求。
 
 还有一个很重要的问题，我们必须重写以下方法：
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
 消息转发机制使用从这个方法中获取的信息来创建NSInvocation对象。因此我们必须重写这个方法，为给定的selector提供一个合适的方法签名。
 
 NSObject的forwardInvocation:方法实现只是简单调用了doesNotRecognizeSelector:方法，它不会转发任何消息。这样，如果不在以上所述的三个步骤中处理未知消息，则会引发一个异常。
 从某种意义上来讲，forwardInvocation:就像一个未知消息的分发中心，将这些未知的消息转发给其它对象。或者也可以像一个运输站一样将所有未知消息都发送给同一个接收对象。这取决于具体的实现。
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([HHYRuntimeMethodHelper instancesRespondToSelector:aSelector]) {
            signature = [HHYRuntimeMethodHelper instanceMethodSignatureForSelector:aSelector];
        }
    }
    /**
     po signature
     <NSMethodSignature: 0x600003ad5340>
     number of arguments = 2
     frame size = 224
     is special struct return? NO
     return value: -------- -------- -------- --------  返回值 void
         type encoding (v) 'v'
         flags {}
         modifiers {}
         frame {offset = 0, offset adjust = 0, size = 0, size adjust = 0}
         memory {offset = 0, size = 0}
     argument 0: -------- -------- -------- --------    参数1 id self
         type encoding (@) '@'
         flags {isObject}
         modifiers {}
         frame {offset = 0, offset adjust = 0, size = 8, size adjust = 0}
         memory {offset = 0, size = 8}
     argument 1: -------- -------- -------- --------    参数2 SEL _cmd
         type encoding (:) ':'
         flags {}
         modifiers {}
         frame {offset = 8, offset adjust = 0, size = 8, size adjust = 0}
         memory {offset = 0, size = 8}
     */
    return signature;
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    /**
     po anInvocation
     <NSInvocation: 0x600003615800>
         return value: {v} void         返回值
         target: {@} 0x6000021710f0     目标函数
         selector: {:} method2          执行方法
     */
    if ([HHYRuntimeMethodHelper instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_helper];
    }
}

/**
 实现转发消息的方法
 1 需要有一个对象 在消息进行转发之前需要从对象里面取对应方法选标的方法签名 然后在forwardInvocation这个方法里面将这个消息转发给那个对象
 2 .h定义接收转发消息的对象 _helper
 3 这里去方法选标就需要在取这个方法选标在_helper这个类里面对应的方法签名
 4 判断之后 我们才会转发 判断之后 返回方法签名
 5 先判断 在进行消息转发 将消息转发给另一个对象

 */

/**
 消息转发与多重继承
 回过头来看第二和第三步，通过这两个方法我们可以允许一个对象与其它对象建立关系，以处理某些未知消息，而表面上看仍然是该对象在处理消息。通过这 种关系，我们可以模拟“多重继承”的某些特性，让对象可以“继承”其它对象的特性来处理一些事情。不过，这两者间有一个重要的区别：多重继承将不同的功能 集成到一个对象中，它会让对象变得过大，涉及的东西过多；而消息转发将功能分解到独立的小的对象中，并通过某种方式将这些对象连接起来，并做相应的消息转 发。
 不过消息转发虽然类似于继承，但NSObject的一些方法还是能区分两者。如respondsToSelector:和isKindOfClass:只能用于继承体系，而不能用于转发链。便如果我们想让这种消息转发看起来像是继承，则可以重写这些方法
 */
- (BOOL)respondsToSelector:(SEL)aSelector   {
    if ( [super respondsToSelector:aSelector] )
        return YES;
    else {
        /* Here, test whether the aSelector message can
         *
         * be forwarded to another object and whether that
         *
         * object can respond to it. Return YES if it can.
         */
    }
    return NO;
}


/**
 小结
 在此，我们已经了解了Runtime中消息发送和转发的基本机制。这也是Runtime的强大之处，通过它，我们可以为程序增加很多动态的行为，虽 然我们在实际开发中很少直接使用这些机制(如直接调用objc_msgSend)，但了解它们有助于我们更多地去了解底层的实现。其实在实际的编码过程中，我们也可以灵活地使用这些机制，去实现一些特殊的功能，如hook操作等.
 */
@end















