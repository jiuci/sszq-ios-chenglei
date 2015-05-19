//
//  BYLoginService.h
//  IBY
//
//  Created by pan Shiyu on 14-8-26.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"
#import "BYUser.h"

@interface BYUserService : BYBaseService

- (void)loginByUser:(NSString*)user
                pwd:(NSString*)pwd
             finish:(void (^)(BYUser* user, BYError* error))finished;

- (void)refreshToken:(void (^)(BOOL isSuccess, BYError* error))finished;

- (void)fetchUserLatestStatus:(void (^)(BOOL isSuccess, BYError* error))finished;

- (void)checkNicknameByName:(NSString*)nickname finish:(void (^)(BOOL exitance))finished;

- (void)updateNicknameByName:(NSString*)nickname finish:(void (^)(BOOL success))finished;

@end
