//
//  BYRegistService.h
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"
#import "BYVerifyCodeEngine.h"
#import "BYPassportEngine.h"

@interface BYRegistService : BYBaseService

@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* verifyCode;
@property (nonatomic,strong)NSString* md5;

- (void)registByUser:(NSString*)user pwd:(NSString*)pwd verycode:(NSString*)code finsh:(void (^)(BOOL success, BYError* error))finished;


// 验证手机验证码
- (void)checkVerifyCode:(NSString*)code
                  phone:(NSString*)phone
                 finish:(void (^)(BOOL success, BYError* error))finished;

//获取短信验证码
- (void)fetchSMSVerifyCodeWithPhone:(NSString*)phoneNum
                             finish:(void (^)(BYFetchVerifyCodeStatus status, BYError* error))finished;
@end
