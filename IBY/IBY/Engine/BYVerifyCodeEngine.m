//
//  BYVerifyCodeEngine.m
//  IBY
//
//  Created by panshiyu on 15/6/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYVerifyCodeEngine.h"
#import "Base64Helper.h"

@implementation BYVerifyCodeEngine
+ (void)fetchImageVerifyCode:(void (^)(UIImage*, BYError*))finished
{
    NSString* url = @"vcode/getvcode";
    NSDictionary* param = @{ @"id" : [BYAppCenter sharedAppCenter].uuid };
    
    [BYNetwork get:url params:param finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        NSString *stringData = data[@"decodeImage"];
        if (stringData) {
            UIImage *codeImage = [Base64Helper  string2Image:stringData];
            if (codeImage) {
                finished(codeImage,nil);
                return;
            }
        }else{
            BYError *err = makeCustomError(BYFuErrorCannotSerialized, @"com.biyao.verifycode.image", @"image is not valid", nil);
            finished(nil,err);
        }
        
    }];
}
+ (void)checkImageVerifyCode:(NSString*)code finish:(void (^)(BOOL success, BYError* error))finished;
{
    NSString* url = @"vcode/validatevcode";
    NSDictionary* param = @{
                            @"captcha_input" : code,
                            @"id" : [BYAppCenter sharedAppCenter].uuid
                            };
    [BYNetwork get:url params:param finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(NO,error);
            return ;
        }
        finished(YES,nil);
    }];
}
+ (void)checkVerifyCode:(NSString*)code phone:(NSString*)phone finish:(void (^)(NSString* md5, BYError* error))finished
{
    NSString* url = @"regist/checkPhoneAndCode";
    NSDictionary* params = @{ @"mobile" : phone,
                              @"code" : code };
    
    [BYNetwork get:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        NSString* md5 = data[@"md5"];
        if (md5.length == 32) {
            finished(data[@"md5"],nil);
            return;
        }else{
            BYError*err = [BYError errorWithDomain:@"com.biyao.VerifyCode.checkVerifycode" code:BYNetErrorDomainWrongFormat userInfo:nil];
            finished(nil,err);
        }
        
        
    }];
}
+ (void)fetchSMSVerifyCodeForRegistWithPhone:(NSString*)phoneNum finish:(void (^)(BYFetchVerifyCodeStatus status, BYError* error))finished;
{
    NSString* url = @"user/customer/MobilePreRegist";
    NSDictionary* param = @{ @"Mobile" : phoneNum };
    
    [BYNetwork post:url params:param finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(NO,error);
            return ;
        }
        finished(YES,nil);
    }];
}
+ (void)fetchSMSVerifyCodeForResetPasswordWithPhone:(NSString*)phoneNum finish:(void (^)(BYFetchVerifyCodeStatus status, BYError* error))finished;
{
    NSString* url = @"user/customer/CustomerAcquireCode";
    NSDictionary* param = @{ @"Mobile" : phoneNum };
    
    [BYNetwork post:url params:param finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(NO,error);
            return ;
        }
        finished(YES,nil);
    }];
}
@end
