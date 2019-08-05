//
//  ZPSerialQueueDemo.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/8/2.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPSerialQueueDemo.h"

@interface ZPSerialQueueDemo ()

@property (nonatomic, strong) dispatch_queue_t ticketQueue;
@property (nonatomic, strong) dispatch_queue_t moneyQueue;

@end

@implementation ZPSerialQueueDemo

- (instancetype)init
{
    if (self = [super init])
    {
        //创建串行队列
        self.ticketQueue = dispatch_queue_create("ticketQueue", DISPATCH_QUEUE_SERIAL);
        self.moneyQueue = dispatch_queue_create("moneyQueue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

#pragma mark ————— 存钱 —————
- (void)__saveMoney
{
    /**
     在调用本方法的时候就已经在一条子线程中了，由于是串行队列和同步函数，所以block里面的任务就在当前的子线程中执行。
     */
    dispatch_sync(self.moneyQueue, ^{
        [super __saveMoney];
    });
}

#pragma mark ————— 取钱 —————
- (void)__drawMoney
{
    dispatch_sync(self.moneyQueue, ^{
        [super __drawMoney];
    });
}

#pragma mark ————— 卖票 —————
- (void)__saleTicket
{
    dispatch_sync(self.ticketQueue, ^{
        [super __saleTicket];
    });
}

@end
