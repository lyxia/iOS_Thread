//
//  ViewController.m
//  MainQueue
//
//  Created by lyxia on 15/5/27.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


/**
 * 是和主线程相关的队列，主队列式GCD自带的一种特殊的串行队列，放在主队列中的任务都会在主线程中执行
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //打印主线程
//    NSLog(@"打印主线程--%@", [NSThread mainThread]);
//    
//    //获取主队列
//    dispatch_queue_t queue = dispatch_get_main_queue();
//    //把任务添加到主队列中执行
//    dispatch_async(queue, ^{
//        NSLog(@"使用异步函数执行主队列中的任务1--%@", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"使用异步函数执行主队列中的任务2--%@", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"使用异步函数执行主队列中的任务3--%@", [NSThread currentThread]);
//    });
//    //使用同步函数，在主线程中执行主任务，会发生死循环，任务无法往下执行
    
    //开启一个后台线程，调用执行test方法
    [self performSelectorInBackground:@selector(test) withObject:nil];
}

- (void)test
{
    NSLog(@"当前线程---%@", [NSThread currentThread]);
//    [NSThread currentThread];
    //获取全局并行队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //异步函数
//    dispatch_async(queue, ^{
//        NSLog(@"异步任务所在的线程----%@", [NSThread currentThread]);
//    });
//    
//    //同步函数
//    dispatch_async(queue, ^{
//        NSLog(@"同步任务所在的线程----%@", [NSThread currentThread]);
//    });
//    
//    //异步函数
//    dispatch_async(queue, ^{
//        NSLog(@"异步任务所在的线程----%@", [NSThread currentThread]);
//    });
//    
//    //同步函数
//    dispatch_async(queue, ^{
//        NSLog(@"同步任务所在的线程----%@", [NSThread currentThread]);
//    });
    
    dispatch_async(queue, ^{
        NSLog(@"下载图片1----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载图片2----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片3----%@", [NSThread currentThread]);
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程-----%@", [NSThread currentThread]);
        });
    });
    
    
}

@end
