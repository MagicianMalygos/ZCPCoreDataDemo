//
//  UserDao.m
//  CoreDataDemo
//
//  Created by 朱超鹏 on 2018/5/14.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "UserDao.h"
#import "CoreDataManager.h"
#import "User+CoreDataClass.h"
#import <MagicalRecord/MagicalRecord.h>

#define EntityName  @"User"

@interface UserDao ()

@property (nonatomic, strong) CoreDataManager *manager;

@end

@implementation UserDao

#pragma mark - test

- (void)justForTest {
    
}

#pragma mark CRUD

/// 新增一条记录
- (void)createWithParams:(NSDictionary *)params completion:(DaoCompletionBlock)completion {
    NSString *userID    = params[@"id"];
    NSString *userName  = params[@"name"];
    
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    // 2.创建MO并使用MOC进行监听
    User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:context];
    
    // 3.设值
    user.userID = userID;
    user.name = userName;
    
    // 4.保存提交
    [self.manager saveContext:context];
    if (completion) {
        completion(nil);
    }
}

/// 新增多条记录
- (void)createWithArray:(NSArray *)array completion:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    for (NSDictionary *params in array) {
        // 2.创建MO并使用MOC进行监听
        User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:context];
        
        // 3.设值
        user.userID = params[@"id"];
        user.name   = params[@"name"];
    }
    
    // 4.保存提交
    [self.manager saveContext:context];
    if (completion) {
        completion(nil);
    }
}

/// 删除指定记录
- (void)deleteWithID:(NSString *)idString completion:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    // 2.创建查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", idString]];
    [fetchRequest setPredicate:predicate];
    
    // 3.执行查询方法，返回结果
    NSError *error = nil;
    NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        if (completion) {
            completion(error);
        }
        return;
    }
    
    // 4.将MO标记为删除
    for (User *user in resultArray) {
        [context deleteObject:user];
    }
    // 5.提交修改
    [self.manager saveContext:context];
    if (completion) {
        completion(nil);
    }
}

/// 删除所有记录
- (void)deleteAll:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    // 2.创建查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
    
    // 3.执行查询方法，返回结果
    NSError *error = nil;
    NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        if (completion) {
            completion(error);
        }
        return;
    }
    
    // 4.将MO标记为删除
    for (User *user in resultArray) {
        [context deleteObject:user];
    }
    // 5.提交修改
    [self.manager saveContext:context];
    if (completion) {
        completion(nil);
    }
}

/// 查询指定记录
- (NSArray *)retrieveWithID:(NSString *)idString completion:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    // 2.创建查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", idString]];
    [fetchRequest setPredicate:predicate];
    
    // 3.执行查询方法，返回结果
    NSError *error = nil;
    NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
    if (completion) {
        completion(error);
    }
    return resultArray;
}

/// 查询所有记录
- (NSArray *)retrieveAll:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    // 2.创建查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
    
    // 3.执行查询方法，返回结果
    NSError *error = nil;
    NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
    if (completion) {
        completion(error);
    }
    return resultArray;
}

/// 更新指定记录
- (void)updateWithID:(NSString *)idString params:(NSDictionary *)params completion:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    // 2.创建查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", idString]];
    [fetchRequest setPredicate:predicate];
    
    // 3.执行查询方法，返回结果
    NSError *error = nil;
    NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        if (completion) {
            completion(error);
        }
        return;
    }
    
    // 4.更新MO
    for (User *user in resultArray) {
        user.name = params[@"name"];
    }
    
    // 5.提交修改
    [self.manager saveContext:context];
    if (completion) {
        completion(nil);
    }
}

@end

@implementation UserDao_Multithreading

#pragma mark test

- (void)justForTest {
    // test1
//    [self testErrorExample];
    // test2
//    [self testCorrectExample];
    // test3
//    [self testMergeChanges];
}

/**
 错误的多线程例子，在两个线程中使用了同一个MOC
 多次调用会crash
 */
- (void)testErrorExample {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [arr addObject:@{@"id": @"111", @"name": @"aaa"}];
    }
    
    // 在线程1中插入20条数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSManagedObjectContext *context = self.manager.moc;
        int i = 1;
        for (NSDictionary *params in arr) {
            User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:context];
            user.userID = params[@"id"];
            user.name   = params[@"name"];
            
            // 此处的代码是用来模拟，线程1插入5条数据的时候，线程2刚好完成update操作
            if (i == 5) {
                sleep(2);
            }
            i++;
        }
        [self.manager saveContext:context];
    });
    
    // 在线程2中更新数据，将name更新为"newName"
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSManagedObjectContext *context = self.manager.moc;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
        NSArray *resultArray = [context executeFetchRequest:fetchRequest error:nil];
        
        for (User *user in resultArray) {
            user.name = @"newName";
        }
        [self.manager saveContext:context];
    });
}

/**
 只使用一个MOC的多线程方案，相当于根MOC。承接所有的增删改查，在后台进行费时操作。
 由于私有MOC绑定的队列是串行的，所以每个任务都会在按照队列中的顺序去执行，并不会出现上面例子中的问题。
 */
- (void)testCorrectExample {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [arr addObject:@{@"id": @"111", @"name": @"aaa"}];
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:self.manager.psc];
    
    // 操作1 添加20条数据
    [context performBlock:^{
        NSLog(@"1 %@", [NSThread currentThread]);
        int i = 1;
        for (NSDictionary *params in arr) {
            User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:context];
            user.userID = params[@"id"];
            user.name   = params[@"name"];
            
            // 由于每一个任务都加在MOC绑定的串行队列中，因此此处阻塞线程后并不会继续去执行之后的update任务。
            if (i == 5) {
                sleep(5);
            }
            i++;
        }
        [self.manager saveContext:context];
    }];
    
    // 操作2 update数据
    [context performBlock:^{
        NSLog(@"2 %@", [NSThread currentThread]);
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
        NSArray *resultArray = [context executeFetchRequest:fetchRequest error:nil];
        
        for (User *user in resultArray) {
            user.name = @"newName";
        }
        
        [self.manager saveContext:context];
    }];
}

/**
 用于测试MOC之间的merge问题
 模拟了MOC1删除的过程中，MOC2刚好更新了数据，看MOC1是否能够正确的删除数据
 
 1> 注释CoreDataManager类中的NSManagedObjectContextDidSaveNotification通知代码
 输出结果如下：
 
 2018-05-22 11:05:31.417334+0800 CoreDataDemo[70338:21574273] <NSManagedObjectContext: 0x6080001c9510> 加入工作
 2018-05-22 11:05:31.420614+0800 CoreDataDemo[70338:21574384] testMergeChanges: step1 新增完毕
 2018-05-22 11:05:31.420833+0800 CoreDataDemo[70338:21574273] <NSManagedObjectContext: 0x6040001c9240> 加入工作
 2018-05-22 11:05:31.421701+0800 CoreDataDemo[70338:21574372] testMergeChanges: step2 删除前查询到的数据
 2018-05-22 11:05:31.421938+0800 CoreDataDemo[70338:21574372] 111 小明
 2018-05-22 11:05:31.422064+0800 CoreDataDemo[70338:21574372] 111 小明
 2018-05-22 11:05:31.422169+0800 CoreDataDemo[70338:21574372] 111 小明
 2018-05-22 11:05:31.422352+0800 CoreDataDemo[70338:21574273] <NSManagedObjectContext: 0x60c0001dd1f0> 加入工作
 2018-05-22 11:05:31.424116+0800 CoreDataDemo[70338:21574384] testMergeChanges: step3 更新完毕
 2018-05-22 11:05:36.423839+0800 CoreDataDemo[70338:21574372] testMergeChanges: step4 标记删除并准备提交之前的数据
 2018-05-22 11:05:36.424088+0800 CoreDataDemo[70338:21574372] 111 小明
 2018-05-22 11:05:36.424293+0800 CoreDataDemo[70338:21574372] 111 小明
 2018-05-22 11:05:36.424447+0800 CoreDataDemo[70338:21574372] 111 小明
 
 // 下面这个是我自己又查了一下
 2018-05-18 17:56:57.978787+0800 CoreDataDemo[44939:18449419] 共查询到3条记录
 2018-05-18 17:56:57.978973+0800 CoreDataDemo[44939:18449419] [111] [newName]
 2018-05-18 17:56:57.979070+0800 CoreDataDemo[44939:18449419] [111] [newName]
 2018-05-18 17:56:57.979154+0800 CoreDataDemo[44939:18449419] [111] [newName]
 
 结果：可以发现，在MOC提交删除时出现了冲突，数据并没有被成功删除掉。
 
 
 2> 加上CoreDataManager类中的NSManagedObjectContextDidSaveNotification通知代码
 输出结果如下：
 
 2018-05-22 11:12:05.463399+0800 CoreDataDemo[70906:21590333] <NSManagedObjectContext: 0x6080001ce100> 加入工作
 2018-05-22 11:12:05.466358+0800 CoreDataDemo[70906:21601450] <NSManagedObjectContext: 0x6080001ce100> 保存完毕
 2018-05-22 11:12:05.466561+0800 CoreDataDemo[70906:21601450] testMergeChanges: step1 新增完毕
 2018-05-22 11:12:05.466784+0800 CoreDataDemo[70906:21590333] <NSManagedObjectContext: 0x6040001cf2d0> 加入工作
 2018-05-22 11:12:05.467332+0800 CoreDataDemo[70906:21601449] testMergeChanges: step2 删除前查询到的数据
 2018-05-22 11:12:05.467558+0800 CoreDataDemo[70906:21601449] 111 小明
 2018-05-22 11:12:05.467795+0800 CoreDataDemo[70906:21601449] 111 小明
 2018-05-22 11:12:05.467990+0800 CoreDataDemo[70906:21601449] 111 小明
 2018-05-22 11:12:05.468228+0800 CoreDataDemo[70906:21590333] <NSManagedObjectContext: 0x6040001cf3c0> 加入工作
 2018-05-22 11:12:05.470686+0800 CoreDataDemo[70906:21601450] <NSManagedObjectContext: 0x6040001cf3c0> 保存完毕
 2018-05-22 11:12:05.470919+0800 CoreDataDemo[70906:21601450] <NSManagedObjectContext: 0x6040001cf2d0> 执行合并从 <NSManagedObjectContext: 0x6040001cf3c0>
 2018-05-22 11:12:05.471064+0800 CoreDataDemo[70906:21601450] testMergeChanges: step3 更新完毕
 2018-05-22 11:12:10.473070+0800 CoreDataDemo[70906:21601449] testMergeChanges: step4 标记删除并准备提交之前的数据
 2018-05-22 11:12:10.473419+0800 CoreDataDemo[70906:21601449] 111 newName
 2018-05-22 11:12:10.473661+0800 CoreDataDemo[70906:21601449] 111 newName
 2018-05-22 11:12:10.473818+0800 CoreDataDemo[70906:21601449] 111 newName
 2018-05-22 11:12:10.477208+0800 CoreDataDemo[70906:21601449] <NSManagedObjectContext: 0x6040001cf2d0> 保存完毕
 
 // 下面这个是我自己又查了一下
 2018-05-18 17:56:57.978787+0800 CoreDataDemo[44939:18449419] 共查询到0条记录
 
 结果：可以发现数据被成功的删除掉了，用于删除的MOC合并了用于更新的MOC的改变。
 */
- (void)testMergeChanges {
    
    // 1.新增操作
    NSArray *data = @[@{@"id": @"111", @"name": @"小明"},
                      @{@"id": @"111", @"name": @"小明"},
                      @{@"id": @"111", @"name": @"小明"}];
    
    [self createWithArray:data completion:^(NSError *error) {
        NSLog(@"%@: step1 新增完毕", NSStringFromSelector(_cmd));
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 2.删除操作 1/2
            NSManagedObjectContext *context = [self getPrivateContext];
            
            [context performBlock:^{
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", @"111"]];
                [fetchRequest setPredicate:predicate];
                
                NSError *error = nil;
                NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
                
                NSLog(@"%@: step2 删除前查询到的数据", NSStringFromSelector(_cmd));
                
                for (User *user in resultArray) {
                    NSLog(@"%@ %@", user.userID, user.name);
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 3.更新操作
                    [self updateWithID:@"111" params:@{@"name": @"newName"} completion:^(NSError *error) {
                        NSLog(@"%@: step3 更新完毕", NSStringFromSelector(_cmd));
                    }];
                });
                
                // 此处阻塞线程的代码是为了在删除之前update操作能够执行完毕
                sleep(5);
                
                // 4.删除操作 2/2
                NSLog(@"%@: step4 标记删除并准备提交之前的数据", NSStringFromSelector(_cmd));
                
                for (User *user in resultArray) {
                    NSLog(@"%@ %@", user.userID, user.name);
                    [context deleteObject:user];
                }
                [self.manager saveContext:context];
            }];
        });
    }];
}

#pragma mark CRUD

/// 新增一条记录
- (void)createWithParams:(NSDictionary *)params completion:(DaoCompletionBlock)completion {
    NSString *userID    = params[@"id"];
    NSString *userName  = params[@"name"];
    
    // 1.获取MOC
    NSManagedObjectContext *context = [self getPrivateContext];
    
    [context performBlock:^{
        // 2.创建MO并使用MOC进行监听
        User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:context];
        
        // 3.设值
        user.userID = userID;
        user.name = userName;
        
        // 4.保存提交
        [self.manager saveContext:context];
        if (completion) {
            completion(nil);
        }
        [[NSNotificationCenter defaultCenter] removeObserver:context];
    }];
}

/// 新增多条记录
- (void)createWithArray:(NSArray *)array completion:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = [self getPrivateContext];
    
    [context performBlock:^{
        for (NSDictionary *params in array) {
            // 2.创建MO并使用MOC进行监听
            User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:context];
            
            // 3.设值
            user.userID = params[@"id"];
            user.name   = params[@"name"];
        }
        
        // 4.保存提交
        [self.manager saveContext:context];
        if (completion) {
            completion(nil);
        }
    }];
}

/// 删除指定记录
- (void)deleteWithID:(NSString *)idString completion:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = [self getPrivateContext];
    
    [context performBlock:^{
        // 2.创建查询请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", idString]];
        [fetchRequest setPredicate:predicate];
        
        // 3.执行查询方法，返回结果
        NSError *error = nil;
        NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            if (completion) {
                completion(error);
            }
            return;
        }
        
        // 4.将MO标记为删除
        for (User *user in resultArray) {
            [context deleteObject:user];
        }
        // 5.提交修改
        [self.manager saveContext:context];
        if (completion) {
            completion(nil);
        }
    }];
}

/// 删除所有记录
- (void)deleteAll:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = [self getPrivateContext];
    
    [context performBlock:^{
        // 2.创建查询请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
        
        // 3.执行查询方法，返回结果
        NSError *error = nil;
        NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            if (completion) {
                completion(error);
            }
            return;
        }
        
        // 4.将MO标记为删除
        for (User *user in resultArray) {
            [context deleteObject:user];
        }
        
        // 5.提交修改
        [self.manager saveContext:context];
        if (completion) {
            completion(nil);
        }
    }];
}

/// 查询指定记录
- (NSArray *)retrieveWithID:(NSString *)idString completion:(DaoCompletionBlock)completion {
    __block NSArray *resultArray = nil;
    
    // 1.获取MOC
    NSManagedObjectContext *context = [self getMainContext];
    
    [context performBlockAndWait:^{
        // 2.创建查询请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", idString]];
        [fetchRequest setPredicate:predicate];
        
        // 3.执行查询方法，返回结果
        NSError *error = nil;
        resultArray = [context executeFetchRequest:fetchRequest error:&error];
        if (completion) {
            completion(error);
        }
    }];
    
    return resultArray;
}

/// 查询所有记录
- (NSArray *)retrieveAll:(DaoCompletionBlock)completion {
    __block NSArray *resultArray = nil;
    
    // 1.获取MOC
    NSManagedObjectContext *context = [self getMainContext];
    [context performBlockAndWait:^{
        // 2.创建查询请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
        
        // 3.执行查询方法，返回结果
        NSError *error = nil;
        resultArray = [context executeFetchRequest:fetchRequest error:&error];
        if (completion) {
            completion(error);
        }
    }];
    
    return resultArray;
}

/// 更新指定记录
- (void)updateWithID:(NSString *)idString params:(NSDictionary *)params completion:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = [self getPrivateContext];
    
    [context performBlock:^{
        // 2.创建查询请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", idString]];
        [fetchRequest setPredicate:predicate];
        
        // 3.执行查询方法，返回结果
        NSError *error = nil;
        NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            if (completion) {
                completion(error);
            }
            return;
        }
        
        // 4.更新MO
        for (User *user in resultArray) {
            user.name = params[@"name"];
        }
        
        // 5.提交修改
        [self.manager saveContext:context];
        if (completion) {
            completion(nil);
        }
    }];
}

#pragma mark <help method>

/**
 根据plan获取context
 */
- (NSManagedObjectContext *)getPrivateContext {
    if (self.plan == UserDao_MultithreadingPlan1) {
        return [self.manager createPrivateMOC_Plan1];
    } else if (self.plan == UserDao_MultithreadingPlan2) {
        return [self.manager createPrivateMOC_Plan2];
    }
    return [self.manager createPrivateMOC_Plan1];
}

/**
 根据plan获取main context
 */
- (NSManagedObjectContext *)getMainContext {
    if (self.plan == UserDao_MultithreadingPlan1) {
        return self.manager.mainMOC_Plan1;
    } else if (self.plan == UserDao_MultithreadingPlan2) {
        return self.manager.mainMOC_Plan2;
    }
    return self.manager.mainMOC_Plan1;
}

@end

@implementation UserDao_MR

#pragma mark CRUD

/// 新增一条记录
- (void)createWithParams:(NSDictionary *)params completion:(DaoCompletionBlock)completion {
    NSString *userID    = params[@"id"];
    NSString *userName  = params[@"name"];
    
    // localContext -> rootSavingContext
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:localContext];
        user.userID = userID;
        user.name = userName;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
    
    // localContext -> defaultContext -> rootSavingContext
//    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//        User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:localContext];
//        user.userID = userID;
//        user.name = userName;
//    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
//        if (completion) {
//            completion(error);
//        }
//    }];
}

/// 删除指定记录
- (void)deleteWithID:(NSString *)idString completion:(DaoCompletionBlock)completion {
    // localContext -> rootSavingContext
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", idString];
        NSArray *resultArray = [User MR_findAllWithPredicate:predicate inContext:localContext];
        [localContext MR_deleteObjects:resultArray];
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
    
    // localContext -> defaultContext -> rootSavingContext
//    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", idString];
//        NSArray *resultArray = [User MR_findAllWithPredicate:predicate inContext:localContext];
//        [localContext MR_deleteObjects:resultArray];
//    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
//        if (completion) {
//            completion(error);
//        }
//    }];
}

/// 删除所有记录
- (void)deleteAll:(DaoCompletionBlock)completion {
    // localContext -> rootSavingContext
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        NSArray *resultArray = [User MR_findAllInContext:localContext];
        [localContext MR_deleteObjects:resultArray];
    }];
    
    // localContext -> defaultContext -> rootSavingContext
//    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//        NSArray *resultArray = [User MR_findAllInContext:localContext];
//        [localContext MR_deleteObjects:resultArray];
//    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
//        if (completion) {
//            completion(error);
//        }
//    }];
}

/// 查询指定记录
- (NSArray *)retrieveWithID:(NSString *)idString completion:(DaoCompletionBlock)completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", idString];
    NSArray *resultArray = [User MR_findAllWithPredicate:predicate];
    if (completion) {
        completion(nil);
    }
    return resultArray;
}

/// 查询所有记录
- (NSArray *)retrieveAll:(DaoCompletionBlock)completion {
    NSArray *resultArray = [User MR_findAll];
    if (completion) {
        completion(nil);
    }
    return resultArray;
}

/// 更新指定记录
- (void)updateWithID:(NSString *)idString params:(NSDictionary *)params completion:(DaoCompletionBlock)completion {
    
    // localContext -> rootSavingContext
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate  = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", idString]];
        NSArray *resultArray    = [User MR_findAllWithPredicate:predicate inContext:localContext];
        for (User *user in resultArray) {
            user.name = params[@"name"];
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
    
    // localContext -> defaultContext -> rootSavingContext
//    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//        NSPredicate *predicate  = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", idString]];
//        NSArray *resultArray    = [User MR_findAllWithPredicate:predicate inContext:localContext];
//        for (User *user in resultArray) {
//            user.name = params[@"name"];
//        }
//    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
//        if (completion) {
//            completion(error);
//        }
//    }];
}

@end

@implementation UserDaoFactory

+ (UserDao *)produceUserDaoWithType:(UserDaoType)type {
    UserDao *dao = nil;
    switch (type) {
        case UserDaoDefault: {
            dao = [[UserDao alloc] init];
        }
            break;
        case UserDaoMultithreading: {
            dao = [[UserDao_Multithreading alloc] init];
            [(UserDao_Multithreading *)dao setPlan:UserDao_MultithreadingPlan1];
        }
            break;
        case UserDaoMR: {
            dao = [[UserDao_MR alloc] init];
            [MagicalRecord setupCoreDataStack];
        }
            break;
        default: {
            dao = [[UserDao alloc] init];
        }
            break;
    }
    dao.manager = [[CoreDataManager alloc] init];
    return dao;
}

@end
