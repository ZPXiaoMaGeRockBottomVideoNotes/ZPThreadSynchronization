//
//  ViewController.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/7/30.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 多线程的安全隐患：
 资源共享：一块资源可能会被多个线程共享，也就是多个线程可能会访问同一块资源，比如多个线程访问同一个对象、同一个变量、同一个文件，当多个线程访问同一块资源时，很容易引发数据错乱和数据安全的问题。
 
 解决方案：
 使用线程同步技术（同步，就是协同步调，按预定的先后次序进行），常见的线程同步技术是加锁。在一条线程使用某块资源的时候给这块资源加锁，使之不能被其他线程所修改，等这块资源被使用完毕之后再进行解锁，这样其他的线程就能继续再使用这块资源了。
 
 iOS中的线程同步方案：
 1、OSSpinLock：
 （1）叫做”自旋锁”，等待锁的线程会处于忙等（busy-wait）状态，类似于一个while循环，一直占用着CPU的资源；
 （2）目前已经不再安全，可能会出现优先级反转问题。即如果等待锁的线程优先级较高，它会一直占用着CPU资源，优先级低的线程就无法释放锁。
 2、os_unfair_lock：
 （1）os_unfair_lock用于取代不安全的OSSpinLock ，从iOS10开始才支持的；
 （2）从底层调用看，等待os_unfair_lock锁的线程会处于休眠状态，并非忙等，所以它可以算作“互斥锁”。
 3、pthread_mutex：mutex叫做”互斥锁”，等待锁的线程会处于休眠状态。
 4、dispatch_semaphore：信号量，信号量的初始值可以用来控制线程并发访问的最大数量。信号量的初始值为1，代表同时只允许1条线程访问资源，保证线程同步。
 5、dispatch_queue(DISPATCH_QUEUE_SERIAL)：串行队列，直接使用GCD的串行队列也是可以实现线程同步的。
 6、NSLock：NSLock是对mutex普通锁的封装。
 7、NSRecursiveLock：NSRecursiveLock也是对mutex递归锁的封装，API跟NSLock基本一致。
 8、NSCondition：NSCondition是对mutex和cond的封装。
 9、NSConditionLock（条件锁）：NSConditionLock是对NSCondition的进一步封装，可以设置具体的条件值。条件锁会决定多个线程运行的先后顺序。
 10、@synchronized：@synchronized是对mutex递归锁的封装。
 
 iOS线程同步方案性能比较（性能从高到低排序）：
 1、os_unfair_lock
 2、OSSpinLock
 3、dispatch_semaphore
 4、pthread_mutex
 5、dispatch_queue(DISPATCH_QUEUE_SERIAL)
 6、NSLock
 7、NSCondition
 8、pthread_mutex(recursive)
 9、NSRecursiveLock
 10、NSConditionLock
 11、@synchronized
 一般推荐使用dispatch_semaphore和pthread_mutex线程同步方式。
 */
#import "ViewController.h"
#import "ZPBaseDemo.h"
#import "ZPOSSpinLockDemo.h"
#import "ZPOSSpinLockDemo1.h"
#import "ZPOSUnfairLockDemo.h"
#import "ZPPThreadMutexDemo.h"
#import "ZPPThreadMutexDemo1.h"
#import "ZPPThreadMutexDemo2.h"
#import "ZPNSLockDemo.h"
#import "ZPNSConditionDemo.h"
#import "ZPNSConditionLockDemo.h"
#import "ZPSerialQueueDemo.h"
#import "ZPDispatchSemaphoreDemo.h"
#import "ZPSynchronizedDemo.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //使用OSSpinLock来进行线程同步
//    [self OSSpinLockTest];
    
    //使用OSSpinLock来进行线程同步的另一种方式
//    [self OSSpinLockTest1];
    
    //使用os_unfair_lock来进行线程同步
//    [self os_unfair_lockTest];
    
    //使用pthread_mutex来进行线程同步
//    [self pthread_mutexTest];
    
    //递归锁
//    [self ZPPThreadMutexDemo1Test];
    
    //pthread_mutex锁的条件的的应用
//    [self pthread_cond_tTest];
    
    //使用NSLock来进行线程同步
//    [self NSLockTest];
    
    //使用NSCondition来进行线程同步
//    [self NSConditionTest];
    
    //使用NSConditionLock来决定多个线程执行的先后顺序
//    [self NSConditionLockTest];
    
    //使用串行队列来进行线程同步
//    [self serialQueueTest];
    
    //使用信号量来进行线程同步
//    [self dispatchSemaphoreTest];
    
    //使用@synchronized来进行线程同步
    [self synchronizedTest];
}

#pragma mark ————— 使用OSSpinLock来进行线程同步 —————
- (void)OSSpinLockTest
{
    ZPOSSpinLockDemo *demo = [[ZPOSSpinLockDemo alloc] init];
    [demo ticketsTest];
    [demo moneyTest];
}

#pragma mark ————— 使用OSSpinLock来进行线程同步的另一种方式 —————
- (void)OSSpinLockTest1
{
    ZPOSSpinLockDemo1 *demo = [[ZPOSSpinLockDemo1 alloc] init];
    
    [demo ticketsTest];
}

#pragma mark ————— 使用os_unfair_lock来进行线程同步 —————
- (void)os_unfair_lockTest
{
    ZPOSUnfairLockDemo *demo = [[ZPOSUnfairLockDemo alloc] init];
    [demo ticketsTest];
    [demo moneyTest];
}

#pragma mark ————— 使用pthread_mutex来进行线程同步 —————
- (void)pthread_mutexTest
{
    ZPPThreadMutexDemo *demo = [[ZPPThreadMutexDemo alloc] init];
    [demo ticketsTest];
    [demo moneyTest];
}

#pragma mark ————— 递归锁 —————
- (void)ZPPThreadMutexDemo1Test
{
    ZPPThreadMutexDemo1 *demo = [[ZPPThreadMutexDemo1 alloc] init];
    [demo otherTest];
}

#pragma mark ————— pthread_mutex锁的条件的的应用 —————
- (void)pthread_cond_tTest
{
    ZPPThreadMutexDemo2 *demo = [[ZPPThreadMutexDemo2 alloc] init];
    [demo otherTest];
}

#pragma mark ————— 使用NSLock来进行线程同步 —————
- (void)NSLockTest
{
    ZPNSLockDemo *demo = [[ZPNSLockDemo alloc] init];
    [demo ticketsTest];
    [demo moneyTest];
}

#pragma mark ————— 使用NSCondition来进行线程同步 —————
- (void)NSConditionTest
{
    ZPNSConditionDemo *demo = [[ZPNSConditionDemo alloc] init];
    [demo otherTest];
}

#pragma mark ————— 使用NSConditionLock来决定多个线程执行的先后顺序 —————
- (void)NSConditionLockTest
{
    ZPNSConditionLockDemo *demo = [[ZPNSConditionLockDemo alloc] init];
    [demo otherTest];
}

#pragma mark ————— 使用串行队列来进行线程同步 —————
- (void)serialQueueTest
{
    ZPSerialQueueDemo *demo = [[ZPSerialQueueDemo alloc] init];
    [demo ticketsTest];
    [demo moneyTest];
}

#pragma mark ————— 使用信号量来进行线程同步 —————
- (void)dispatchSemaphoreTest
{
    ZPDispatchSemaphoreDemo *demo = [[ZPDispatchSemaphoreDemo alloc] init];
//    [demo otherTest];
    [demo ticketsTest];
    [demo moneyTest];
}

#pragma mark ————— 使用@synchronized来进行线程同步 —————
- (void)synchronizedTest
{
    ZPSynchronizedDemo *demo = [[ZPSynchronizedDemo alloc] init];
    [demo ticketsTest];
    [demo moneyTest];
}

@end
