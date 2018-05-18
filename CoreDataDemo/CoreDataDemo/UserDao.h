//
//  UserDao.h
//  CoreDataDemo
//
//  Created by 朱超鹏 on 2018/5/14.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaoProtocol.h"

/// 用户dao类型
typedef NS_ENUM(NSInteger, UserDaoType) {
    UserDaoDefault          = 0,
    UserDaoMultithreading   = 1,
    UserDaoMR               = 2
};

/// 多线程方案
typedef NS_ENUM(NSInteger, UserDao_MultithreadingPlan) {
    UserDao_MultithreadingPlan1 = 1,
    UserDao_MultithreadingPlan2
};

/**
 用户模型dao类
 */
@interface UserDao : NSObject <DaoProtocol>

@end

/**
 用户模型dao类 使用多线程
 */
@interface UserDao_Multithreading : UserDao

/// 多线程方案
@property (nonatomic, assign) UserDao_MultithreadingPlan plan;

@end

/**
 用户模型dao类 使用MagicalRecord
 */
@interface UserDao_MR : UserDao

@end

/**
 用户模型dao工厂类
 */
@interface UserDaoFactory : NSObject

/**
 创建用户模型Dao实例

 @param type dao类型
 @return dao实例
 */
+ (UserDao *)produceUserDaoWithType:(UserDaoType)type;

@end
