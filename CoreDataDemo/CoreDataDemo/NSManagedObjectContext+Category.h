//
//  NSManagedObjectContext+Category.h
//  CoreDataDemo
//
//  Created by 朱超鹏 on 2018/5/17.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Category)

- (void)obtainPermanentIDsBeforeSaving;

@end
