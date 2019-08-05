//
//  ZPOSSpinLockDemo.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/7/31.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPOSSpinLockDemo.h"
#import <libkern/OSAtomic.h>  //使用OSSpinLock来实现线程同步就要导入这个库。

@interface ZPOSSpinLockDemo ()

@property (nonatomic, assign) OSSpinLock moneyLock;  //要把锁写为属性，这样全局使用的就是一把锁了。
@property (nonatomic, assign) OSSpinLock ticketLock;

@end

@implementation ZPOSSpinLockDemo

- (instancetype)init
{
    if (self = [super init])
    {
        //初始化锁
        self.moneyLock = OS_SPINLOCK_INIT;
        self.ticketLock = OS_SPINLOCK_INIT;
    }
    
    return self;
}

#pragma mark ————— 存钱 —————
- (void)__saveMoney
{
    //加锁
    OSSpinLockLock(&_moneyLock);
    
    [super __saveMoney];
    
    //解锁
    OSSpinLockUnlock(&_moneyLock);
}

#pragma mark ————— 取钱 —————
- (void)__drawMoney
{
    //加锁
    OSSpinLockLock(&_moneyLock);
    
    [super __drawMoney];
    
    //解锁
    OSSpinLockUnlock(&_moneyLock);
}

#pragma mark ————— 卖票 —————
- (void)__saleTicket
{
    /**
     加锁：
     当第一条线程使用这里面的代码的时候就会先加锁，然后运行里面的代码，当第二条线程想要使用的时候就会发现已经被加锁了，然后线程就会阻塞在这里等待解锁后再使用。
     */
    OSSpinLockLock(&_ticketLock);
    
    [super __saleTicket];
    
    //解锁
    OSSpinLockUnlock(&_ticketLock);
    
    //除了上述的"OSSpinLockLock"函数之外，还有"OSSpinLockTry"（尝试加锁）函数来给代码进行加锁
//    if (OSSpinLockTry(&_lock))
//    {
//        int oldTicketsCount = self.ticketsCount;
//        sleep(0.2);
//        oldTicketsCount--;
//        self.ticketsCount = oldTicketsCount;
//
//        NSLog(@"还剩%d张票 - %@", oldTicketsCount, [NSThread currentThread]);
//
//        //解锁
//        OSSpinLockUnlock(&_lock);
//    }
}

@end
