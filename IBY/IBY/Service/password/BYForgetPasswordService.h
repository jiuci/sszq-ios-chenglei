//
//  BYForgetPasswordService.h
//  IBY
//
//  Created by kangjian on 15/6/19.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"
#import "BYVerifyCodeEngine.h"
#import "BYPassportEngine.h"

@interface BYForgetPasswordService : BYBaseService

@property (nonatomic,strong)NSString* phone;
@property (nonatomic,strong)NSString* md5;
//获取图片验证码
- (void)fetchImageVerifyCode:(void (^)(UIImage*, BYError*))finished;

// 验证图片验证码
- (void)checkImageVerifyCode:(NSString*)code finish:(void (^)(BOOL success, BYError* error))finished;

// 验证手机验证码
- (void)checkVerifyCode:(NSString*)code
                  phone:(NSString*)phone
                 finish:(void (^)(BOOL success, BYError* error))finished;

//获取短信验证码
- (void)fetchSMSVerifyCodeForResetPasswordWithPhone:(NSString*)phoneNum
                             finish:(void (^)(BYFetchVerifyCodeStatus status, BYError* error))finished;

- (void)resetPassword:(NSString*)password finish:(void (^)(BOOL success, BYError* error))finished;
@end
