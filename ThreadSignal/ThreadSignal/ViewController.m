//
//  ViewController.m
//  ThreadSignal
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

- (IBAction)startDown:(UIButton *)sender {
    //在子线程中调用download方法下载图片
    [self performSelectorInBackground:@selector(download) withObject:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //在子线程中调用download方法下载图片
    [self performSelectorInBackground:@selector(download) withObject:nil];
}

- (void)download
{
    //根据url下载图片
    //从网络中下载图片
    NSURL *urlstr = [NSURL URLWithString:@"fdsf"];
    
    //把图片转为二进制的数据
    NSData *data = [NSData dataWithContentsOfURL:urlstr];//这一行操作比较耗时
    
    //把数据转换成图片
    UIImage *image = [UIImage imageWithData:data];
    
    //回到主线程中设置图片
    [self performSelectorOnMainThread:@selector(settingImage:) withObject:image waitUntilDone:NO];
}

- (void)settingImage:(UIImage *)image
{
    NSLog(@"设置图片");
}

@end
