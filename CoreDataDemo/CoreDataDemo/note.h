//
//  note.h
//  CoreDataDemo
//
//  Created by 朱超鹏 on 2018/5/15.
//  Copyright © 2018年 zcp. All rights reserved.
//


/*
 
 关于context类型的研究
 
 使用NSPrivateQueueConcurrencyType和NSMainQueueConcurrencyType创建的context才会有绑定对应的队列，才能使用下面的两个方法。
 使用NSConfinementConcurrencyType创建的context在使用下面两个方法时会crash，错误信息为：Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Can only use -performBlock: on an NSManagedObjectContext that was created with a queue.，NSConfinementConcurrencyType在iOS 9过期。
 
 两个方法的官方文档介绍：
 performBlockAndWait:
 Synchronously performs a given block on the context’s queue.
 
 performBlock:
 Asynchronously performs a given block on the context’s queue.
 
 探究总结：
 
 NSManagedObjectContext *mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
 NSManagedObjectContext *privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
 
 // 主队列 异步 执行block
 [mainContext performBlock:^{
    NSLog(@"mainContext block: %@", [NSThread currentThread]);
 }];
 dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"mainContext block: %@", [NSThread currentThread]);
 });
 
 // 主线程执行block
 [mainContext performBlockAndWait:^{
    NSLog(@"mainContext blockWait: %@", [NSThread currentThread]);
 }];
 if ([NSThread isMainThread]) {
    NSLog(@"mainContext blockWait: %@", [NSThread currentThread]);
 } else {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"mainContext blockWait: %@", [NSThread currentThread]);
    });
 }
 
 // 串行队列 异步 执行block（子线程中执行）
 [privateContext performBlock:^{
    NSLog(@"privateContext block: %@", [NSThread currentThread]);
 }];
 dispatch_queue_t queue = dispatch_queue_create("zcp", DISPATCH_QUEUE_SERIAL);
 dispatch_async(queue, ^{
    NSLog(@"privateContext block: %@", [NSThread currentThread]);
 });
 
 // 串行队列 同步 执行block（在当前线程中执行）
 [privateContext performBlockAndWait:^{
    NSLog(@"privateContext blockwait: %@", [NSThread currentThread]);
 }];
 dispatch_queue_t queue = dispatch_queue_create("zcp", DISPATCH_QUEUE_SERIAL);
 dispatch_sync(queue, ^{
    NSLog(@"privateContext blockwait: %@", [NSThread currentThread]);
 });
 
 */


/*
 // 线程不安全
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSLog(@"%@", [NSThread currentThread]);
    for (int i = 0; i < 1000; i++) {
        int a = self.testInt; // 读取
        sleep(0.1); // 可能导致线程不安全的间隙处
        a = a + 1; // add
        self.testInt = a; // 赋值
    NSLog(@"Thread A: %i", self.testInt);
    }
 });
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSLog(@"%@", [NSThread currentThread]);
    for (int i = 0; i < 1000; i++) {
        int a = self.testInt; // 读取
        a = a + 1; // add
        self.testInt = a; // 赋值
        NSLog(@"Thread B: %i", self.testInt);
    }
 });
 
 // 在间隙处，可能线程B已经执行了一整个操作，使得testInt发生了变化。然后后续对testInt赋值时已经是被线程B改变过的值了。导致最后的结果不一定为2000
 
 */
