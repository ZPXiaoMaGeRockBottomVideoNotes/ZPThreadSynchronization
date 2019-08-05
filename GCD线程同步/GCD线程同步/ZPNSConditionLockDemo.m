//
//  ZPNSConditionLockDemo.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/8/1.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPNSConditionLockDemo.h"

@interface ZPNSConditionLockDemo ()

@property (nonatomic, strong) NSConditionLock *conditionLock;

@end

@implementation ZPNSConditionLockDemo

- (instancetype)init
{
    if (self = [super init])
    {
        /**
         在初始化conditionLock锁的时候，给这个锁的内部的条件值赋值为1；
         如果不写条件值的话则默认的条件值为0。
         */
        self.conditionLock = [[NSConditionLock alloc] initWithCondition:1];
    }
    
    return self;
}

- (void)otherTest
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(__one) object:nil] start];
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(__two) object:nil] start];
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(__three) object:nil] start];
}

- (void)__one
{
    /**
     加锁：
     当conditionLock锁内部的条件值为1的时候才能够进行加锁，不然的话就会一直等待，等待加锁成功后才会接着运行下面的代码；
     在初始化的时候已经给这个锁的条件值赋值为1了，所以这个当运行本方法的时候可以进行正常的加锁，然后接着运行下面的代码。
     */
    [self.conditionLock lockWhenCondition:1];
    
    NSLog(@"__one");
    sleep(1);
    
    /**
     解锁：
     解锁的时候给conditionLock锁的内部的条件值赋值为2.
     */
    [self.conditionLock unlockWithCondition:2];
}

- (void)__two
{
    /**
     加锁：
     当conditionLock锁内部的条件值为2的时候才能够进行加锁，不然的话就会一直等待，等待加锁成功后才会接着运行下面的代码；
     因为在初始化的时候已经给这个锁的条件值赋值为1了，所以当先运行这个方法的时候，不能正常加锁，会一直等待，然后系统会运行"__one"方法，在"__one"方法中最后解锁的时候，会给conditionLock锁的内部的条件值赋值为2，这样的话本方法就会成功加锁了，在加锁后会接着运行本方法下面的代码；
     conditionLock（条件锁）会决定多个线程运行的先后顺序。
     */
    [self.conditionLock lockWhenCondition:2];

    NSLog(@"__two");
    sleep(1);
    
    //解锁
    [self.conditionLock unlockWithCondition:3];
}

- (void)__three
{
    //加锁
    [self.conditionLock lockWhenCondition:3];
    
    NSLog(@"__three");
    
    [self.conditionLock unlock];
}

@end
