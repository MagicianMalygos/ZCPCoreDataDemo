//
//  CoreDataManager.m
//  CodeDataDemo
//
//  Created by 朱超鹏 on 2018/5/11.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

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

- (void)saveContext {
    NSManagedObjectContext *moc = self.moc;
    if (!moc) {
        return;
    }
    NSError *error = nil;
    // 判断MOC监听的MO对象是否有改变，如果有则提交保存
    if ([moc hasChanges] && ![moc save:&error]) {
        // log error
    }
}

@end
