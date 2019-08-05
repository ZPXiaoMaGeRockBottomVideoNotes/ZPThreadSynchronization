//
//  ZPOSUnfairLockDemo.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/7/31.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPOSUnfairLockDemo.h"
#import <os/lock.h>  //使用os_unfair_lock来实现线程同步就要导入这个库。

@interface ZPOSUnfairLockDemo ()

@property (nonatomic, assign) os_unfair_lock moneyLock;
@property (nonatomic, assign) os_unfair_lock ticketLock;

@end

@implementation ZPOSUnfairLockDemo

- (instancetype)init
{
    if (self = [super init])
    {
        self.moneyLock = OS_UNFAIR_LOCK_INIT;
        self.ticketLock = OS_UNFAIR_LOCK_INIT;
    }
    
    return self;
}

#pragma mark ————— 存钱 —————
- (void)__saveMoney
{
    //加锁
    os_unfair_lock_lock(&_moneyLock);
    
    [super __saveMoney];
    
    /**
     解锁：
     如果加了锁之后忘记解锁的话就会造成后面的线程无法访问了，这种现象叫做“死锁”。
     */
    os_unfair_lock_unlock(&_moneyLock);
}

#pragma mark ————— 取钱 —————
- (void)__drawMoney
{
    //加锁
    os_unfair_lock_lock(&_moneyLock);
    
    [super __drawMoney];
    
    //解锁
    os_unfair_lock_unlock(&_moneyLock);
}

#pragma mark ————— 卖票 —————
- (void)__saleTicket
{
    //加锁
    os_unfair_lock_lock(&_ticketLock);
    
    [super __saleTicket];
    
    //解锁
    os_unfair_lock_unlock(&_ticketLock);
}

@end
