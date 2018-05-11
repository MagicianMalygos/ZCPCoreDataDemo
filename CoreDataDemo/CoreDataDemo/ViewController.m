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

#define EntityName  @"User"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (nonatomic, strong) CoreDataManager *manager;

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
    
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    // 2.创建MO并使用MOC进行监听
    User *user = [NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:context];
    
    // 3.设值
    user.userID = userID;
    user.name = userName;
    
    // 4.保存提交
    [self.manager saveContext];
    NSLog(@"保存成功");
}

- (IBAction)clickDeleteButton {
    // 获取textfield内容
    NSString *userID = self.userIDTextField.text;
    if (userID.length == 0) return;
    
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    // 2.创建查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", userID]];
    [fetchRequest setPredicate:predicate];
    
    // 3.执行查询方法，返回结果
    NSError *error = nil;
    NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        // log error
        NSLog(@"删除失败，error:%@", error);
        return;
    }
    
    // 4.将MO标记为删除
    for (User *user in resultArray) {
        [context deleteObject:user];
    }
    // 5.提交修改
    [self.manager saveContext];
    NSLog(@"删除成功");
}

- (IBAction)clickRetrieveButton {
    // 获取textfield内容
    NSString *userID = self.userIDTextField.text;
    if (userID.length == 0) return;
    
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    // 2.创建查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", userID]];
    [fetchRequest setPredicate:predicate];
    
    // 3.执行查询方法，返回结果
    NSError *error = nil;
    NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        // log error
        NSLog(@"查询失败");
        return;
    }
    
    // 4.在控制台打印结果
    NSLog(@"共查询到%li条记录", resultArray.count);
    for (User *user in resultArray) {
        NSLog(@"[%@] [%@]", user.userID, user.name);
    }
}

- (IBAction)clickTetrieveAllButton {
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    // 2.创建查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
    
    // 3.执行查询方法，返回结果
    NSError *error = nil;
    NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        // log error
        NSLog(@"查询失败");
        return;
    }
    
    // 4.在控制台打印结果
    NSLog(@"共查询到%li条记录", resultArray.count);
    for (User *user in resultArray) {
        NSLog(@"[%@] [%@]", user.userID, user.name);
    }
}

- (IBAction)clickUpdateButton {
    // 获取textfield内容
    NSString *userID    = self.userIDTextField.text;
    NSString *userName  = self.userNameTextField.text;
    if (userID.length == 0) return;
    
    // 1.获取MOC
    NSManagedObjectContext *context = self.manager.moc;
    
    // 2.创建查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:EntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userID == %@", userID]];
    [fetchRequest setPredicate:predicate];
    
    // 3.执行查询方法，返回结果
    NSError *error = nil;
    NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        // log error
        NSLog(@"更新失败，error:%@", error);
        return;
    }
    
    // 4.更新MO
    for (User *user in resultArray) {
        user.name = userName;
    }
    
    // 5.提交修改
    [self.manager saveContext];
    NSLog(@"更新成功");
}

#pragma mark - getters and setters

- (CoreDataManager *)manager {
    if (!_manager) {
        _manager = [[CoreDataManager alloc] init];
    }
    return _manager;
}

@end
