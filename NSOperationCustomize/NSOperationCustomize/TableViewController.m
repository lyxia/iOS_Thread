//
//  TableViewController.m
//  NSOperationCustomize
//
//  Created by lyxia on 15/5/28.
//  Copyright (c) 2015年 lyxia. All rights reserved.
//

#import "TableViewController.h"
#import "AppModel.h"
#import "DownLoadOperation.h"

@interface TableViewController () <DownLoadOperationDelegate>
@property (nonatomic, strong) NSArray *apps;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableDictionary *operations;
@property (nonatomic, strong) NSMutableDictionary *images;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -懒加载
- (NSArray *)apps
{
    if (!_apps) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil];
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:path];
        
        //字典转模型
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in tempArray) {
            AppModel *app = [AppModel appModelWithDict:dict];
            [array addObject:app];
        }
        
        _apps = array;
    }
    return _apps;
}

- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:3];
    }
    return _queue;
}

- (NSMutableDictionary *)operations
{
    if (!_operations) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

- (NSMutableDictionary *)images
{
    if (!_images) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.apps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    AppModel *app = [self.apps objectAtIndex:indexPath.row];
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.download;
    
    //保证一个url对应一个image对象
    UIImage *image = self.images[app.icon];
    if (image) {
        //缓存中有图片
        [cell.imageView setImage:image];
    } else {
        //缓存中没图片，得下载
        //先设置一张占位图片
        [cell.imageView setImage:[UIImage imageNamed:@"default"]];
        DownLoadOperation *operation = self.operations[app.icon];
        if (operation) {
            //正在下载
            //什么都不做
        } else {
            //当前没有下载，那就创建操作
            operation = [[DownLoadOperation alloc] init];
            operation.url = app.icon;
            operation.indexPath = indexPath;
            operation.delegate = self;
            //异步下载
            [self.queue addOperation:operation];
            //缓存下operation
            [self.operations setObject:operation forKey:app.icon];
        }
    }
    
    return cell;
}

#pragma mark - DownLoadOperationDelegate
- (void)downLoadOperation:(DownLoadOperation *)operation didFishedDownLoad:(UIImage *)image
{
    //移除执行完毕的操作
    [self.operations removeObjectForKey:operation.url];
    
    //将图片放到缓存中
    [self.images setObject:image forKey:operation.url];
    
    //刷新表格，只刷新下载的哪一行
    [self.tableView reloadRowsAtIndexPaths:@[operation.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSLog(@"--%ld--%@--", (long)operation.indexPath.row, [NSThread currentThread]);
}

@end
