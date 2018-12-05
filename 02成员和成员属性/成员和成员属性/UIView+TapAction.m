//
//  UIView+TapAction.m
//  成员和成员属性
//
//  Created by 华惠友 on 2018/12/4.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "UIView+TapAction.h"
#import <objc/runtime.h>

static NSString* const kDTActionHandlerTapGestureKey = @"DTActionHandlerTapGestureKey";
static NSString* const kDTActionHandlerTapBlockKey = @"DTActionHandlerTapBlockKey";

@implementation UIView (TapAction)

/**
 关联对象
 这里关联了一个tap点击手势对象和block
 */
- (void)setTapActionWithBlock:(void (^)(void))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        
        if (action)
        {
            action();
        }
    }
}


@end
