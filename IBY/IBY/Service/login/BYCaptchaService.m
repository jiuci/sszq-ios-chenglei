//
//  BYCaptchaService.m
//  IBY
//
//  Created by kangjian on 15/6/19.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYCaptchaService.h"
#import "BYVerifyCodeEngine.h"
@implementation BYCaptchaService
- (void)fetchImageVerifyCode:(void (^)(UIImage *, BYError*))finished
{
    [BYVerifyCodeEngine fetchImageVerifyCode:finished];
    
}
- (void)checkImageVerifyCode:(NSString*)code finish:(void (^)(BOOL success, BYError* error))finished;
{
    [BYVerifyCodeEngine checkImageVerifyCode:code finish:finished];
}


@end
