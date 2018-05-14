//
//  DaoProtocol.h
//  CoreDataDemo
//
//  Created by 朱超鹏 on 2018/5/14.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DaoCompletionBlock)(NSError *error);

/// dao协议
@protocol DaoProtocol <NSObject>

/**
 新增一条记录

 @param params 参数集
 */
- (void)createWithParams:(NSDictionary *)params completion:(DaoCompletionBlock)completion;

/**
 删除指定记录

 @param idString 记录ID
 */
- (void)deleteWithID:(NSString *)idString completion:(DaoCompletionBlock)completion;

/**
 删除所有记录
 */
- (void)deleteAll:(DaoCompletionBlock)completion;

/**
 查询指定记录

 @param idString 记录ID
 @return 结果集
 */
- (NSArray *)retrieveWithID:(NSString *)idString completion:(DaoCompletionBlock)completion;

/**
 查询所有记录

 @return 结果集
 */
- (NSArray *)retrieveAll:(DaoCompletionBlock)completion;

/**
 更新指定记录

 @param idString 记录ID
 @param params 参数集
 */
- (void)updateWithID:(NSString *)idString params:(NSDictionary *)params completion:(DaoCompletionBlock)completion;

@end
