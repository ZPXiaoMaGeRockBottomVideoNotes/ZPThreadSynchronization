//
//  ZPNSLockDemo.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/8/1.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPNSLockDemo.h"

@interface ZPNSLockDemo ()

@property (nonatomic, strong) NSLock *ticketLock;
@property (nonatomic, strong) NSLock *moneyLock;

@end

@implementation ZPNSLockDemo

- (instancetype)init
{
    if (self = [super init])
    {
        self.ticketLock = [[NSLock alloc] init];
        self.moneyLock = [[NSLock alloc] init];
    }
    
    return self;
}

#pragma mark ————— 存钱 —————
- (void)__saveMoney
{
    //加锁
    [self.moneyLock lock];
    
    [super __saveMoney];
    
    //解锁
    [self.moneyLock unlock];
}

#pragma mark ————— 取钱 —————
- (void)__drawMoney
{
    //加锁
    [self.moneyLock lock];
    
    [super __drawMoney];
    
    //解锁
    [self.moneyLock unlock];
}

#pragma mark ————— 卖票 —————
- (void)__saleTicket
{
    //加锁
    [self.ticketLock lock];
    
    [super __saleTicket];
    
    //解锁
    [self.ticketLock unlock];
}

@end
