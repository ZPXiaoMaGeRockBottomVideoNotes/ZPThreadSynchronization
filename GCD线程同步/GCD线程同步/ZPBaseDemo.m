//
//  ZPBaseDemo.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/7/30.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPBaseDemo.h"

@interface ZPBaseDemo ()

@property (nonatomic, assign) int ticketsCount;
@property (nonatomic, assign) int money;

@end

@implementation ZPBaseDemo

- (void)moneyTest
{
    self.money = 100;
    
    //获取全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++)
        {
            [self __saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++)
        {
            [self __drawMoney];
        }
    });
}

#pragma mark ————— 存钱 —————
- (void)__saveMoney
{
    int oldMoney = self.money;
    sleep(0.2);
    oldMoney += 50;
    self.money = oldMoney;
    
    NSLog(@"存50，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

#pragma mark ————— 取钱 —————
- (void)__drawMoney
{
    int oldMoney = self.money;
    sleep(0.2);
    oldMoney -= 20;
    self.money = oldMoney;
    
    NSLog(@"取20，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

- (void)ticketsTest
{
    self.ticketsCount = 15;
    
    //获取全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++)
        {
            [self __saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saleTicket];
        }
    });
}

#pragma mark ————— 卖票 —————
- (void)__saleTicket
{
    int oldTicketsCount = self.ticketsCount;
    sleep(0.2);
    oldTicketsCount--;
    self.ticketsCount = oldTicketsCount;
    
    NSLog(@"还剩%d张票 - %@", oldTicketsCount, [NSThread currentThread]);
}

- (void)otherTest
{
    ;
}

@end
