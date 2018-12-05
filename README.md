[TOC]



#一、类与对象基础数据结构

##1.类与对象基础数据结构

### 1）Class

```objective-c
// Objective-C类是由Class类型来表示的，它实际上是一个指向objc_class结构体的指针
typedef struct objc_class *Class;

// objc_class结构体
struct objc_class {
    Class isa  OBJC_ISA_AVAILABILITY;

#if !__OBJC2__
    Class super_class                       OBJC2_UNAVAILABLE;  // 父类
    const char *name                        OBJC2_UNAVAILABLE;  // 类名
    long version                            OBJC2_UNAVAILABLE;  // 类的版本信息，默认为0
    long info                               OBJC2_UNAVAILABLE;  // 类信息，供运行期使用的一些位标识
    long instance_size                      OBJC2_UNAVAILABLE;  // 该类的实例变量大小
    struct objc_ivar_list *ivars            OBJC2_UNAVAILABLE;  // 该类的成员变量链表
    struct objc_method_list **methodLists   OBJC2_UNAVAILABLE;  // 方法定义的链表
    struct objc_cache *cache                OBJC2_UNAVAILABLE;  // 方法缓存
    struct objc_protocol_list *protocols    OBJC2_UNAVAILABLE;  // 协议链表
#endif

} OBJC2_UNAVAILABLE;
```

### 2）object_objec与id

```objective-c
// objc_object是表示一个类的实例的结构体
struct objc_object {
    Class isa  OBJC_ISA_AVAILABILITY;
};

typedef struct objc_object *id;
```

### 3）objc_cache

```objective-c
// 缓存调用过的方法。这个字段是一个指向objc_cache结构体的指针
struct objc_cache {
    unsigned int mask /* total = mask + 1 */                 OBJC2_UNAVAILABLE;
    unsigned int occupied                                    OBJC2_UNAVAILABLE;
    Method buckets[1]                                        OBJC2_UNAVAILABLE;
};
```

###4）元类（Meta Class）

```objective-c
// meta-class是一个类对象的类。
```



## 2.类相关操作函数

###1）类名（name）

```objective-c
// 获取类的类名
const char * class_getName ( Class cls );	
// 获取类的父类
Class class_getSuperclass ( Class cls );
// 判断给定的Class是否是一个元类
BOOL class_isMetaClass ( Class cls );
```

### 2）实例变量大小

```objective-c
// 获取实例大小
size_t class_getInstanceSize ( Class cls );
```

### 3）成员变量（ivar）及属性

```objective-c
// 获取类中指定名称实例成员变量的信息
Ivar class_getInstanceVariable ( Class cls, const char *name );
// 获取类成员变量的信息
Ivar class_getClassVariable ( Class cls, const char *name );
// 添加成员变量
BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types );
// 获取整个成员变量列表
Ivar * class_copyIvarList ( Class cls, unsigned int *outCount );

// 属性操作
// 获取指定的属性
objc_property_t class_getProperty ( Class cls, const char *name );
// 获取属性列表
objc_property_t * class_copyPropertyList ( Class cls, unsigned int *outCount );
// 为类添加属性
BOOL class_addProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
// 替换类的属性
void class_replaceProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
```

### 4）方法（methodLists）

```objective-c
// 添加方法
BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );
// 获取实例方法
Method class_getInstanceMethod ( Class cls, SEL name );
// 获取类方法
Method class_getClassMethod ( Class cls, SEL name );
// 获取所有方法的数组
Method * class_copyMethodList ( Class cls, unsigned int *outCount );
// 替代方法的实现
IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );
// 返回方法的具体实现
IMP class_getMethodImplementation ( Class cls, SEL name );
IMP class_getMethodImplementation_stret ( Class cls, SEL name );
// 类实例是否响应指定的selector
BOOL class_respondsToSelector ( Class cls, SEL sel );
```

### 5）协议

```objective-c
// 添加协议
BOOL class_addProtocol ( Class cls, Protocol *protocol );
// 返回类是否实现指定的协议
BOOL class_conformsToProtocol ( Class cls, Protocol *protocol );
// 返回类实现的协议列表
Protocol * class_copyProtocolList ( Class cls, unsigned int *outCount );
```

###6）版本

```objective-c
// 获取版本号
int class_getVersion ( Class cls );
// 设置版本号
void class_setVersion ( Class cls, int version );
```

### 7）其他

```objective-c
// runtime还提供了两个函数来供CoreFoundation的tool-free bridging使用，即：
Class objc_getFutureClass ( const char *name );
void objc_setFutureClass ( Class cls, const char *name );	
```



##3.动态创建类和对象

###1）动态创建类

```objective-c
// 创建一个新类和元类
Class objc_allocateClassPair ( Class superclass, const char *name, size_t extraBytes );
// 销毁一个类及其相关联的类
void objc_disposeClassPair ( Class cls );
// 在应用中注册由objc_allocateClassPair创建的类
void objc_registerClassPair ( Class cls );
```

###2）动态创建对象

```objective-c
// 创建类实例
id class_createInstance ( Class cls, size_t extraBytes );
// 在指定位置创建类实例
id objc_constructInstance ( Class cls, void *bytes );
// 销毁类实例
void * objc_destructInstance ( id obj );
```

## 4.实例操作函数

### 1）针对整个对象进行操作的函数

```objective-c
// 返回指定对象的一份拷贝
id object_copy ( id obj, size_t size );
// 释放指定对象占用的内存
id object_dispose ( id obj );
```

###2）针对对象实例变量进行操作的函数

```objective-c
// 修改类实例的实例变量的值
Ivar object_setInstanceVariable ( id obj, const char *name, void *value );
// 获取对象实例变量的值
Ivar object_getInstanceVariable ( id obj, const char *name, void **outValue );
// 返回指向给定对象分配的任何额外字节的指针
void * object_getIndexedIvars ( id obj );
// 返回对象中实例变量的值
id object_getIvar ( id obj, Ivar ivar );
// 设置对象中实例变量的值
void object_setIvar ( id obj, Ivar ivar, id value );
```

3）针对对象的类进行操作的函数

```objective-c
// 返回给定对象的类名
const char * object_getClassName ( id obj );
// 返回对象的类
Class object_getClass ( id obj );
// 设置对象的类
Class object_setClass ( id obj, Class cls );
```

##5.获取类定义

```objective-c
// 获取已注册的类定义的列表
int objc_getClassList ( Class *buffer, int bufferCount );
// 创建并返回一个指向所有已注册类的指针列表
Class * objc_copyClassList ( unsigned int *outCount );
// 返回指定类的类定义
Class objc_lookUpClass ( const char *name );
Class objc_getClass ( const char *name );
Class objc_getRequiredClass ( const char *name );
// 返回指定类的元类
Class objc_getMetaClass ( const char *name );
```



# 二、成员和成员属性

## 1.类型编码（Type Encoding）

```objective-c
float a[] = {1.0, 2.0, 3.0};
NSLog(@"array encoding type: %s", @encode(typeof(a)));
// 输出
2014-10-28 11:44:54.731 RuntimeTest[942:50791] array encoding type: [3f]
```

## 2.成员变量、属性

### 1）基础数据类型

#### （1）Ivar

```objective-c
// Ivar是表示实例变量的类型，其实际是一个指向objc_ivar结构体的指针
typedef struct objc_ivar *Ivar;

struct objc_ivar {
    char *ivar_name                 OBJC2_UNAVAILABLE;  // 变量名
    char *ivar_type                 OBJC2_UNAVAILABLE;  // 变量类型
    int ivar_offset                 OBJC2_UNAVAILABLE;  // 基地址偏移字节
#ifdef __LP64__
    int space                       OBJC2_UNAVAILABLE;
#endif
}
```

#### （2）objc_property_t

```objective-c
// objc_property_t是表示Objective-C声明的属性的类型，其实际是指向objc_property结构体的指针
typedef struct objc_property *objc_property_t;
```

#### （3）objc_property_attribute_t

```objective-c
// objc_property_attribute_t定义了属性的特性(attribute)，它是一个结构体
typedef struct {
    const char *name;           // 特性名
    const char *value;          // 特性值
} objc_property_attribute_t;
```

### 2）关联对象（Associated Object）

```objective-c
// 关联对象类似于成员变量，不过是在运行时添加的. 分类的属性
static char myKey;

objc_setAssociatedObject(self, &myKey, anObject, OBJC_ASSOCIATION_RETAIN);
id anObject = objc_getAssociatedObject(self, &myKey);
```

## 3.成员变量、属性的操作方法

### 1）成员变量

```objective-c
// 获取成员变量名
const char * ivar_getName ( Ivar v );
// 获取成员变量类型编码
const char * ivar_getTypeEncoding ( Ivar v );
// 获取成员变量的偏移量
ptrdiff_t ivar_getOffset ( Ivar v );
```

### 2）关联对象

```objective-c
// 设置关联对象
void objc_setAssociatedObject ( id object, const void *key, id value, objc_AssociationPolicy policy );
// 获取关联对象
id objc_getAssociatedObject ( id object, const void *key );
// 移除关联对象
void objc_removeAssociatedObjects ( id object );
```

### 3）属性

```objective-c
// 获取属性名
const char * property_getName ( objc_property_t property );
// 获取属性特性描述字符串
const char * property_getAttributes ( objc_property_t property );
// 获取属性中指定的特性
char * property_copyAttributeValue ( objc_property_t property, const char *attributeName );
// 获取属性的特性列表
objc_property_attribute_t * property_copyAttributeList ( objc_property_t property, unsigned int *outCount );
```



# 三、方法和消息

##1.方法

###1)SEL

```objective-c
// SEL又叫选择器，是表示一个方法的selector的指针
typedef struct objc_selector *SEL;

SEL sel1 = @selector(method1);
NSLog(@"sel : %p", sel1);

RuntimeTest[52734:466626] sel : 0x100002d72
```

###2)IMP

```objective-c
// IMP实际上是一个函数指针，指向方法实现的首地址
id (*IMP)(id, SEL, ...)
```

###3）Method

```objective-c
typedef struct objc_method *Method;
 
struct objc_method {
    SEL method_name                 OBJC2_UNAVAILABLE;  // 方法名
    char *method_types                  OBJC2_UNAVAILABLE;
    IMP method_imp                      OBJC2_UNAVAILABLE;  // 方法实现
}
```

###4）objc_method_description

```objective-c
struct objc_method_description { 
	SEL name; char *types;
};
```

## 2.方法相关操作函数

```objective-c
// 调用指定方法的实现
id method_invoke ( id receiver, Method m, ... );
// 调用返回一个数据结构的方法的实现
void method_invoke_stret ( id receiver, Method m, ... );
// 获取方法名
SEL method_getName ( Method m );
// 返回方法的实现
IMP method_getImplementation ( Method m );
// 获取描述方法参数和返回值类型的字符串
const char * method_getTypeEncoding ( Method m );
// 获取方法的返回值类型的字符串
char * method_copyReturnType ( Method m );
// 获取方法的指定位置参数的类型字符串
char * method_copyArgumentType ( Method m, unsigned int index );
// 通过引用返回方法的返回值类型字符串
void method_getReturnType ( Method m, char *dst, size_t dst_len );
// 返回方法的参数的个数
unsigned int method_getNumberOfArguments ( Method m );
// 通过引用返回方法指定位置参数的类型字符串
void method_getArgumentType ( Method m, unsigned int index, char *dst, size_t dst_len );
// 返回指定方法的方法描述结构体
struct objc_method_description * method_getDescription ( Method m );
// 设置方法的实现
IMP method_setImplementation ( Method m, IMP imp );
// 交换两个方法的实现
void method_exchangeImplementations ( Method m1, Method m2 );
```

## 3.方法选择器

```objective-c
// 返回给定选择器指定的方法的名称
const char * sel_getName ( SEL sel );
// 在Objective-C Runtime系统中注册一个方法，将方法名映射到一个选择器，并返回这个选择器
SEL sel_registerName ( const char *str );
// 在Objective-C Runtime系统中注册一个方法
SEL sel_getUid ( const char *str );
// 比较两个选择器
BOOL sel_isEqual ( SEL lhs, SEL rhs );
```

## 4.方法调用流程

```objective-c
objc_msgSend(receiver, selector, arg1, arg2, ...)
    // 当消息发送给一个对象时，objc_msgSend通过对象的isa指针获取到类的结构体，然后在方法分发表里面查找方法的selector。如果 没有找到selector，则通过objc_msgSend结构体中的指向父类的指针找到其父类，并在父类的分发表里面查找方法的selector。依 此，会一直沿着类的继承体系到达NSObject类。一旦定位到selector，函数会就获取到了实现的入口点，并传入相应的参数来执行方法的具体实 现。如果最后没有定位到selector，则会走消息转发流程
```

## 5.隐藏参数

```
消息接收对象     self
方法的selector  _cmd
```

## 6.获取方法地址

```objective-c
// Runtime中方法的动态绑定让我们写代码时更具灵活性，如我们可以把消息转发给我们想要的对象，或者随意交换一个方法的实现等。不过灵活性的提 升也带来了性能上的一些损耗。毕竟我们需要去查找方法的实现，而不像函数调用来得那么直接。当然，方法的缓存一定程度上解决了这一问题。
// NSObject类提供了methodForSelector:方法，让我们可以获取到方法的指针，然后通过这个指针来调用实现代码。我们需要将methodForSelector:返回的指针转换为合适的函数类型，函数参数和返回值都需要匹配上。
void (*setter)(id, SEL, BOOL);
int i;
 
setter = (void (*)(id, SEL, BOOL))[target
    methodForSelector:@selector(setFilled:)];
for ( i = 0 ; i < 1000 ; i++ )
    setter(targetList[i], @selector(setFilled:), YES);
```

## 7.消息转发

###1）动态方法解析

```objective-c
// 对象在接收到未知的消息时，首先会调用所属类的类方法+resolveInstanceMethod:(实例方法)或 者+resolveClassMethod:(类方法)。在这个方法中，我们有机会为该未知消息新增一个”处理方法”“。不过使用该方法的前提是我们已经 实现了该”处理方法”，只需要在运行时通过class_addMethod函数动态添加到类里面就可以了。如下代码所示：
void functionForMethod1(id self, SEL _cmd) {
   NSLog(@"%@, %p", self, _cmd);
}
 
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString isEqualToString:@"method1"]) {
        class_addMethod(self.class, @selector(method1), (IMP)functionForMethod1, "@:");
    }
    return [super resolveInstanceMethod:sel];
}

```

### 2）备用接受者

```objective-c
// 如果在上一步无法处理消息，则Runtime会继续调以下方法:
- (id)forwardingTargetForSelector:(SEL)aSelector
```

###3）完整消息转发

```objective-c
// 消息转发机制使用从这个方法中获取的信息来创建NSInvocation对象。因此我们必须重写这个方法，为给定的selector提供一个合适的方法签名。
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
// 如果在上一步还不能处理未知消息，则唯一能做的就是启用完整的消息转发机制了。此时会调用以下方法：
// 运行时系统会在这一步给消息接收者最后一次机会将消息转发给其它对象。对象会创建一个表示消息的NSInvocation对象，把与尚未处理的消息 有关的全部细节都封装在anInvocation中，包括selector，目标(target)和参数。我们可以在forwardInvocation 方法中选择将消息转发给其它对象。
- (void)forwardInvocation:(NSInvocation *)anInvocation
```

### 4）消息转发与多继承

```objective-c
// 不过消息转发虽然类似于继承，但NSObject的一些方法还是能区分两者。如respondsToSelector:和isKindOfClass:只能用于继承体系，而不能用于转发链。便如果我们想让这种消息转发看起来像是继承，则可以重写这些方法，如以下代码所示：
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
```

# 四、Method Swizzling

```objective-c
#import <objc/runtime.h>

@implementation UIViewController (Tracking)

+ (void)load {
        static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];         
        // When swizzling a class method, use the following:
                    // Class class = object_getClass((id)self);

        SEL originalSelector = @selector(viewWillAppear:);
                    SEL swizzledSelector = @selector(xxx_viewWillAppear:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
                    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
                        class_addMethod(class,
                originalSelector,
                method_getImplementation(swizzledMethod),
                method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
                        class_replaceMethod(class,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)xxx_viewWillAppear:(BOOL)animated {
        [self xxx_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", self);
}

@end
```



# 五、协议与分类

## 1.基础数据类型

### 1）Category

```objective-c
// Category是表示一个指向分类的结构体的指针
typedef struct objc_category *Category;

struct objc_category {
    char *category_name                          OBJC2_UNAVAILABLE; // 分类名
    char *class_name                             OBJC2_UNAVAILABLE; // 分类所属的类名
    struct objc_method_list *instance_methods    OBJC2_UNAVAILABLE; // 实例方法列表
    struct objc_method_list *class_methods       OBJC2_UNAVAILABLE; // 类方法列表
    struct objc_protocol_list *protocols         OBJC2_UNAVAILABLE; // 分类所实现的协议列表
}
```

### 2）Protocol

```objective-c
typedef struct objc_object Protocol;

// 返回指定的协议
Protocol * objc_getProtocol ( const char *name );
// 获取运行时所知道的所有协议的数组
Protocol ** objc_copyProtocolList ( unsigned int *outCount );
// 创建新的协议实例
Protocol * objc_allocateProtocol ( const char *name );
// 在运行时中注册新创建的协议
void objc_registerProtocol ( Protocol *proto );
// 为协议添加方法
void protocol_addMethodDescription ( Protocol *proto, SEL name, const char *types, BOOL isRequiredMethod, BOOL isInstanceMethod );
// 添加一个已注册的协议到协议中
void protocol_addProtocol ( Protocol *proto, Protocol *addition );
// 为协议添加属性
void protocol_addProperty ( Protocol *proto, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount, BOOL isRequiredProperty, BOOL isInstanceProperty );
// 返回协议名
const char * protocol_getName ( Protocol *p );
// 测试两个协议是否相等
BOOL protocol_isEqual ( Protocol *proto, Protocol *other );
// 获取协议中指定条件的方法的方法描述数组
struct objc_method_description * protocol_copyMethodDescriptionList ( Protocol *p, BOOL isRequiredMethod, BOOL isInstanceMethod, unsigned int *outCount );
// 获取协议中指定方法的方法描述
struct objc_method_description protocol_getMethodDescription ( Protocol *p, SEL aSel, BOOL isRequiredMethod, BOOL isInstanceMethod );
// 获取协议中的属性列表
objc_property_t * protocol_copyPropertyList ( Protocol *proto, unsigned int *outCount );
// 获取协议的指定属性
objc_property_t protocol_getProperty ( Protocol *proto, const char *name, BOOL isRequiredProperty, BOOL isInstanceProperty );
// 获取协议采用的协议
Protocol ** protocol_copyProtocolList ( Protocol *proto, unsigned int *outCount );
// 查看协议是否采用了另一个协议
BOOL protocol_conformsToProtocol ( Protocol *proto, Protocol *other );
```













