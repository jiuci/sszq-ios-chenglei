//
//  BYUserEngine.h
//  IBY
//
//  Created by panshiyu on 15/6/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseEngine.h"
@class BYUser;

//用户信息的类
@interface BYUserEngine : BYBaseEngine

//userToken延期，如果延期失败，则说明token无效
+ (void)refreshUserToken:(void (^)(BOOL isSuccess, BYError* error))finished;

//用户最新的状态
+ (void)fetchUserLatestStatus:(void (^)(BOOL success, BYError* error))finished;

//检查昵称是否被占用
//+ (void)checkIfNicknameValid:(NSString*)nickname finish:(void (^)(BOOL isExist, BYError* error))finished;

//设置昵称
+ (void)updateNickname:(NSString*)nickname finish:(void (^)(BOOL isSuccess, BYError* error))finished;

//登录后同步数据
+ (void)syncUserDataAfterLogin:(void (^)(BOOL isSuccess, BYError* error))finished;

//设置性别
+ (void)updateGender:(NSString*)gender finish:(void (^)(BOOL success, BYError* error))finished;
@end
