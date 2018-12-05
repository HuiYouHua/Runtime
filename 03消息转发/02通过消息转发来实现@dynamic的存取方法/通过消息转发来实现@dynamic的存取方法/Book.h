//
//  Book.h
//  通过消息转发来实现@dynamic的存取方法
//
//  Created by 华惠友 on 2018/12/4.
//  Copyright © 2018 华惠友. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject{
    NSMutableDictionary *_propertiesDict;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString*author;
@property (nonatomic, copy) NSString*version;

@end

NS_ASSUME_NONNULL_END
