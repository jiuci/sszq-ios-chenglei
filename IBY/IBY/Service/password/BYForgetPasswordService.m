//
//  BYForgetPasswordService.m
//  IBY
//
//  Created by kangjian on 15/6/19.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYForgetPasswordService.h"

@implementation BYForgetPasswordService
- (void)fetchImageVerifyCode:(void (^)(UIImage*, BYError*))finished
{
    [BYVerifyCodeEngine fetchImageVerifyCode:finished];
}
- (void)checkImageVerifyCode:(NSString*)code finish:(void (^)(BOOL success, BYError* error))finished;
{
    [BYVerifyCodeEngine checkImageVerifyCode:code finish:finished];
}
- (void)checkVerifyCode:(NSString*)code phone:(NSString*)phone finish:(void (^)(BOOL success, BYError* error))finished
{
    NSLog(@"%@,%@",phone,code);
    [BYVerifyCodeEngine checkVerifyCode:code
                                  phone:phone
                                 finish:^(NSString* md5, BYError* error) {
                                     if (error) {
                                         finished(NO, error);
                                         return;
                                     }
                                     _md5 = md5;
                                     finished(YES, nil);
                                 }];
}

- (void)fetchSMSVerifyCodeForResetPasswordWithPhone:(NSString*)phoneNum finish:(void (^)(BYFetchVerifyCodeStatus, BYError*))finished
{
    [BYVerifyCodeEngine fetchSMSVerifyCodeForResetPasswordWithPhone:phoneNum finish:finished];
}

- (void)resetPassword:(NSString*)password finish:(void (^)(BOOL success, BYError* error))finished
{

    if (_md5) {
        [BYPassportEngine resetPasswordForUser:self.phone newPassword:password needOldPassword:NO oldPassword:nil md5:_md5 finish:finished];
    }
    else {
        // 奇怪但是有可能出现的错误
        BYError* err = [[BYError alloc] init];
        err.byErrorCode = BYNetErrorNotExist;
        err.byDomain = @"com.biyao.forgetpassword.resetpassword";
        err.byErrorMsg = @"未经过短信验证无法重置密码";
        finished(NO, err);
    }
}

@end
