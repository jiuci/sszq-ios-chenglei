//
//  BYAccountEngine.m
//  IBY
//
//  Created by panshiyu on 15/6/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYPassportEngine.h"
#import "BYUser.h"

@implementation BYPassportEngine

+ (void)loginByUser:(NSString*)user
                pwd:(NSString*)pwd
             finish:(void (^)(BYUser* user, BYError* error))finished{
    NSString* url = @"/user/customer/login";
    NSDictionary* params = @{ @"username" : user,
                              @"password" : pwd
                              };
    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if (data && !error) {
            BYUser *user = [[BYUser alloc] init];
            user.userID = [data[@"userid"] intValue];
            user.nickname = data[@"userinfo"][@"nickname"];
            user.avatar = data[@"userinfo"][@"avater_url"];
            user.token = data[@"token"][@"token"];
            user.phoneNum = data[@"userinfo"][@"mobile"];
            user.gender = [data[@"userinfo"][@"gender"] intValue];
            
            if(user.isValid){
                finished(user,nil);
            }else{
                BYError *err = makeCustomError(BYFuErrorCannotSerialized, @"com.biyao.passport.login", @"user is not valid", nil);
                finished(nil,err);
            }
        }else if(error.code == 208103){//代表用户未注册
            BYUser *user = [[BYUser alloc] init];
            finished(user,error);
        }else{
            finished(nil,error);
        }
    }];
}
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSHTTPURLResponse*)response
{
    _tempdata =[NSMutableData data];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [_tempdata appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString*str =[[NSString alloc]initWithData:_tempdata encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
}
-(void)testuser:(NSString *)user psw:(NSString*)psw md5:(NSString*)md5
{
    NSMutableURLRequest*request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.biyao.com/user/customer/MobilePreRegist"]];
    request.HTTPMethod=@"POST";
    NSMutableDictionary* params = [NSMutableDictionary dictionary];

    [params safeSetValue:@"13810728126" forKey:@"mobile"];
//    [params safeSetValue:psw forKey:@"NewPassword"];
//    [params safeSetValue:md5 forKey:@"md5"];
    NSMutableData*postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"Mobile=13810728126"] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody =postBody;
    NSURLConnection*c =[NSURLConnection connectionWithRequest:request delegate:self];
    [c start];

}
+ (void)registByUser:(NSString*)user
                 pwd:(NSString*)pwd
            verycode:(NSString*)code
               finsh:(void (^)(BOOL success, BYError* error))finished
{
    NSString* url = @"user/customer/CustomerRegisterServlet";
    NSDictionary* params = @{ @"username" : user,
                              @"password" : pwd,
                              @"verycode" : code,
                              @"source"   : @"iOS" } ;
    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(NO,error);
        }else{
            finished(YES,nil);
        }
    }];
}
+ (void)resetPasswordForUser:(NSString*)username
                 newPassword:(NSString*)password
             needOldPassword:(BOOL)needOldPassword
                 oldPassword:(NSString*)oldPassword
                         md5:(NSString*)md5
                      finish:(void (^)(BOOL success, BYError* error))finished;
{
    NSString* url = @"user/customer/UpdatePassword";
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params safeSetValue:username forKey:@"username"];
    [params safeSetValue:password forKey:@"NewPassword"];
    if (needOldPassword) {
        [params safeSetValue:@"true" forKey:@"needOldPasswd"];
    }else{
        [params safeSetValue:@"false" forKey:@"needOldPasswd"];
    }
    [params safeSetValue:oldPassword forKey:@"oldPassword"];
    [params safeSetValue:md5 forKey:@"md5"];
       [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(NO,error);
        }else{
            finished(YES,nil);
        }
    }];
}

@end
