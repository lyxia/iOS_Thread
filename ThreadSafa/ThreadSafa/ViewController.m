//
//  ViewController.m
//  ThreadSafa
//
//  Created by lyxia on 15/5/27.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, assign) int leftTicketsCount;
@property (nonatomic, strong) NSThread *thread1;
@property (nonatomic, strong) NSThread *thread2;
@property (nonatomic, strong) NSThread *thread3;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //默认有10张票
    self.leftTicketsCount = 10;
    
    //开启多个线程模拟售票员售票
    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
    [self.thread1 setName:@"售票员A"];
    self.thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
    [self.thread2 setName:@"售票员B"];
    self.thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
    [self.thread3 setName:@"售票员C"];
}

/**
 * 互斥锁能有效防止因多线程抢夺资源造成的数据安全问题，但是需要消耗大量的cpu资源，使用前提：多条线程抢夺同一块资源（写）
 * atomic：原子属性，为setter方法加锁（默认就是atomic）
 * @property (assign, atomic) int age;
 * - (void)setAge:(int)age
 * {
 *    @synchronized(self){ _age = age;}
 * }
 * noatomic：非原子属性，不会为setter方法加锁
 */
- (void)sellTickets
{
    while (1) {
        //尽量避免多线程抢夺同一块资源
        //尽量将加锁、资源抢夺的业务逻辑交给服务器端处理，减少移动客户端的压力
        @synchronized(self){//只能加一把锁
            //1、先检查票数
            int count = self.leftTicketsCount;
            if (count > 0) {
                //暂停一段时间
                [NSThread sleepForTimeInterval:0.002];
                //票数-1
                self.leftTicketsCount = count - 1;
                //获取当前线程
                NSThread *current = [NSThread currentThread];
                NSLog(@"%@--卖了一张票，还剩余%d张票", current, self.leftTicketsCount);
            } else {
                [NSThread exit];
            }
        }
    }
}

- (IBAction)startTicket:(UIButton *)sender {
    [self.thread1 start];
    [self.thread2 start];
    [self.thread3 start];
}
@end
