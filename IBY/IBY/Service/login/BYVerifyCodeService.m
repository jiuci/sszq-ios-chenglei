//
//  BYVerifyCodeService.m
//  IBY
//
//  Created by kangjian on 15/6/19.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYVerifyCodeService.h"
#import "BYVerifyCodeEngine.h"

@implementation BYVerifyCodeService
- (void)fetchImageVerifyCode:(void (^)(NSDictionary*, BYError*))finished
{
    [BYVerifyCodeEngine fetchImageVerifyCode:finished];

}
- (void)checkImageVerifyCode:(NSString*)code finish:(void (^)(NSDictionary* data, BYError* error))finished;
{
    [BYVerifyCodeEngine checkImageVerifyCode:code finish:finished];
}
- (void)checkVerifyCode:(NSString*)code phone:(NSString*)phone finish:(void (^)(NSDictionary* data, BYError* error))finished
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

- (void)fetchSMSVerifyCodeWithPhone:(NSString*)phoneNum finish:(void (^)(NSDictionary*, BYError*))finished
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
