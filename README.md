#iOS Thread


---------

###阻塞主线程  
**<font color='0xff000000'>BlockThread</font>**  
	
	将比较耗时的操作放在主线程
	
###创建线程
**<font color='0xff000000'>CreateThread</font>**  
使用原始方法创建并执行：
		
	pthread_t thread;
	pthread_create(&pthread, NULL, run, NULL);
		
使用NSThread创建线程并执行：
		
	//需要手动开启
	NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"线程"];
	[thread start];
	//自动开启
	NSThread *thread1 = [[NSThread alloc] detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"自动"];
	
使用performSelectorInBackground：
		
	[self performSelectorInBackground:@selector(run:) withObject:@"隐式创建"];
		
###线程安全
**<font color='0xff000000'>ThreadSafa</font>**  
当多个线程写同一块资源时，引发数据错乱和数据安全的问题
		
	//加锁
	@synchronized(self){//只能加一把锁
		//加锁的代码
	}
		
atomic加锁原理：
		
	@property (assign, atomic) int age;
	- (void)setAge:(int)age
	{
		@synchronized(self){			
			_age = age;
		}
	}
		
###线程通信
**<font color='0xff000000'>ThreadSignal</font>**  
线程间通信常用方法
		
	- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUtilDone:(BOOL)wait;
	- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUtilDone:(BOOL)wait;
		
###GCD的初步认识
**<font color='0xff000000'>GCDStart</font>**  
创建串行队列
		
	//使用dispatch_queue_create函数创建串行队列
	dispatch_queue_t queue = dispatch_queue_create(const char *label, dispatch_queue_attr_t attr);//队列名字，队列属性一般为NULL
	//使用主队列
	dispatch_queue_t queue = dispatch_get_main_queue();
		
创建并行队列
		
	//全局的并发队列
	dispatch_queue_t queue = dispatch_get_global_queue(dispatch_queue_priority_t priority, unsigned long flags);//此参数无用，用0即可
		
异步执行
		
	dispatch_async(queue, ^{//任务});
		
同步执行
		
	dispatch_sync(queue, ^{//任务});
		
**总结**  
> 同步函数
	
>> 并发队列：不会开线程
	
>> 串行队列：不会开线程
	
>> 主队列：死循环
	
> 异步函数
	
>> 并发队列：开N条线程
	
>> 串行队列：开一条线程
	
>> 主队列：不开线程（主队列里的任务一定在主线程中执行）**<font color='0xff000000'>MainQueue</font>**
	
###线程状态
**<font color='0xff000000'>ThreadState</font>**  
> 就绪：cpu正在调用其他线程
	
> 运行：cpu调用当前线程
	
> 阻塞：线程被移出可调度线程池，此时不可调度
		
	//阻塞的两种方法
	//第一种
	[NSThread sleepForTimeInterval:2.0];
	//第二种 以当前时间为基准阻塞
	NSDate *date = [NSDate dateWithTimeIntervalSinceNow:2.0];
	[NSThread sleepUntilDate:date];
	
> 死亡：当线程的任务结束，发生异常，或者是强制退出这三种情况会导致线程的死亡。移出内存
		
	[NSThread exit]
		
###延迟执行、一次性代码、队列组
**<font color='0xff000000'>DelayCall，OnceCall，QueueGroup</font>**  
延迟执行：
		
	//第一种
	[self performSelector:@selector(run) withObject:nil afterDelay:2.0];
	//第二种
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    // 2秒后异步执行这里的代码...
	});
		
一次性代码：
		
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
    	// 只执行1次的代码(这里面默认是线程安全的)
	});
		
队列组：
		
	//1、创建一个组
	dispatch_group_t group = dispatch_group_create();
	//2、两张图同时下载
	dispatch_group_async(group, queue, ^{//下载第一张图});
	dispatch_group_async(group, queue, ^{//下载第二张图});
	//3、通知
	dispatch_group_notify(group, dispatch_get_main_queue(), ^{//等两张图都下载完成，回到主线程执行});
		
###NSOperation
