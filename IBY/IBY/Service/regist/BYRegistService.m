//
//  BYRegistService.m
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYRegistService.h"

@implementation BYRegistService

/* 参数
 username 	y 	string 	用户名
 password 	y 	string 	密码
 verycode 	y 	int 	验证码 */

// username=18001350673&&password=test123&&verycode=23jkle

- (void)registByUser:(NSString*)user pwd:(NSString*)pwd verycode:(NSString*)code finsh:(void (^)(BOOL success, BYError* error))finished
{
    [BYPassportEngine registByUser:user pwd:pwd verycode:code finsh:finished];
}

- (void)checkVerifyCode:(NSString*)code phone:(NSString*)phone finish:(void (^)(BOOL success, BYError* error))finished
{
    [BYVerifyCodeEngine checkVerifyCode:code phone:phone finish:^(NSString* md5, BYError* error) {
        if(error){
            finished(NO,error);
            return ;
        }
        _md5 = md5;//TODO api
        finished(YES,nil);
    }];
}

- (void)fetchSMSVerifyCodeWithPhone:(NSString*)phoneNum finish:(void (^)(BYFetchVerifyCodeStatus status, BYError*))finished
{
    [BYVerifyCodeEngine fetchSMSVerifyCodeForRegistWithPhone:phoneNum finish:finished];
}



@end
