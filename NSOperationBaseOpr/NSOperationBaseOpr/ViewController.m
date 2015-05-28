//
//  ViewController.m
//  NSOperationBaseOpr
//
//  Created by lyxia on 15/5/28.
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
    [self operation1];
}

/**
 * 并发数：
 * maxConcurrentOperationCount 最大并发数：同一时间最多只能执行的任务的个数
 * 如果没有设置，是由系统内存和cpu决定，内存多久开多一点，内存少就开少一点
 * 最好5以内，一般以2~3为宜
 */

/**
 * 取消队列的所有操作：-(void)cancleAllOperations;
 * 取消单个操作：NSOperation的 - (void)cancle;
 * 暂停和恢复队列：- (void)setSuspended:(BOOL)b;//YES代表暂停队列，NO代表恢复队列
 * -(BOOL)isSuspended; //当前状态
 */

/**
 * 操作优先级：- (NSOperationQueuePriority)queuePriority;
 * NSOperationQueuePriorityVeryLow = -8L,
 * NSOperationQueuePriorityLow = -4L,
 * NSOperationQueuePriorityNormal = 0,
 * NSOperationQueuePriorityHigh = 4,
 * NSOperationQueuePriorityVeryHigh = 8
 */

/**
 * 操作依赖
 * NSOperation之间可以设置依赖来保证执行顺序
 * [B addDependency:A];//操作B依赖于操作A
 * 可以在不同queue的NSOperation之间创建依赖关系
 * 不可以循环依赖
 */
- (void)operation1
{
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test1) object:nil];
    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test2) object:nil];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"NSBlockOperation3--1---%@", [NSThread currentThread]);
        }
    }];
    [operation3 addExecutionBlock:^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"NSBlockOperation3--2--%@", [NSThread currentThread]);
        }
    }];
    
    //设置操作依赖
    [operation3 addDependency:operation1];
    [operation1 addDependency:operation2];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
}

- (void)test1
{
    for (int i = 0; i < 10; i++) {
        NSLog(@"NSInvocationOperation1--%@", [NSThread currentThread]);
    }
}

- (void)test2
{
    for (int i = 0; i < 10; i++) {
        NSLog(@"NSInvocationOperation2--%@", [NSThread currentThread]);
    }
}

/**
 * 操作的监听
 * - (void(^)(void))completionBlock; //可以监听一个操作的执行完毕
 */
- (void)operation2
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"-operation-下载图片-%@", [NSThread currentThread]);
        }
    }];
    
    //监听操作的执行完毕
    [operation setCompletionBlock:^{
        NSLog(@"--接着下载第二张图片--%@", [NSThread currentThread]);
    }];
    
    //创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //把任务添加到队列中（自动执行，自动开启线程）
    [queue addOperation:operation];
}

@end
