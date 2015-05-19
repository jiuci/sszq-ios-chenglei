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

- (void)registByUser:(NSString*)user pwd:(NSString*)pwd verycode:(NSString*)code finsh:(void (^)(NSDictionary* data, BYError* error))finished
{
    NSString* url = @"user/customer/CustomerRegisterServlet";
    NSDictionary* params = @{ @"username" : user,
                              @"password" : pwd,
                              @"verycode" : @([code intValue]) };
    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        finished(data,nil);
    }];
}

- (void)fetchVerifyCode:(NSString*)phone finsh:(void (^)(NSDictionary* data, BYError* error))finished
{
    NSString* url = @"user/customer/MobilePreRegist";
    NSDictionary* params = @{ @"mobile" : phone };

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        
        finished(data,nil);
    }];
}

- (void)verifyCode:(NSString*)code phone:(NSString*)phone finsh:(void (^)(NSDictionary* data, BYError* error))finished
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

//验证手机号是否已注册
- (void)checkIfRegisted:(NSString*)phone finish:(void (^)(BOOL result, BYError* error))finished
{
    NSString* url = @"user/customer/getbyemail";
    NSDictionary* params = @{ @"umail" : phone };
    //返回success=1         已注册
    //返回 208103           未注册
    //返回208102            未知错误
    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if (error) {
            if (error.code == 208103) {
                finished(NO,nil);//未注册过
            }else if (error.code == 208102){
                finished(NO,error);
            }else{
                finished(NO,error);
            }

            
            return ;
         }
        finished(YES,nil);//已经注册过

    }];
}

@end
