//
//  ZPOSSpinLockDemo1.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/7/31.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPOSSpinLockDemo1.h"
#import <libkern/OSAtomic.h>

@implementation ZPOSSpinLockDemo1

#pragma mark ————— 卖票 —————
- (void)__saleTicket
{
    /**
     使用静态变量的方式来使锁是唯一的锁，它只会初始化一次，所以每次调用这个方法的时候始终是一把锁；
     这种方式就不用定义关于锁的属性了。
     */
    static OSSpinLock ticketLock = OS_SPINLOCK_INIT;
    
    //加锁
    OSSpinLockLock(&ticketLock);
    
    [super __saleTicket];
    
    //解锁
    OSSpinLockUnlock(&ticketLock);
}

@end
