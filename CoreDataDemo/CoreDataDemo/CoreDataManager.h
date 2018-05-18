//
//  CoreDataManager.h
//  CodeDataDemo
//
//  Created by 朱超鹏 on 2018/5/11.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 CoreData管理类
 */
@interface CoreDataManager : NSObject

#pragma mark - default core data stack

/// 托管对象模型
@property (nonatomic, strong) NSManagedObjectModel *mom;
/// 持久化存储协调器
@property (nonatomic, strong) NSPersistentStoreCoordinator *psc;
/// 托管对象上下文
@property (nonatomic, strong) NSManagedObjectContext *moc;

/**
 提交指定托管对象上下文的改动

 @param context 指定的托管对象上下文
 */
- (void)saveContext:(NSManagedObjectContext *)context;

#pragma mark - plan 1 core data stack

/**
 方案一：
 PSC    -> mainMOC
        -> privateMOC
 */

/// 主上下文 用于UI协作或其他使用主线程的情况
@property (nonatomic, strong) NSManagedObjectContext *mainMOC_Plan1;

/**
 创建一个用于操作的私有上下文

 @return 用于操作的私有上下文
 */
- (NSManagedObjectContext *)createPrivateMOC_Plan1;

#pragma mark - plan 2 core data stack


/**
 方案二：
 PSC    -> rootMOC -> mainMOC -> privateMOC
 */

/// 根上下文 用于在后台线程处理所有子上下文提交的操作
@property (nonatomic, strong) NSManagedObjectContext *rootMOC_Plan2;
/// 主上下文 用于UI协作或其他使用主线程的情况
@property (nonatomic, strong) NSManagedObjectContext *mainMOC_Plan2;

/**
 创建一个用于操作的私有上下文
 
 @return 用于操作的私有上下文
 */
- (NSManagedObjectContext *)createPrivateMOC_Plan2;

@end
