//
//  HHYRuntimeMethodHelper.m
//  RunTime
//
//  Created by 华惠友 on 2018/12/3.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "HHYRuntimeMethodHelper.h"

@implementation HHYRuntimeMethodHelper

- (void)method2 {
    NSLog(@"%@, %p", self, _cmd);
}

@end
