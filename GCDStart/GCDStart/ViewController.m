//
//  ViewController.m
//  GCDStart
//
//  Created by lyxia on 15/5/27.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

/**
 * GCD全称是：Grand Central Dispatch “牛逼的中枢调度器”,纯c语言，提供了非常多强大的函数
 * GCD是苹果公司为多喝的并行运算提出的解决方案
 * GCD会自动利用更多的CPU内核（比如双核，四核）
 * GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 * GCD的两个核心概念
 * 1、任务：执行什么操作
 * 2、队列：用来存放任务
 * 将任务添加到队列中，GCD会自动将队列中的任务取出，放到对应的线程中执行
 * 任务的取出遵循FIFO原则
 */
- (IBAction)clickHandler:(UIButton *)sender {
//    //GCD默认已经提供了全局的并发对应，供整个应用使用，不需要手动创建
//    //1、获取全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//此参数暂时无用，用0即可
    //2、添加任务到队列中，就可以执行任务
    //异步函数，具备开启新线程的能力
    dispatch_async(queue, ^{
        NSLog(@"下载图片1----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片3----%@", [NSThread currentThread]);
    });
    //会开启线程，开启三个线程
    
    //1、创建串行队列
//    dispatch_queue_t queue = dispatch_queue_create("wendingding", NULL);
    //第一个参数为串行队列的名称，为C语言的字符串
    //第二个参数为队列的属性
    
//    //2、添加任务到队列中执行
//    dispatch_async(queue, ^{
//        NSLog(@"下载图片1----%@", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"下载图片2----%@", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"下载图片3----%@", [NSThread currentThread]);
//    });
    // 会开启线程，只开启一个线程;
    
    //使用sync
//    dispatch_sync(queue, ^{
//        NSLog(@"下载图片1----%@", [NSThread currentThread]);
//    });
//    dispatch_sync(queue, ^{
//        NSLog(@"下载图片1----%@", [NSThread currentThread]);
//    });
//    dispatch_sync(queue, ^{
//        NSLog(@"下载图片1----%@", [NSThread currentThread]);
//    });
    //无论是串行队列还是并行队列都不会开启线程
    
    //打印主线程
    NSLog(@"主线程----%@", [NSThread mainThread]);
}


@end
