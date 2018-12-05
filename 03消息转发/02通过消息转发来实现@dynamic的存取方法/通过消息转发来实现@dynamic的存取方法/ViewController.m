//
//  ViewController.m
//  通过消息转发来实现@dynamic的存取方法
//
//  Created by 华惠友 on 2018/12/4.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import "ViewController.h"
#import "Book.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Book *book = [[Book alloc] init];
    
    book.name = @"c++ primer";
    
    book.author = @"Stanley B.Lippman";
    
    book.version = @"5.0";
    
    NSLog(@"%@", book.name);
    
    NSLog(@"%@", book.author);
    
    NSLog(@"%@", book.version);
}


@end
