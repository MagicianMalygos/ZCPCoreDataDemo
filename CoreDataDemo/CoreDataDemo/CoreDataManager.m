//
//  CoreDataManager.m
//  CodeDataDemo
//
//  Created by 朱超鹏 on 2018/5/11.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()

/**
 为了研究使用后的moc是否会被正常销毁。
 */
@property (nonatomic, strong) NSHashTable *workingMOCArr;

@end

@implementation CoreDataManager

#pragma mark - life cycle

- (instancetype)init {
    if (self = [super init]) {
        [self.moc description];
        self.workingMOCArr = [NSHashTable weakObjectsHashTable];
        
        // 监听上下文的保存动作，处理merge
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Common

- (NSManagedObjectModel *)mom {
    if (!_mom) {
        // 通过.momd文件实例化NSManagedObjectModel对象
        NSURL *momURL = [[NSBundle mainBundle] URLForResource:@"CoreDataDemo" withExtension:@"momd"];
        _mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    }
    return _mom;
}

- (NSPersistentStoreCoordinator *)psc {
    if (!_psc) {
        _psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.mom];
        
        // 参数
        NSString *documentPath  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSURL *storeURL         = [NSURL fileURLWithPath:[documentPath stringByAppendingPathComponent:@"CoreDataDemo.sqlite"]];
        NSString *storeType     = NSSQLiteStoreType;
        NSString *configuration = nil;
        NSDictionary *options   = nil;
        NSError *error          = nil;
        
        // 设置PSC，设置数据库路径和相关配置
        NSPersistentStore *store = [_psc addPersistentStoreWithType:storeType configuration:configuration URL:storeURL options:options error:&error];
        if (!store) {
            // log error
        }
    }
    return _psc;
}

- (NSManagedObjectContext *)moc {
    if (!_moc) {
        // 根据枚举类型实例化MOC
        _moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        // 关联PSC
        [_moc setPersistentStoreCoordinator:self.psc];
    }
    return _moc;
}

- (void)saveContext:(NSManagedObjectContext *)context {
    if (!context) {
        return;
    }
    NSError *error = nil;
    // 判断MOC监听的MO对象是否有改变，如果有则提交保存
    if ([context hasChanges] && ![context save:&error]) {
        // log error
        NSAssert(YES, @"save error!!!");
    }
    
    if (context.parentContext) {
        // 递归保存
        [self saveContext:context.parentContext];
    }
}

#pragma mark - Multithreading Plan 1

- (NSManagedObjectContext *)mainMOC_Plan1 {
    if (!_mainMOC_Plan1) {
        _mainMOC_Plan1 = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainMOC_Plan1 setPersistentStoreCoordinator:self.psc];
    }
    return _mainMOC_Plan1;
}

- (NSManagedObjectContext *)createPrivateMOC_Plan1 {
    NSManagedObjectContext *privateMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [privateMOC setPersistentStoreCoordinator:self.psc];
    
    // just for test
    [self.workingMOCArr addObject:privateMOC];
    NSLog(@"%@ 加入工作", privateMOC);
    return privateMOC;
}

- (void)contextDidSave:(NSNotification *)notification {
//    if (![NSThread isMainThread]) {
//        [self performSelectorOnMainThread:@selector(contextDidSave:) withObject:notification waitUntilDone:NO];
//        return;
//    }
    
    NSManagedObjectContext *saveContext = notification.object;
    if (saveContext.persistentStoreCoordinator != self.psc) return;
    NSLog(@"%@ 保存完毕", saveContext);
    
    if (saveContext == self.mainMOC_Plan1) {
        [self.mainMOC_Plan1 mergeChangesFromContextDidSaveNotification:notification];
    } else {
        for (NSManagedObjectContext *context in self.workingMOCArr) {
            if (context != saveContext) {
                [context mergeChangesFromContextDidSaveNotification:notification];
                NSLog(@"%@ 执行合并从 %@", context, saveContext);
            }
        }
    }
}

#pragma mark - Multithreading Plan 2

- (NSManagedObjectContext *)rootMOC_Plan2 {
    if (!_rootMOC_Plan2) {
        _rootMOC_Plan2 = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_rootMOC_Plan2 setPersistentStoreCoordinator:self.psc];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextWillSave:) name:NSManagedObjectContextWillSaveNotification object:_rootMOC_Plan2];
    }
    return _rootMOC_Plan2;
}

- (NSManagedObjectContext *)mainMOC_Plan2 {
    if (!_mainMOC_Plan2) {
        _mainMOC_Plan2 = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainMOC_Plan2 setParentContext:self.rootMOC_Plan2];
    }
    return _mainMOC_Plan2;
}

- (NSManagedObjectContext *)createPrivateMOC_Plan2 {
    NSManagedObjectContext *privateMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [privateMOC setParentContext:self.mainMOC_Plan2];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextWillSave:) name:NSManagedObjectContextWillSaveNotification object:privateMOC];
    return privateMOC;
}

- (void)contextWillSave:(NSNotification *)notification {
    NSManagedObjectContext *context = notification.object;
    NSSet *insertedObjects = [context insertedObjects];
    
    if ([insertedObjects count]) {
        NSError *error = nil;
        BOOL success = [context obtainPermanentIDsForObjects:insertedObjects.allObjects error:&error];
        if (!success) {
            // log error
        }
    }
}

@end
