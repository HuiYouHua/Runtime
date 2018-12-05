//
//  Fly.m
//  使用消息来动态关联对象
//
//  Created by 华惠友 on 2018/12/4.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "Fly.h"

@implementation Fly
- (void)fly {
    NSLog(@"%@, %p 我也会飞啦", self, _cmd);
}
@end
