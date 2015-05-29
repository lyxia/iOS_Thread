//
//  ViewController.m
//  NSOperationStart
//
//  Created by lyxia on 15/5/28.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

/**
 * 配合使用NSOperation和NSOperationQueue也能实现多线程编程
 * NSOperation和NSOperationQueue实现多线程的具体步骤
 * 1) 先将需要执行的操作封装到一个NSOperation对象中
 * 2) 然后将NSOperation对象添加到NSOperationQueue中
 * 3) 系统会自动将NSOperationQueue中的NSOperation取出来
 * 4) 将取出的NSOperation封装的操作放到一条新线程中执行
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self operation3];
    [self performSelectorOnMainThread:@selector(test1) withObject:nil waitUntilDone:NO];
}

/**
 * NSOperation是个抽象类，并不具备封装操作的能力，必须使用它的子类
 * NSOperation子类的方式有3种：
 * 1) NSInvocationOperation
 * 2) NSBlockOperation
 * 3) 自定义子类继承NSOperation，实现类部对应的方法
 */

//操作对象默认在主线程中执行，只有添加到队列中才会开启新的线程
//默认情况下，如果操作没有放到队列queue中，都是同步执行。
- (void)operation1
{
    //封装操作
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test) object:nil];
    //执行操作
    [operation start];
}

//只要NSBlockOperation封装的操作数 > 1，就会异步执行操作
- (void)operation2
{
    //封装操作
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperation-----%@", [NSThread currentThread]);
    }];
    
    //添加操作
    [operation addExecutionBlock:^{
        NSLog(@"NSBlockOperation1------%@", [NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^{
        NSLog(@"NSBlockOperation2-----%@", [NSThread currentThread]);
    }];
    
    //开启执行操作
    [operation start];
}

//如果将NSOperation添加到NSOperationQueue中，系统会自动异步执行NSOperation中的操作
- (void)operation3
{
    //创建NSInvocationOperation对象，封装操作
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test1) object:nil];
    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test2) object:nil];
    //创建NSBlockOperation对象，封装操作
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"NSBlockOperation3--1--%@", [NSThread currentThread]);
        }
    }];
    [operation3 addExecutionBlock:^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"NSBlockOperation3--2--%@", [NSThread currentThread]);
        }
    }];
    
    //创建NSOperationQueue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //把操作添加到队列中
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
}

- (void)test
{
    NSLog(@"--test--%@--", [NSThread currentThread]);
}

- (void)test1
{
    for (int i = 0; i < 5; i++) {
        NSLog(@"NSInvocationOperation--test1--%@", [NSThread currentThread]);
    }
}

- (void)test2
{
    for (int i = 0; i < 5; i++) {
        NSLog(@"NSInvocationOperation--test2--%@", [NSThread currentThread]);
    }
}

@end
