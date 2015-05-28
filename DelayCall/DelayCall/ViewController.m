//
//  ViewController.m
//  DelayCall
//
//  Created by lyxia on 15/5/27.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self delayCall1];
//    [self delayCall2];
//    [self delayCall3];
//    [self delayCall4];
    [self delayCall5];
}

//该方法在哪个线程调用，那么run就在哪个线程（当前线程）执行，通常是主线程
- (void)delayCall1
{
    NSLog(@"performSelector----打印线程----%@", [NSThread currentThread]);
    [self performSelector:@selector(run:) withObject:@"延迟执行" afterDelay:3.0];
}

//注意，在异步函数中执行performSelector不会被调用(不知道是什么原因)
- (void)delayCall2
{
    dispatch_queue_t queue = dispatch_queue_create("wendingding", 0);
    dispatch_async(queue, ^{
        [self performSelector:@selector(run:) withObject:@"异步函数中延迟执行" afterDelay:3.0];
    });
    NSLog(@"异步线程");
}

//同步函数中执行performSelector
//如果是主队列，那么就在主线程中执行，如果队列是并发队列，那么会开启一个线程，在子线程中执行
- (void)delayCall3
{
    dispatch_queue_t queue = dispatch_queue_create("wendingding", 0);
    dispatch_sync(queue, ^{
        [self performSelector:@selector(run:) withObject:@"同步函数中延迟执行" afterDelay:3.0];
    });
    NSLog(@"同步线程");
}

//使用GCD方法延迟执行
- (void)delayCall4
{
    NSLog(@"CGD----打印线程----%@", [NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self run:@"GCD延迟执行"];
    });
}

//GCD在并发队列执行延迟
- (void)delayCall5
{
    NSLog(@"CGD---打印线程---%@", [NSThread currentThread]);
    //获取并发全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //计算任务执行的时间
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
    //会在when这个时间点执行queue中的这个任务
    dispatch_after(when, queue, ^{
        [self run:@"并发队列延迟执行"];
    });
}

- (void)run:(NSString *)str
{
    NSLog(@"%@----%@", str, [NSThread currentThread]);
}

@end
