//
//  DownLoadOperation.m
//  NSOperationCustomize
//
//  Created by lyxia on 15/5/28.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import "DownLoadOperation.h"

@implementation DownLoadOperation

- (void)main
{
    NSURL *url = [NSURL URLWithString:self.url];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    NSLog(@"--%@--", [NSThread currentThread]);
    //图片下载完毕后，通知代理
    if ([self.delegate respondsToSelector:@selector(downLoadOperation:didFishedDownLoad:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程
            [self.delegate downLoadOperation:self didFishedDownLoad:image];
        });
    }
}

@end
