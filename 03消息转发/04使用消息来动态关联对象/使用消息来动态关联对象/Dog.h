//
//  Dog.h
//  使用消息来动态关联对象
//
//  Created by 华惠友 on 2018/12/4.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dog : NSObject
- (void)run;
-(void)addDelegate:(id)aDelegate;
-(void)removeDelegate:(id)aDelegate;
@end

NS_ASSUME_NONNULL_END
