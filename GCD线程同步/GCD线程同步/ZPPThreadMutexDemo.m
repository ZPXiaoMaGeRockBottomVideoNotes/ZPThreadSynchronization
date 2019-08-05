//
//  ZPPThreadMutexDemo.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/7/31.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPPThreadMutexDemo.h"
#import <pthread.h>  //使用pthread_mutex来实现线程同步就要导入这个库。

@interface ZPPThreadMutexDemo ()

@property (nonatomic, assign) pthread_mutex_t ticketMutex;
@property (nonatomic, assign) pthread_mutex_t moneyMutex;

@end

@implementation ZPPThreadMutexDemo

#pragma mark ————— 锁的初始化方法 —————
- (void)__initMutex:(pthread_mutex_t *)mutex
{
    //初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);  //最后一个参数用来设置锁的类型
    
    //初始化锁
    pthread_mutex_init(mutex, &attr);
    
    //销毁属性
    pthread_mutexattr_destroy(&attr);
}

- (instancetype)init
{
    if (self = [super init])
    {
        //初始化两个锁
        [self __initMutex:&_ticketMutex];
        [self __initMutex:&_moneyMutex];
    }
    
    return self;
}

#pragma mark ————— 存钱 —————
- (void)__saveMoney
{
    //加锁
    pthread_mutex_lock(&_moneyMutex);
    
    [super __saveMoney];
    
    //解锁
    pthread_mutex_unlock(&_moneyMutex);
}

#pragma mark ————— 取钱 —————
- (void)__drawMoney
{
    //加锁
    pthread_mutex_lock(&_moneyMutex);
    
    [super __drawMoney];
    
    //解锁
    pthread_mutex_unlock(&_moneyMutex);
}

#pragma mark ————— 卖票 —————
- (void)__saleTicket
{
    //加锁
    pthread_mutex_lock(&_ticketMutex);
    
    [super __saleTicket];
    
    //解锁
    pthread_mutex_unlock(&_ticketMutex);
}

- (void)dealloc
{
    //在对象被销毁的时候也要把锁都销毁了。
    pthread_mutex_destroy(&_ticketMutex);
    pthread_mutex_destroy(&_moneyMutex);
}

@end
