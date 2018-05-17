//
//  NSManagedObjectContext+Category.m
//  CoreDataDemo
//
//  Created by 朱超鹏 on 2018/5/17.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "NSManagedObjectContext+Category.h"

@implementation NSManagedObjectContext (Category)

- (void)obtainPermanentIDsBeforeSaving {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextWillSave:)
                                                 name:NSManagedObjectContextWillSaveNotification
                                               object:self];
}

- (void)contextDidSave:(NSNotification *)notification {
//    id object = notification.object;
//    if (object == self.mainMOC_Plan1) {
//        [self.mainMOC_Plan1 mergeChangesFromContextDidSaveNotification:notification];
//    }
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
