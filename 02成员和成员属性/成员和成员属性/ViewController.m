//
//  ViewController.m
//  成员和成员属性
//
//  Created by 华惠友 on 2018/12/4.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "ViewController.h"
#import "UIView+TapAction.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *myView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_myView setTapActionWithBlock:^{
        NSLog(@"setTapActionWithBlock 关联对象");
    }];

}




@end
