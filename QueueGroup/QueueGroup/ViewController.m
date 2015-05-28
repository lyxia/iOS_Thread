//
//  ViewController.m
//  QueueGroup
//
//  Created by lyxia on 15/5/28.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import "ViewController.h"

//宏定义全局并发队列
#define global_queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//宏定义主队列
#define main_queue dispatch_get_main_queue()

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self loadImage1];
    [self loadImage2];
}

//这种方式的效率不高，需要等到图片1下载完后，图片2才开始下载
- (void)loadImage1
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(global_queue, ^{
            //下载图片1
            UIImage *image1 = [self imageWithUrl:@"http://img02.zhaopin.cn/img_button/201505/22/55757322sy111.jpg"];
            NSLog(@"图片1下载完成----%@", [NSThread currentThread]);
            
            //下载图片2
            UIImage *image2 = [self imageWithUrl:@"http://img00.zhaopin.cn/img_button/201505/25/adalunbo.jpg"];
            NSLog(@"图片2下载完成----%@", [NSThread currentThread]);
            
            //回到主线程显示图片
            dispatch_async(main_queue, ^{
                NSLog(@"显示图片----%@", [NSThread currentThread]);
                [self.imageView1 setImage:image1];
                [self.imageView2 setImage:image2];
                //合并两张图片
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(644, 173), NO, 0.0);
                [image1 drawInRect:CGRectMake(0, 0, 322, 173)];
                [image2 drawInRect:CGRectMake(322, 0, 322, 173)];
                [self.imageView3 setImage:UIGraphicsGetImageFromCurrentImageContext()];
                //关闭上下文
                UIGraphicsEndImageContext();
                NSLog(@"图片合并完毕-----%@", [NSThread currentThread]);
            });
        });
    });
}

//使用队列组可以让图片1和图片2的下载任务同时进行
//且当两个下载任务都完成的时候回到主线程进行显示
- (void)loadImage2
{
    //1、创建一个队列组
    dispatch_group_t group = dispatch_group_create();
    
    //2、开启一个任务下载图片1
    __block UIImage *image1 = nil;
    dispatch_group_async(group, global_queue, ^{
        image1 = [self imageWithUrl:@"http://img02.zhaopin.cn/img_button/201505/22/55757322sy111.jpg"];
        NSLog(@"图片1下载完成----%@", [NSThread currentThread]);
    });
    
    //3、开启一个任务下载图片2
    __block UIImage *image2 = nil;
    dispatch_group_async(group, global_queue, ^{
        image2 = [self imageWithUrl:@"http://img00.zhaopin.cn/img_button/201505/25/adalunbo.jpg"];
        NSLog(@"图片2下载完成----%@", [NSThread currentThread]);
    });
    
    //4、等group中的所有任务都执行完毕，再回到主线程执行其他操作
    dispatch_group_notify(group, main_queue, ^{
        NSLog(@"显示图片----%@", [NSThread currentThread]);
        [self.imageView1 setImage:image1];
        [self.imageView2 setImage:image2];
        //合并两张图片
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(644, 173), NO, 0.0);
        [image1 drawInRect:CGRectMake(0, 0, 322, 173)];
        [image2 drawInRect:CGRectMake(322, 0, 322, 173)];
        [self.imageView3 setImage:UIGraphicsGetImageFromCurrentImageContext()];
        //关闭上下文
        UIGraphicsEndImageContext();
        NSLog(@"图片合并完毕-----%@", [NSThread currentThread]);
    });
}

- (UIImage *)imageWithUrl:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

@end
