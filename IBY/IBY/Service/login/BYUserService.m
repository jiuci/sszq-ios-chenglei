//
//  BYLoginService.m
//  IBY
//
//  Created by pan Shiyu on 14-8-26.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYUserService.h"
#import "BYUser.h"
#import "BYAppCenter.h"

#import "BYCartService.h"

BYError* makeUsrError()
{
    return [BYError errorWithDomain:@"登录名或者密码错误" code:222 userInfo:nil];
}

@implementation BYUserService

- (void)loginByUser:(NSString*)user
                pwd:(NSString*)pwd
             finish:(void (^)(BYUser* user, BYError* error))finished
{
    NSString* url = @"/user/customer/login";
    NSDictionary* params = @{ @"username" : user,
                              @"password" : pwd };

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if (data && !error) {
            BYUser *user = [[BYUser alloc] init];
            user.userID = [data[@"userid"] intValue];
            user.nickname = data[@"userinfo"][@"nickname"];
            user.avatar = data[@"userinfo"][@"avater_url"];
            user.token = data[@"token"][@"token"];
            user.phoneNum = data[@"userinfo"][@"mobile"];
            [[BYAppCenter sharedAppCenter] didLogin:user];
            
            BYCartService *cartService = [[BYCartService alloc] init];
            [cartService uploadCart:^(NSDictionary *data, BYError *error) {
                BYLog(@"");
            }];
            
            finished(user,nil);
        }else {
            finished(nil,error);
        }
    }];
}

- (void)refreshToken:(void (^)(BOOL isSuccess, BYError* error))finished
{
    NSString* url = @"/user/customer/refreshtoken";
    [BYNetwork post:url params:nil finish:^(NSDictionary* data, BYError* error) {
        if (data && !error) {
            //成功
            finished(YES,nil);
        }else {
            finished(NO,nil);
        }
    }];
    
}

- (void)fetchUserLatestStatus:(void (^)(BOOL isSuccess, BYError* error))finished
{

    NSString* url = @"/user/customer/infobyphone";
    NSDictionary* params = @{ @"mobile" : [BYAppCenter sharedAppCenter].user.phoneNum };

    [BYNetwork get:url params:params finish:^(NSDictionary* data, BYError* error) {
        if (data && !error) {
            [[BYAppCenter sharedAppCenter].user updateWithLatestInfo:data[@"customer"]];
            finished(YES,nil);
        }else {
            finished(NO,error);
        }
    }];
}

- (void)checkNicknameByName:(NSString*)nickname finish:(void (^)(BOOL))finished
{
    NSString* url = @"customermessage/checkNickName";

    NSDictionary* params = @{ @"nickname" : nickname ,
                              @"mobile":[BYAppCenter sharedAppCenter].user.phoneNum};

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(TRUE);
            return ;
        }
        finished(FALSE);
    }];
}

- (void)updateNicknameByName:(NSString*)nickname finish:(void (^)(BOOL))finished
{

    NSString* url = @"user/customer/UpdateInformation";

    NSDictionary* params = @{ @"nickname" : nickname,
                              @"gender" : [NSString stringWithFormat:@"%d", [BYAppCenter sharedAppCenter].user.gender] };

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(FALSE);
            return ;
        }
        finished(TRUE);
    }];
}

@end
