//
//  ZPDispatchSemaphoreDemo.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/8/2.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPDispatchSemaphoreDemo.h"

@interface ZPDispatchSemaphoreDemo ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;  //信号量
@property (nonatomic, strong) dispatch_semaphore_t ticketSemaphore;
@property (nonatomic, strong) dispatch_semaphore_t moneySemaphore;

@end

@implementation ZPDispatchSemaphoreDemo

- (instancetype)init
{
    if (self = [super init])
    {
        /**
         初始化信号量：
         方法中的参数就是信号量的初始值，通过设置这个初始值可以用来控制线程并发访问的最大数量；
         信号量的值设置为5就代表每次有5个子线程在执行任务。
         */
        self.semaphore = dispatch_semaphore_create(5);
        self.ticketSemaphore = dispatch_semaphore_create(1);
        self.moneySemaphore = dispatch_semaphore_create (1);
    }
    
    return self;
}

- (void)otherTest
{
    //创建20条子线程来执行test任务
    for (int i = 0; i < 20; i++)
    {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
}

- (void)test
{
    /**
     这个函数的意思是，如果在执行这个函数之前信号量的值是大于0的话，则让信号量的值减1，然后再继续执行下面的代码；
     根据以上的说法，现在信号量的值是5，当第一条子线程执行这个test方法的时候，当执行下面函数的时候，信号量的值会由5变为4，然后再执行下面的代码。当第二条子线程执行这个test方法的时候，信号量的值会由4变为3。当执行第三条子线程的时候，信号量的值会由3变为2。当执行第四条子线程的时候，信号量的值会由2变为1。当执行第五条子线程的时候，信号量的值会由1变为了0。当执行第六条子线程的时候，此时信号量的值是0，如果信号量的值小于等于0的话就会让即将执行的这条子线程休眠，直到信号量的值再次变为大于0的时候再执行；
     函数中"DISPATCH_TIME_FOREVER"参数的意思是一直等待信号量的值大于0。"DISPATCH_TIME_NOW"的意思是判断当下的信号量的值是否大于0，要是大于0的话就继续执行子线程中的任务，要是小于等于0的话就不继续执行了。
     */
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    sleep(2);
    NSLog(@"test - %@", [NSThread currentThread]);
    
    /**
     当运行下面这句函数的时候会使信号量的值加1。比如前述的当执行第五条子线程的时候信号量的值由1变为了0，然后继续执行下面的代码，当执行到这句函数的时候，给信号量的值加1，即由0又变成了1了，这样的话原来处于休眠等待状态的第六条子线程就能捕捉到，然后系统就开始执行第六条子线程，如此往复不止。
     */
    dispatch_semaphore_signal(self.semaphore);
}

#pragma mark ————— 存钱 —————
- (void)__saveMoney
{
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);
    
    [super __saveMoney];
    
    dispatch_semaphore_signal(self.moneySemaphore);
}

#pragma mark ————— 取钱 —————
- (void)__drawMoney
{
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);
    
    [super __drawMoney];
    
    dispatch_semaphore_signal(self.moneySemaphore);
}

#pragma mark ————— 卖票 —————
- (void)__saleTicket
{
    dispatch_semaphore_wait(self.ticketSemaphore, DISPATCH_TIME_FOREVER);
    
    [super __saleTicket];
    
    dispatch_semaphore_signal(self.ticketSemaphore);
}

@end
