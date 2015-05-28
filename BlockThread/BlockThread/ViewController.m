//
//  ViewController.m
//  BlockThread
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
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnClick:(UIButton *)sender {
    //1 获取当前线程
    NSThread *current = [NSThread currentThread];
    //2 使用for循环执行一些耗时的操作
    for (int i = 0; i < 10000; i++) {
        //3 输出线程
        NSLog(@"btnClick---%d----%@", i, current);
    }
}

@end
