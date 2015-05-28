//
//  DownLoadOperation.h
//  NSOperationCustomize
//
//  Created by lyxia on 15/5/28.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DownLoadOperation;
@protocol DownLoadOperationDelegate <NSObject>
- (void)downLoadOperation:(DownLoadOperation *)operation didFishedDownLoad:(UIImage *)image;
@end

@interface DownLoadOperation : NSOperation
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<DownLoadOperationDelegate> delegate;
@end
