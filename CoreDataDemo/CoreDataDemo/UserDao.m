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

#define EntityName  @"User"

@interface UserDao ()

@property (nonatomic, strong) CoreDataManager *manager;

@end

@implementation UserDao

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
    [self.manager saveContext];
    completion(nil);
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
    if (error == nil) {
        completion(error);
        return;
    }
    
    // 4.将MO标记为删除
    for (User *user in resultArray) {
        [context deleteObject:user];
    }
    // 5.提交修改
    [self.manager saveContext];
    completion(nil);
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
    if (error == nil) {
        completion(error);
        return;
    }
    
    // 4.将MO标记为删除
    for (User *user in resultArray) {
        [context deleteObject:user];
    }
    // 5.提交修改
    [self.manager saveContext];
    completion(nil);
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
    completion(error);
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
    completion(error);
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
    if (error == nil) {
        completion(error);
        return;
    }
    
    // 4.更新MO
    for (User *user in resultArray) {
        user.name = params[@"name"];
    }
    
    // 5.提交修改
    [self.manager saveContext];
    completion(nil);
}

@end


@implementation UserDao_Async

/// 新增一条记录
- (void)createWithParams:(NSDictionary *)params completion:(DaoCompletionBlock)completion {
    NSString *userID    = params[@"id"];
    NSString *userName  = params[@"name"];
    
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    [context performBlock:^{
        // 2.创建MO并使用MOC进行监听
        User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:context];
        
        // 3.设值
        user.userID = userID;
        user.name = userName;
        
        // 4.保存提交
        [self.manager saveContext];
        completion(nil);
    }];
}

/// 删除指定记录
- (void)deleteWithID:(NSString *)idString completion:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    [context performBlock:^{
        // 2.创建查询请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", idString]];
        [fetchRequest setPredicate:predicate];
        
        // 3.执行查询方法，返回结果
        NSError *error = nil;
        NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
        if (error == nil) {
            completion(error);
            return;
        }
        
        // 4.将MO标记为删除
        for (User *user in resultArray) {
            [context deleteObject:user];
        }
        // 5.提交修改
        [self.manager saveContext];
        completion(nil);
    }];
}

/// 删除所有记录
- (void)deleteAll:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    [context performBlock:^{
        // 2.创建查询请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
        
        // 3.执行查询方法，返回结果
        NSError *error = nil;
        NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
        if (error == nil) {
            completion(error);
            return;
        }
        
        // 4.将MO标记为删除
        for (User *user in resultArray) {
            [context deleteObject:user];
        }
        // 5.提交修改
        [self.manager saveContext];
        completion(nil);
    }];
}

/// 查询指定记录
- (NSArray *)retrieveWithID:(NSString *)idString completion:(DaoCompletionBlock)completion {
    return [super retrieveWithID:idString completion:completion];
}

/// 查询所有记录
- (NSArray *)retrieveAll:(DaoCompletionBlock)completion {
    return [super retrieveAll:completion];
}

/// 更新指定记录
- (void)updateWithID:(NSString *)idString params:(NSDictionary *)params completion:(DaoCompletionBlock)completion {
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    [context performBlock:^{
        // 2.创建查询请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", idString]];
        [fetchRequest setPredicate:predicate];
        
        // 3.执行查询方法，返回结果
        NSError *error = nil;
        NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
        if (error == nil) {
            completion(error);
            return;
        }
        
        // 4.更新MO
        for (User *user in resultArray) {
            user.name = params[@"name"];
        }
        
        // 5.提交修改
        [self.manager saveContext];
        completion(nil);
    }];
}

@end

@implementation UserDao_MR

/// 新增一条记录
- (void)createWithParams:(NSDictionary *)params completion:(DaoCompletionBlock)completion {
    
}

/// 删除指定记录
- (void)deleteWithID:(NSString *)idString completion:(DaoCompletionBlock)completion {
    
}

/// 删除所有记录
- (void)deleteAll:(DaoCompletionBlock)completion {
    
}

/// 查询指定记录
- (NSArray *)retrieveWithID:(NSString *)idString completion:(DaoCompletionBlock)completion {
    return nil;
}

/// 查询所有记录
- (NSArray *)retrieveAll:(DaoCompletionBlock)completion {
    return nil;
}

/// 更新指定记录
- (void)updateWithID:(NSString *)idString params:(NSDictionary *)params completion:(DaoCompletionBlock)completion {
    
}

@end

@implementation UserDaoFactory

+ (UserDao *)createWithType:(UserDaoType)type {
    UserDao *dao = nil;
    switch (type) {
        case UserDaoDefault: {
            dao = [[UserDao alloc] init];
        }
            break;
        case UserDaoAsync: {
            dao = [[UserDao_Async alloc] init];
        }
            break;
        case UserDaoMR: {
            dao = [[UserDao_MR alloc] init];
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
