//
//  BYVerifyCodeEngine.h
//  IBY
//
//  Created by panshiyu on 15/6/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseEngine.h"
typedef NS_OPTIONS(NSUInteger, BYFetchVerifyCodeStatus) {
    BYFetchCodeSuccess,
    BYFetchCodeFail,
    BYFetchCodeRegisted,
    BYFetchCodeNeedRegist
};
//处理各种验证码逻辑
@interface BYVerifyCodeEngine : BYBaseEngine
//获取图片验证码
+ (void)fetchImageVerifyCode:(void (^)(UIImage*, BYError*))finished;

// 验证图片验证码
+ (void)checkImageVerifyCode:(NSString*)code finish:(void (^)(BOOL success, BYError* error))finished;

// 验证手机验证码
+ (void)checkVerifyCode:(NSString*)code
                  phone:(NSString*)phone
                 finish:(void (^)(NSString* md5, BYError* error))finished;

//获取短信验证码
+ (void)fetchSMSVerifyCodeForRegistWithPhone:(NSString*)phoneNum finish:(void (^)(BYFetchVerifyCodeStatus status, BYError* error))finished;

+ (void)fetchSMSVerifyCodeForResetPasswordWithPhone:(NSString*)phoneNum
                             finish:(void (^)(BYFetchVerifyCodeStatus status, BYError* error))finished;
@end
