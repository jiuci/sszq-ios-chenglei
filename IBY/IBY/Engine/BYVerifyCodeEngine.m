//
//  BYVerifyCodeEngine.m
//  IBY
//
//  Created by panshiyu on 15/6/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYVerifyCodeEngine.h"

@implementation BYVerifyCodeEngine
+ (void)fetchImageVerifyCode:(void (^)(NSDictionary*, BYError*))finished
{
    NSString* url = @"vcode/getvcode";
    NSDictionary* param = @{ @"id" : [BYAppCenter sharedAppCenter].uuid };
    
    [BYNetwork get:url params:param finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        finished(data,nil);
        
    }];
}
+ (void)checkImageVerifyCode:(NSString*)code finish:(void (^)(NSDictionary* data, BYError* error))finished;
{
    NSString* url = @"vcode/validatevcode";
    NSDictionary* param = @{
                            @"captcha_input" : code,
                            @"id" : [BYAppCenter sharedAppCenter].uuid
                            };
    [BYNetwork get:url params:param finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        finished(data,nil);
    }];
}
+ (void)checkVerifyCode:(NSString*)code phone:(NSString*)phone finish:(void (^)(NSDictionary* data, BYError* error))finished
{
    NSString* url = @"regist/checkPhoneAndCode";
    NSDictionary* params = @{ @"mobile" : phone,
                              @"code" : code };
    
    [BYNetwork get:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        
        finished(data,nil);
    }];
}

+ (void)fetchSMSVerifyCodeWithPhone:(NSString*)phoneNum finish:(void (^)(NSDictionary*, BYError*))finished
{
    NSString* url = @"user/customer/CustomerAcquireCode";
    NSDictionary* param = @{ @"Mobile" : phoneNum };
    
    [BYNetwork post:url params:param finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        finished(data,nil);
    }];
}
@end
