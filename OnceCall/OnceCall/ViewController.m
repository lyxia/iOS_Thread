//
//  ViewController.m
//  OnceCall
//
//  Created by lyxia on 15/5/28.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, assign) BOOL log;
@end

/**
 * 需求：点击控制器只有第一次点击的时候才打印
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self once2];
}

//缺点：这是一个对象方法，如果又创建一个新的控制器，那么打印代码又会执行，因此不能保证该行代码在整个程序中只被执行1次
- (void)once1
{
    if (_log == NO) {
        NSLog(@"该代码只执行一次");
        _log = YES;
    }
}

//使用dispatch_once一次性代码
- (void)once2
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"该行代码只执行一次----%@", [NSThread currentThread]);
    });
}

@end
