#iOS Thread


---------

学习文章：  
[文顶顶 多线程篇](http://www.cnblogs.com/wendingding/tag/%E5%A4%9A%E7%BA%BF%E7%A8%8B%E7%AF%87/)

---------

###阻塞主线程  
[BlockThread](https://github.com/lyxia/iOS_Thread/tree/master/BlockThread)
	
	`将比较耗时的操作放在主线程`
	
###创建线程
[CreateThread](https://github.com/lyxia/iOS_Thread/tree/master/CreateThread)  
使用原始方法创建并执行：
		
	`pthread_t thread;
	pthread_create(&pthread, NULL, run, NULL);`
		
使用NSThread创建线程并执行：
		
	`//需要手动开启
	NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"线程"];
	[thread start];
	//自动开启
	NSThread *thread1 = [[NSThread alloc] detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"自动"];`
	
使用performSelectorInBackground：
		
	`[self performSelectorInBackground:@selector(run:) withObject:@"隐式创建"];`
		
###线程安全
[ThreadSafa](https://github.com/lyxia/iOS_Thread/tree/master/ThreadSafa)  
当多个线程写同一块资源时，引发数据错乱和数据安全的问题
		
	`//加锁
	@synchronized(self){//只能加一把锁
		//加锁的代码
	}`
		
atomic加锁原理：
		
	`@property (assign, atomic) int age;
	- (void)setAge:(int)age
	{
		@synchronized(self){			
			_age = age;
		}
	}`
		
###线程通信
[ThreadSignal](https://github.com/lyxia/iOS_Thread/tree/master/ThreadSignal)  
线程间通信常用方法
		
	`- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUtilDone:(BOOL)wait;
	- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUtilDone:(BOOL)wait;
	`	
###GCD的初步认识
[GCDStart](https://github.com/lyxia/iOS_Thread/tree/master/GCDStart)  
创建串行队列
		
	`//使用dispatch_queue_create函数创建串行队列
	dispatch_queue_t queue = dispatch_queue_create(const char *label, dispatch_queue_attr_t attr);//队列名字，队列属性一般为NULL
	//使用主队列
	dispatch_queue_t queue = dispatch_get_main_queue();
		
创建并行队列
		
	//全局的并发队列
	dispatch_queue_t queue = dispatch_get_global_queue(dispatch_queue_priority_t priority, unsigned long flags);//此参数无用，用0即可`
		
异步执行
		
	`dispatch_async(queue, ^{//任务});`
		
同步执行
		
	`dispatch_sync(queue, ^{//任务});`
		
**总结**  
> 同步函数
	
>> 并发队列：不会开线程
	
>> 串行队列：不会开线程
	
>> 主队列：死循环
	
> 异步函数
	
>> 并发队列：开N条线程
	
>> 串行队列：开一条线程
	
>> 主队列：不开线程（主队列里的任务一定在主线程中执行）[MainQueue](https://github.com/lyxia/iOS_Thread/tree/master/MainQueue)
	
###线程状态
[ThreadState](https://github.com/lyxia/iOS_Thread/tree/master/ThreadState)  
> 就绪：cpu正在调用其他线程
	
> 运行：cpu调用当前线程
	
> 阻塞：线程被移出可调度线程池，此时不可调度
		
	`//阻塞的两种方法
	//第一种
	[NSThread sleepForTimeInterval:2.0];
	//第二种 以当前时间为基准阻塞
	NSDate *date = [NSDate dateWithTimeIntervalSinceNow:2.0];
	[NSThread sleepUntilDate:date];
`	
> 死亡：当线程的任务结束，发生异常，或者是强制退出这三种情况会导致线程的死亡。移出内存
		
	[NSThread exit]
		
###延迟执行、一次性代码、队列组
[DelayCall](https://github.com/lyxia/iOS_Thread/tree/master/DelayCall)  
延迟执行：
		
	`//第一种
	[self performSelector:@selector(run) withObject:nil afterDelay:2.0];
	//第二种
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    // 2秒后异步执行这里的代码...
	});`
		
[OnceCall](https://github.com/lyxia/iOS_Thread/tree/master/OnceCall)  
一次性代码：
		
	`static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
    	// 只执行1次的代码(这里面默认是线程安全的)
	});`
		
[QueueGroup](https://github.com/lyxia/iOS_Thread/tree/master/QueueGroup)  
队列组：
		
	`//1、创建一个组
	dispatch_group_t group = dispatch_group_create();
	//2、两张图同时下载
	dispatch_group_async(group, queue, ^{//下载第一张图});
	dispatch_group_async(group, queue, ^{//下载第二张图});
	//3、通知
	dispatch_group_notify(group, dispatch_get_main_queue(), ^{//等两张图都下载完成，回到主线程执行});
`		
###NSOperation的初步认识
[NSOperationStart](https://github.com/lyxia/iOS_Thread/tree/master/NSOperationStart)  
> 操作：NSOperation（抽象类）的子类：  

>> NSInvocationOperation

>> NSBlockOperation

>>> addExecutionBlock添加操作（可以添加多个操作,与外部的操作等价）

>> 自定义子类继承NSOperation,实现内部相应的⽅法(main方法)

> NSOperationQueue

>> 将NSOperation对象添加到NSOperationQueue中,系统会⾃动将NSOperationQueue中的NSOperation取出来,将取出的NSOperation封装的操作放到⼀条新线程中执⾏	

> NSOperation: -(void)start; //操作对象默认在主线程中执行，只有添加到队列中才会开启新的线程

###NSOperation的基本操作
[NSOperationBaseOpr](https://github.com/lyxia/iOS_Thread/tree/master/NSOperationBaseOpr)  
并发数：
	
	`- (NSInteger)maxConcurrentOperationCount;
	- (void)setMaxConcurrentOperationCount:(NSInteger)cnt; `
	
队列的取消，暂停和恢复：
	
	`- (void)cancelAllOperations;
	- (void)setSuspended:(BOOL)b; // YES代表暂停队列,NO代表恢复队列
	- (BOOL)isSuspended; //当前状态`

操作优先级：(说明：优先级高的任务，调用的几率会更大。)
	
	`- (NSOperationQueuePriority)queuePriority;
	- (void)setQueuePriority:(NSOperationQueuePriority)p;
	//优先级的取值
	//NSOperationQueuePriorityVeryLow = -8L,
	//NSOperationQueuePriorityLow = -4L,
	//NSOperationQueuePriorityNormal = 0,
	//NSOperationQueuePriorityHigh = 4,
	//NSOperationQueuePriorityVeryHigh = 8 `

操作依赖：（NSOperation之间可以设置依赖来保证执行顺序，⽐如一定要让操作A执行完后,才能执行操作B,可以在不同queue的NSOperation之间创建依赖关系）
	
	`[operationB addDependency:operationA]; // 操作B依赖于操作A
`	
操作的监听：
	
	`- (void (^)(void))completionBlock;
	- (void)setCompletionBlock:(void (^)(void))block; `

###自定义NSOperation
[NSOperationCustomize](https://github.com/lyxia/iOS_Thread/tree/master/NSOperationCustomize)  
实现异步加载多张图片  
加载没完成的占位图：  
![image](https://github.com/lyxia/iOS_Thread/blob/master/NSOperationCustomize/ScreenShot/loadDefaultImage.png) 

加载完成后的效果：  
![image](https://github.com/lyxia/iOS_Thread/blob/master/NSOperationCustomize/ScreenShot/loadCompeleted.png)

log：  
![image](https://github.com/lyxia/iOS_Thread/blob/master/NSOperationCustomize/ScreenShot/Log.png)
