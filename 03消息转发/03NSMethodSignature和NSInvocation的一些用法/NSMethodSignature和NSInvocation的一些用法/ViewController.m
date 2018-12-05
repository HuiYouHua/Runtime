//
//  ViewController.m
//  NSMethodSignature和NSInvocation的一些用法
//
//  Created by 华惠友 on 2018/12/4.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test1];
    [self test2];
}

/**
 这里是通过 setTarget 和 setSelector 来设置target和selector的
 */
- (void)test1 {
    int a = 1;
    int b = 2;
    int c = 3;
    SEL myMethod = @selector(myLog:param:parm:);
    // 创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一致。
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:myMethod];
    // 通过签名初始化
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];

    // 设置target
    [invocation setTarget:self];
    // 设置selector
    [invocation setSelector:myMethod];
    // 注意：1、这里设置参数的Index 需要从2开始，因为前两个被selector和target占用。
    [invocation setArgument:&a atIndex:2];
    [invocation setArgument:&b atIndex:3];
    [invocation setArgument:&c atIndex:4];

    // 发送消息
    [invocation invokeWithTarget:self];
    
    int d;
    // 取这个返回值
    [invocation getReturnValue:&d];
    NSLog(@"d:%d", d);
    NSUInteger argCount = [sig numberOfArguments];
    NSLog(@"argCount:%ld", argCount);
    
    for (NSInteger i=0; i<argCount; i++) {
        NSLog(@"%s", [sig getArgumentTypeAtIndex:i]);
    }
    NSLog(@"returnType:%s ,returnLen:%ld", [sig methodReturnType], [sig methodReturnLength]);
    NSLog(@"signature:%@" , sig);
}

/**
 这里是通过 setArgument: atIndex 来设置target和selector的
 */
- (void)test2 {
    SEL myMethod2 = @selector(myLog);
    // 创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一致。
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:myMethod2];
    // 通过签名初始化
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    ViewController *vc = self;
    
    // 设置target
    [invocation setArgument:&vc atIndex:0];
    // 设置selector
    [invocation setArgument:&myMethod2 atIndex:1];

    NSUInteger argCount = [sig numberOfArguments];
    NSLog(@"argCount:%ld", argCount);

    for (NSInteger i=0; i<argCount; i++) {
        NSLog(@"%s", [sig getArgumentTypeAtIndex:i]);
    }
    NSLog(@"returnType:%s ,returnLen:%ld", [sig methodReturnType], [sig methodReturnLength]);
    NSLog(@"signature:%@" , sig);
    
    
    [invocation invokeWithTarget:self];
}

- (int)myLog:(int)a param:(int)b parm:(int)c {
    NSLog(@"MyLog:%d,%d,%d", a, b, c);
    return a+b+c;
}

- (void)myLog {
    NSLog(@"你好,South China University of Technology");
}


@end





















