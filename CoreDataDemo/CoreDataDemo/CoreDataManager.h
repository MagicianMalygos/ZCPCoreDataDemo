//
//  CoreDataManager.h
//  CodeDataDemo
//
//  Created by 朱超鹏 on 2018/5/11.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectModel *mom;
@property (nonatomic, strong) NSPersistentStoreCoordinator *psc;
@property (nonatomic, strong) NSManagedObjectContext *moc;

- (void)saveContext:(NSManagedObjectContext *)context;

#pragma mark - plan 1

@property (nonatomic, strong) NSManagedObjectContext *mainMOC_Plan1;

- (NSManagedObjectContext *)createPrivateMOC_Plan1;

#pragma mark - plan 2

@property (nonatomic, strong) NSManagedObjectContext *rootMOC_Plan2;
@property (nonatomic, strong) NSManagedObjectContext *mainMOC_Plan2;

- (NSManagedObjectContext *)createPrivateMOC_Plan2;

@end
