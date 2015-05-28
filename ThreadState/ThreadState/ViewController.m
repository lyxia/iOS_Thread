//
//  ViewController.m
//  ThreadState
//
//  Created by lyxia on 15/5/27.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import "ViewController.h"

/**
 * 线程的状态
 * 运行：cpu调度当前线程
 * 阻塞：从线程池中移除，此时不可调度
 * 就绪：cpu正在调度别的线程
 * 结束：从内存中移除，线程任务结束，发生异常，或强制退出
 */
@interface ViewController ()
@property (nonatomic, strong) NSThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建线程
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil];
    //设置线程名字
    [self.thread setName:@"线程A"];
}

//当手指按下的时候，开启线程
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //开启线程
    [self.thread start];
}

- (void)test
{
    //获取线程
    NSThread *current = [NSThread currentThread];
    NSLog(@"test----打印线程----%@", self.thread.name);
    NSLog(@"test----线程开始----%@", current.name);
    
    //设置线程阻塞
    NSLog(@"接下来，线程阻塞2秒");
    [NSThread sleepForTimeInterval:2];
    NSLog(@"接下来，线程阻塞4秒");
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:4];
    [NSThread sleepUntilDate:date];
    for (int i = 0; i < 20; i++) {
        NSLog(@"线程--%d---%@",i,current.name);
        if (5==i) {
            //结束线程,重新开启线程会挂
            [NSThread exit];
        }
    }
    
    NSLog(@"线程结束----%@", current.name);
}

@end
