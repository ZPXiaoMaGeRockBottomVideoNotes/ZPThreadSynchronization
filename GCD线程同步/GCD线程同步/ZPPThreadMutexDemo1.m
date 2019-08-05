//
//  ZPPThreadMutexDemo1.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/7/31.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPPThreadMutexDemo1.h"
#import <pthread.h>

@interface ZPPThreadMutexDemo1 ()

@property (nonatomic, assign) pthread_mutex_t mutex;

@end

@implementation ZPPThreadMutexDemo1

#pragma mark ————— 锁的初始化方法 —————
- (void)__initMutex:(pthread_mutex_t *)mutex
{
    //初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    
    //初始化锁
    pthread_mutex_init(mutex, &attr);
    
    //销毁属性
    pthread_mutexattr_destroy(&attr);
}

- (instancetype)init
{
    if (self = [super init])
    {
        //初始化锁
        [self __initMutex:&_mutex];
    }
    
    return self;
}

- (void)otherTest
{
    pthread_mutex_lock(&_mutex);
    
    NSLog(@"%s", __func__);
    
    /**
     当系统在调用otherTest1方法的时候会发现已经被上锁了，所以不会去执行otherTest1方法里面的代码，要想执行otherTest1方法里面的代码就得等待otherTest方法执行完毕（解锁）才行，但是otherTest方法里面的[self otherTest1]代码不能执行的话就不会执行下面的解锁代码，所以这个现象就如同多线程中的线程卡死一样，这里叫做“死锁”。
     */
//    [self otherTest1];
    
    /**
     当自己调用自己方法的时候就会像上面的代码一样，会出现“死锁”的现象，想要修复这个问题，就要在"__initMutex"方法中把锁的类型由"PTHREAD_MUTEX_DEFAULT"改为"PTHREAD_MUTEX_RECURSIVE"（递归锁）；
     递归锁：只允许同一个线程对一把锁进行重复加锁，其他的线程不能对递归锁进行重复加锁。例如，线程1已经对otherTest方法进行了加锁，因为是递归锁，当在线程1中再执行这个方法的时候，会给这个方法再加一次锁，然后执行里面的任务。但是当线程2执行otherTest方法的时候，发现这个方法已经被加锁了，就不能再加锁了。
     */
    [self otherTest];
    
    pthread_mutex_unlock(&_mutex);
}

- (void)otherTest1
{
    pthread_mutex_lock(&_mutex);
    
    NSLog(@"%s", __func__);
    
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
}

@end
