//
//  ViewController.m
//  CreateThread
//
//  Created by lyxia on 15/5/27.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import "ViewController.h"
//#include  <pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    //创建、启动线程
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
//    [thread start];
//    //线程一启动就会在线程thread中执行self的run方法
//    
//    //线程的调度优先级，0.0~1.0，默认为0.5，值越大优先级越高
//    [thread setThreadPriority:0.5];
//    //设置线程名字
//    [thread setName:@"my thread"];
//    
//    [NSThread mainThread];//获取主线程
//    [NSThread isMainThread];//当前线程是否是主线程
//    [thread isMainThread];//是否为主线程
//    [NSThread currentThread];//当前线程
//    
//    //以下方法创建线程简单快捷，但是无法对线程进行更详细的设置
//    //创建并自动启动线程
//    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
//    //隐式创建并启动线程
//    [self performSelectorInBackground:@selector(run) withObject:nil];
}

- (IBAction)btnClick:(UIButton *)sender {
    //获取当前线程
    NSThread *current = [NSThread currentThread];
    //主线程
    NSLog(@"btnClick---%@", current);
    
    //使用古老的方式创建
//    pthread_t thread;
//    pthread_create(&thread, NULL, runData, NULL);
    
    [self createNSThread];
    [self createNSThread2];
    [self createNSThread3];
}

/**
 * NSThread创建线程方式1
 * 1>先创建初始化线程
 * 2>start开启线程
 */
- (void)createNSThread
{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"线程A"];
    //为线程设置一个名字
    [thread setName:@"线程A"];
    //开启线程
    [thread start];
}

/**
 * NSThread创建线程方式2
 * 创建完线程自动启动
 */
- (void)createNSThread2
{
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"创建完线程自动启动"];
}

/**
 * NSThread创建线程方式3
 * 隐式创建线程，并且直接启动
 */
- (void)createNSThread3
{
    //在后头线程中执行==在子线程中执行
    [self performSelectorInBackground:@selector(run:) withObject:@"隐式创建"];
}

//c语言函数
void *runData(void *data)
{
    //获取当前主线程，是新创建出来的线程
    NSThread *current = [NSThread currentThread];
    
    for (int i = 0; i < 10000; i++) {
        NSLog(@"btnClick---%d---%@", i, current);
    }
    return NULL;
}

- (void)run:(NSString *)str
{
    //获取当前线程
    NSThread *current = [NSThread currentThread];
    //打印输出
    for (int i = 0; i < 10; i++) {
        NSLog(@"run ----- %@ ---- %@", current, str);
    }
}

//多个线程，点击按钮执行按钮调用方法的时候主线程没有阻塞

@end
