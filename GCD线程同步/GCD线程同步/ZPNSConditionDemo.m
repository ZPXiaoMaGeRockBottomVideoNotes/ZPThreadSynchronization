//
//  ZPNSConditionDemo.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/8/1.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPNSConditionDemo.h"

@interface ZPNSConditionDemo ()

@property (nonatomic, strong) NSCondition *condition;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation ZPNSConditionDemo

- (instancetype)init
{
    if (self = [super init])
    {
        self.condition = [[NSCondition alloc] init];
        self.data = [NSMutableArray array];
    }
    
    return self;
}

- (void)otherTest
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}

#pragma mark ————— 删除数组中的元素 —————
- (void)__remove
{
    //加锁
    [self.condition lock];
    
    NSLog(@"remove - begin");
    
    if (self.data.count == 0)
    {
        //当数组中没有元素的话就等待
        [self.condition wait];
    }
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    
    //解锁
    [self.condition unlock];
}

#pragma mark ————— 往数组中添加元素 —————
- (void)__add
{
    //加锁
    [self.condition lock];
    
    sleep(1);
    
    [self.data addObject:@"Test"];
    NSLog(@"添加了元素");
    
    //唤醒等待_cond条件的某条线程
    [self.condition signal];
    
    //唤醒等待_cond条件的所有线程
//    [self.condition broadcast];
    
    //解锁
    [self.condition unlock];
}

@end
