//
//  BYCaptchaService.h
//  IBY
//
//  Created by kangjian on 15/6/19.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYCaptchaService : BYBaseService
//获取图片验证码
- (void)fetchImageVerifyCode:(void (^)(UIImage*, BYError*))finished;

// 验证图片验证码
- (void)checkImageVerifyCode:(NSString*)code finish:(void (^)(BOOL success, BYError* error))finished;





@end
