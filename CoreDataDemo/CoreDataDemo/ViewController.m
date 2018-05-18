//
//  ViewController.m
//  CoreDataDemo
//
//  Created by 朱超鹏 on 2018/5/11.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataManager.h"
#import "User+CoreDataClass.h"
#import "UserDao.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (nonatomic, strong) CoreDataManager *manager;
@property (nonatomic, strong) UserDao *dao;

@property (nonatomic, assign) int testInt;

@end

@implementation ViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - event response

- (IBAction)clickCreateButton {
    // 获取textfield内容
    NSString *userID    = self.userIDTextField.text;
    NSString *userName  = self.userNameTextField.text;
    if (userID.length == 0 || userName.length == 0) return;
    
    [self.dao createWithParams:@{@"id": userID, @"name": userName} completion:^(NSError *error) {
        if (error) {
            NSLog(@"添加失败, error:%@", error);
        }
    }];
    
//    NSMutableArray *arr = [NSMutableArray array];
//    for (int i = 0; i < 1000; i++) {
//        userID = [NSString stringWithFormat:@"%i", i];
//        userName = [NSString stringWithFormat:@"名字%i", i];
////        [arr addObject:@{@"id": userID, @"name": userName}];
//        [arr addObject:@{@"id": @"111", @"name": @"aaa"}];
//    }
//    [self.dao createWithArray:arr completion:^(NSError *error) {
//        if (error) {
//            NSLog(@"添加失败, error:%@", error);
//        }
//    }];
}

- (IBAction)clickDeleteButton {
    // 获取textfield内容
    NSString *userID = self.userIDTextField.text;
    if (userID.length == 0) return;
    
    [self.dao deleteWithID:userID completion:^(NSError *error) {
        if (error) {
            NSLog(@"删除失败, error:%@", error);
        }
    }];
}
- (IBAction)clickDeleteAllButton {
    [self.dao deleteAll:^(NSError *error) {
        if (error) {
            NSLog(@"删除失败, error:%@", error);
        }
    }];
}

- (IBAction)clickRetrieveButton {
    // 获取textfield内容
    NSString *userID = self.userIDTextField.text;
    if (userID.length == 0) return;
    
    NSArray *resultArray = [self.dao retrieveWithID:userID completion:^(NSError *error) {
        if (error) {
            NSLog(@"查询失败, error:%@", error);
            return;
        }
    }];
    
    // 在控制台打印结果
    NSLog(@"共查询到%li条记录", resultArray.count);
    for (User *user in resultArray) {
        NSLog(@"[%@] [%@]", user.userID, user.name);
    }
}

- (IBAction)clickRetrieveAllButton {
    NSArray *resultArray = [self.dao retrieveAll:^(NSError *error) {
        if (error) {
            NSLog(@"查询失败, error:%@", error);
            return;
        }
    }];
    
    // 在控制台打印结果
    NSLog(@"共查询到%li条记录", resultArray.count);
    for (User *user in resultArray) {
        NSLog(@"[%@] [%@]", user.userID, user.name);
    }
}

- (IBAction)clickUpdateButton {
    // 获取textfield内容
    NSString *userID    = self.userIDTextField.text;
    NSString *userName  = self.userNameTextField.text?:@"";
    if (userID.length == 0) return;
    
    [self.dao updateWithID:userID params:@{@"name": userName} completion:^(NSError *error) {
        if (error) {
            NSLog(@"更新失败, error:%@", error);
        }
    }];
}

#pragma mark - getters and setters

- (CoreDataManager *)manager {
    if (!_manager) {
        _manager = [[CoreDataManager alloc] init];
    }
    return _manager;
}

- (UserDao *)dao {
    if (!_dao) {
        _dao = [UserDaoFactory produceUserDaoWithType:UserDaoMultithreading];
    }
    return _dao;
}

@end
