# ZPThreadSynchronization
本Demo主要介绍了多线程的安全隐患以及解决方案，还介绍了iOS中线程同步方案，还介绍了各种线程同步方案性能的比较。

iOS中的线程同步主要有以下的几种方案：

1、OSSpinLock；

2、os_unfair_lock；

3、pthread_mutex；

4、dispatch_semaphore；

5、dispatch_queue(DISPATCH_QUEUE_SERIAL)；

6、NSLock；

7、NSRecursiveLock；

8、NSCondition；

9、NSConditionLock；

10、@synchronized；

视频路径：小马哥——>2018年9月iOS底层原理班（加密版）——>下（OC对象、关联对象、多线程、内存管理、性能优化）——>2.底层下-原理——>day20——>169-多线程10-安全隐患分析.ev4、170-多线程11-OSSpinLock01.ev4、171-多线程12-OSSpinLock02.ev4、172-多线程13-OSSpinLock03.ev4、173-多线程14-答疑.ev4；

小马哥——>2018年9月iOS底层原理班（加密版）——>下（OC对象、关联对象、多线程、内存管理、性能优化）——>2.底层下-原理——>day21——>174-多线程15-os_unfair_lock.ev4、175-多线程16-pthread_mutex01.ev4、176-多线程17-pthread_mutex02-递归锁.ev4、177-多线程18-自旋锁、互斥锁汇编分析.ev4、178-多线程19-pthread_mutex03-条件.ev4、179-多线程20-NSLock、NSRecursiveLock、NSCondition.ev4、180-多线程21-答疑.ev4；

小马哥——>2018年9月iOS底层原理班（加密版）——>下（OC对象、关联对象、多线程、内存管理、性能优化）——>2.底层下-原理——>day22——>181-多线程22-遗留问题解决.ev4、182-多线程23-NSConditionLock.ev4、183-多线程24-SerialQueue.ev4、184-多线程25-semaphore01-最大并发数量.ev4、185-多线程26-semaphore02-线程同步.ev4、186-多线程27-@synchronized.ev4、187-多线程28-同步方案性能对比.ev4、188-多线程29-自旋锁、互斥锁对比.ev4。
