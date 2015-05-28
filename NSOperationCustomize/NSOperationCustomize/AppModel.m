//
//  AppModel.m
//  NSOperationCustomize
//
//  Created by lyxia on 15/5/28.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

//工厂方法
+ (instancetype)appModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
