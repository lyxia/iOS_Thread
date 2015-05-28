//
//  AppModel.h
//  NSOperationCustomize
//
//  Created by lyxia on 15/5/28.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject

//应用名称
@property (nonatomic, copy) NSString *name;

//应用图片
@property (nonatomic, copy) NSString *icon;

//应用的下载量
@property (nonatomic, copy) NSString *download;

+ (instancetype)appModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
