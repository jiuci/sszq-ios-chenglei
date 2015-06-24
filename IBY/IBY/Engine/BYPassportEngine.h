//
//  BYPassportEngine.h
//  IBY
//
//  Created by panshiyu on 15/6/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseEngine.h"

//处理用户的登录、注册、找回密码、重置密码等passport操作
@interface BYPassportEngine : BYBaseEngine
@property (nonatomic,strong)NSMutableData*tempdata;
+ (void)loginByUser:(NSString*)user
                pwd:(NSString*)pwd
             finish:(void (^)(BYUser* user, BYError* error))finished;

+ (void)resetPasswordForUser:(NSString*)username
                 newPassword:(NSString*)password
             needOldPassword:(BOOL)needOldPassword
                 oldPassword:(NSString*)oldPassword
                         md5:(NSString*)md5
                      finish:(void (^)(BOOL success, BYError* error))finished;
+ (void)registByUser:(NSString*)user
                 pwd:(NSString*)pwd
            verycode:(NSString*)code
               finsh:(void (^)(BOOL success, BYError* error))finished;

-(void)testuser:(NSString *)user psw:(NSString*)psw md5:(NSString*)md5;
@end
