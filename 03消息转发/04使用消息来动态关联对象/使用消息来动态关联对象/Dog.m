//
//  Dog.m
//  使用消息来动态关联对象
//
//  Created by 华惠友 on 2018/12/4.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "Dog.h"
//#import "Fly.h"
#import <objc/runtime.h>

//动态关联对象的函数需要有一个key，通过key进行赋值取值
const char *kMultiDelegateKey = "kMultiDelegateKey";

@implementation Dog

- (void)run {
    NSLog(@"狗会跑, 本来具备的技能");
}

-(void)addDelegate:(id)aDelegate {
    //    关联数组
    NSMutableArray *delegateArray = objc_getAssociatedObject(self, kMultiDelegateKey);
    if (!delegateArray) {
        
        delegateArray = [NSMutableArray new];
        //第一个参数：当前对象
        //第二个参数：关联是所需要的key
        //第三个参数：就是与当前对象进行关联的对象
        //第四个参数：关联规则 枚举类型
        objc_setAssociatedObject(self, kMultiDelegateKey, delegateArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if(aDelegate){
        [delegateArray addObject:aDelegate];
    }
}
-(void)removeDelegate:(id)aDelegate {
    NSMutableArray *delegateArray = objc_getAssociatedObject([self class], kMultiDelegateKey);
    [delegateArray removeObject:aDelegate];
}

//消息转发
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMutableArray *delegateArray =objc_getAssociatedObject(self , kMultiDelegateKey);
    if (delegateArray) {
        for (id aDelegate in delegateArray) {
            return [aDelegate methodSignatureForSelector:aSelector];
        }
    }
    return [self methodSignatureForSelector:@selector(doNothing)];
}
//什么都不做
-(void)doNothing {
    
}
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    NSMutableArray *delegateArray = objc_getAssociatedObject(self, kMultiDelegateKey);
    if (delegateArray) {
        for (id aDelegate in delegateArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [anInvocation invokeWithTarget:aDelegate];
            });
        }
    }
}

@end
