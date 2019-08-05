//
//  ZPPThreadMutexDemo2.m
//  GCD线程同步
//
//  Created by 赵鹏 on 2019/8/1.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPPThreadMutexDemo2.h"
#import <pthread.h>

@interface ZPPThreadMutexDemo2 ()

@property (nonatomic, assign) pthread_mutex_t mutex;
@property (nonatomic, assign) pthread_cond_t cond;  //pthread_mutex 条件
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation ZPPThreadMutexDemo2

- (instancetype)init
{
    if (self = [super init])
    {
        //初始化属性
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        
        //初始化锁
        pthread_mutex_init(&_mutex, &attr);
        
        //销毁属性
        pthread_mutexattr_destroy(&attr);
        
        //初始化条件
        pthread_cond_init(&_cond, NULL);
        
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
/**
 在otherTest方法中创建了两条新的子线程，线程1用来执行__remove方法，线程2用来执行__add方法。根据GCD的原理，线程1和线程2几乎是同时执行各自任务的，但是也会有先后顺序，如果线程2先执行的话，会往数组里面添加元素，然后线程1再执行，这样就可以移除掉数组里面的元素了。但是如果线程1先执行，根据代码，系统会给这个线程上锁，紧接着再执行线程2，但此时线程2一看到上锁了就没办法继续执行"__add"方法里面的代码了，只能等待，而此时数组里面没有元素，线程1也就无法移除里面的元素，所以在线程1的"__remove"方法里面要写一个if语句，当数组中没有元素的话就使该线程睡觉"pthread_cond_wait(&_cond, &_mutex)"，函数中的"&_mutex"参数意味着放开刚开始执行"__remove"方法的时候加上的锁，"&_cond"参数意味着当符合条件的时候唤醒该线程，此时线程1就卡在了"pthread_cond_wait(&_cond, &_mutex);"函数处，由于现在锁已经被放开了，所以线程2就可以执行"__add"方法了，进而在数组里面添加元素，然后通过"pthread_cond_signal(&_cond);"函数来唤醒等待cond条件的那条线程（线程1），线程1被唤醒后会再加锁，然后会继续执行后面的代码，删除数组中的最后一个元素，最后再解锁。
 */
- (void)__remove
{
    pthread_mutex_lock(&_mutex);
    
    NSLog(@"remove - begin");
    
    if (self.data.count == 0)
    {
        //当数组中没有元素的话就等待
        pthread_cond_wait(&_cond, &_mutex);
    }
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    
    pthread_mutex_unlock(&_mutex);
}

#pragma mark ————— 往数组中添加元素 —————
- (void)__add
{
    pthread_mutex_lock(&_mutex);
    
    sleep(1);
    
    [self.data addObject:@"Test"];
    NSLog(@"添加了元素");
    
    //唤醒等待_cond条件的某条线程
    pthread_cond_signal(&_cond);
    
    //唤醒等待_cond条件的所有线程
//    pthread_cond_broadcast(&_cond);
    
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
    
    pthread_cond_destroy(&_cond);  //在本对象被销毁的时候也要把条件销毁了
}

@end
