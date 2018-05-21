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

// 错误的多线程例子，多次调用会crash
- (void)testError {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [arr addObject:@{@"id": @"111", @"name": @"aaa"}];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSManagedObjectContext *context = self.manager.moc;
        int i = 1;
        for (NSDictionary *params in arr) {
            User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:context];
            user.userID = params[@"id"];
            user.name   = params[@"name"];
            if (i == 5) {
                sleep(2);
            }
            i++;
        }
        [self.manager saveContext:context];
    });
    
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

// 只是用一个context，相当于只有一个rootContext，由于context绑定的队列是串行的，所以每个任务都会顺序执行，并不会出现错乱。
// 如此说来的话，test1中的错误也可以通过维护一个串行队列去自己实现多线程
- (void)testSuccess {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [arr addObject:@{@"id": @"111", @"name": @"aaa"}];
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:self.manager.psc];
    
    [context performBlock:^{
        NSLog(@"1 %@", [NSThread currentThread]);
        int i = 1;
        for (NSDictionary *params in arr) {
            User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:context];
            user.userID = params[@"id"];
            user.name   = params[@"name"];
            if (i == 5) {
                sleep(5);
            }
            i++;
        }
        [self.manager saveContext:context];
    }];
    
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

// 在执行该方法时记得先注释掉CoreDataManager中mergeChangesFromContextDidSaveNotification的代码
/*
 输出结果如下：
 
 2018-05-18 17:56:44.390925+0800 CoreDataDemo[44939:18449530] = = = = = 查询到的数据 = = = = =
 2018-05-18 17:56:44.391432+0800 CoreDataDemo[44939:18449530] 111 小明
 2018-05-18 17:56:44.391662+0800 CoreDataDemo[44939:18449530] 111 小明
 2018-05-18 17:56:44.391911+0800 CoreDataDemo[44939:18449530] 111 小明
 2018-05-18 17:56:49.397367+0800 CoreDataDemo[44939:18449530] = = = = = 提交之前的数据 = = = = =
 2018-05-18 17:56:49.397764+0800 CoreDataDemo[44939:18449530] 111 小明
 2018-05-18 17:56:49.397963+0800 CoreDataDemo[44939:18449530] 111 小明
 2018-05-18 17:56:49.398169+0800 CoreDataDemo[44939:18449530] 111 小明
 
 // 下面这个是我自己又查了一下
 2018-05-18 17:56:57.978787+0800 CoreDataDemo[44939:18449419] 共查询到3条记录
 2018-05-18 17:56:57.978973+0800 CoreDataDemo[44939:18449419] [111] [newName]
 2018-05-18 17:56:57.979070+0800 CoreDataDemo[44939:18449419] [111] [newName]
 2018-05-18 17:56:57.979154+0800 CoreDataDemo[44939:18449419] [111] [newName]
 
 可以发现，在删除保存时出现了冲突，数据并没有被成功删除掉。
 
 */
- (void)testMergeChanges {
    
    // 新增操作
    NSArray *data = @[@{@"id": @"111", @"name": @"小明"},
                      @{@"id": @"111", @"name": @"小明"},
                      @{@"id": @"111", @"name": @"小明"}];
    
    [self createWithArray:data completion:nil];
    
    sleep(1);
    
    // 删除操作
    NSManagedObjectContext *context = [self getPrivateContext];

    [context performBlock:^{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", @"111"]];
        [fetchRequest setPredicate:predicate];

        NSError *error = nil;
        NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];

        NSLog(@"= = = = = 查询到的数据 = = = = = ");

        for (User *user in resultArray) {
            NSLog(@"%@ %@", user.userID, user.name);
        }

        sleep(5);

        NSLog(@"= = = = = 提交之前的数据 = = = = = ");

        for (User *user in resultArray) {
            NSLog(@"%@ %@", user.userID, user.name);
            [context deleteObject:user];
        }
        [self.manager saveContext:context];
    }];
    
    sleep(1);
    
    // 更新操作
    [self updateWithID:@"111" params:@{@"name": @"newName"} completion:nil];
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
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:localContext];
        user.userID = userID;
        user.name = userName;
        
        // just for test
        [self.workingMOCArr addPointer:(__bridge void * _Nullable)(localContext)];
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

/// 删除指定记录
- (void)deleteWithID:(NSString *)idString completion:(DaoCompletionBlock)completion {
    // private -> root
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", idString];
        NSArray *resultArray = [User MR_findAllWithPredicate:predicate inContext:localContext];
        [localContext MR_deleteObjects:resultArray];
    }];
}

/// 删除所有记录
- (void)deleteAll:(DaoCompletionBlock)completion {
    // private -> root
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        NSArray *resultArray = [User MR_findAllInContext:localContext];
        [localContext MR_deleteObjects:resultArray];
    }];
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
            [(UserDao_MR *)dao setWorkingMOCArr:[NSPointerArray weakObjectsPointerArray]];
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
