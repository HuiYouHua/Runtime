//
//  UIView+TapAction.h
//  成员和成员属性
//
//  Created by 华惠友 on 2018/12/4.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TapAction)
- (void)setTapActionWithBlock:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
