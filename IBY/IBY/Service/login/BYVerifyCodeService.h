//
//  BYVerifyCodeService.h
//  IBY
//
//  Created by kangjian on 15/6/19.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYVerifyCodeService : BYBaseService
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
@end
