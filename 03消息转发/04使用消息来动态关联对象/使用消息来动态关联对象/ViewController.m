//
//  ViewController.m
//  使用消息来动态关联对象
//
//  Created by 华惠友 on 2018/12/4.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "ViewController.h"
#import "Dog.h"
#import "Fly.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    Fly *fly1 = [Fly new];
    Fly *fly2 = [Fly new];
    
    Dog *dog = [Dog new];
    [dog addDelegate:fly1];
    [dog addDelegate:fly2];
    [dog performSelector:@selector(fly)];
}


@end
