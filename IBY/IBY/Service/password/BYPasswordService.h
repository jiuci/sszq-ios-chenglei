//
//  BYPasswordService.h
//  IBY
//
//  Created by St on 14-10-30.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYPasswordService : BYBaseService

@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* verifyCode;

@property (nonatomic, copy) NSString* imageVerifyCode;
@property (nonatomic, copy) NSString* smsVerifyCode;

//获取图片验证码
- (void)fetchImageVerifyCode:(void (^)(NSDictionary*, BYError*))finished;

// 验证图片验证码
- (void)checkImageVerifyCode:(NSString*)code finish:(void (^)(NSDictionary* data, BYError* error))finished;

// 验证手机验证码
- (void)checkVerifyCode:(NSString*)code
                  phone:(NSString*)phone
                 finish:(void (^)(NSDictionary* data, BYError* error))finished;

//获取短信验证码
- (void)fetchSMSVerifyCodeWithPhone:(NSString*)phoneNum
                             finish:(void (^)(NSDictionary* data, BYError* error))finished;

/**修改密码
如果是更新密码，则不输入原密码，needOldWord置为No
若是重置密码，则输入原密码，needOldWord置为Yes
 */
- (void)modifyPasswordWithPassword:(NSString*)password
                          phoneNum:(NSString*)phoneNum
                       oldPassword:(NSString*)oldPassword
                   needOldPassword:(BOOL)needOldWord
                            finish:(void (^)(NSDictionary* data, BYError* error))finished;

@end
