//
//  ZPSynchronizedDemo.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/8/2.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPSynchronizedDemo.h"

@implementation ZPSynchronizedDemo

#pragma mark ————— 存钱 —————
- (void)__saveMoney
{
    /**
     @synchronized是对mutex递归锁的封装;
     小括号里面的内容可以视为锁。
     */
    @synchronized (self) {
        [super __saveMoney];
    }
}

#pragma mark ————— 取钱 —————
- (void)__drawMoney
{
    @synchronized (self) {
        [super __drawMoney];
    }
}

#pragma mark ————— 卖票 —————
- (void)__saleTicket
{
    /**
     不管子线程执行几次，下面的lock都是同一个对象，因为lock对象只会初始化一次。
     */
    static NSObject *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSObject alloc] init];
    });
    
    @synchronized (lock) {
        [super __saleTicket];
    }
}

@end
