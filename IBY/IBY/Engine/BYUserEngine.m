//
//  BYUserEngine.m
//  IBY
//
//  Created by panshiyu on 15/6/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYUserEngine.h"
#import "BYUser.h"
#import "BYAppCenter.h"

@implementation BYUserEngine

+ (void)refreshUserToken:(void (^)(BOOL isSuccess, BYError* error))finished
{
    NSString* url = @"/user/customer/refreshtoken";
    [BYNetwork post:url params:nil finish:^(NSDictionary* data, BYError* error) {
        if (error) {
            finished(NO,error);
        }else{
            finished(YES,nil);
        }
    }];
}

+ (void)fetchUserLatestStatus:(void (^)(BYUser* user, BYError* error))finished
{
    if (![BYAppCenter sharedAppCenter].user.phoneNum) {
        BYError *err = makeCustomError(BYFuErrorInvalidParameter, @"com.biyao.user.update",@"phoneNum is empty", nil);
        finished(nil,err);
        return;
    }
    
    NSString* url = @"/user/customer/infobyphone";
    NSDictionary* params = @{
                             @"mobile" : [BYAppCenter sharedAppCenter].user.phoneNum
                             };
    
    [BYNetwork get:url params:params finish:^(NSDictionary* data, BYError* error) {
        if (data && !error) {
            BYUser *user = [BYUser userWithUpdateDict:data];
            
            if(user){
                finished(user,nil);
            }else{
                BYError *err = makeCustomError(BYFuErrorCannotSerialized, @"com.biyao.user.update", @"user serialized fail ", nil);
                finished(nil,err);
            }
        }else {
            finished(nil,error);
        }
    }];
}

+ (void)checkIfNicknameValid:(NSString*)nickname finish:(void (^)(BOOL isExist, BYError* error))finished
{
    NSString* url = @"customermessage/checkNickName";
    
    NSDictionary* params = @{ @"nickname" : nickname ,
                              @"mobile":[BYAppCenter sharedAppCenter].user.phoneNum};
    
    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(YES,error);
        }else{
            finished(NO,nil);
        }
    }];
}

+ (void)updateNickname:(NSString*)nickname finish:(void (^)(BOOL isSuccess, BYError* error))finished
{
    NSString* url = @"user/customer/UpdateInformation";
    
    NSDictionary* params = @{ @"nickname" : nickname,
                              @"gender" : [NSString stringWithFormat:@"%d", [BYAppCenter sharedAppCenter].user.gender] };
    
    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(NO,error);
        }else{
            finished(YES,nil);
        }
    }];
}

+ (void)syncUserDataAfterLogin:(void (^)(BOOL isSuccess, BYError* error))finished {
    if (![BYAppCenter sharedAppCenter].isLogin) {
        BYError *err = makeCustomError(BYFuErrorCannotRunAPI, @"com.biyao.user.sync", @"can not sync when not login", nil);
        finished(NO,err);
        return;
    }
    
    NSString* url = @"/shopCar/updateCustomerId";
    NSDictionary* params = @{
                             @"uid" : @([BYAppCenter sharedAppCenter].user.userID)
                             };
    NSLog(@"同步%@",params);
    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if (error) {
            NSLog(@"同步失败");
            finished(NO,error);
        }else{
            NSLog(@"同步完成");
            finished(YES,nil);
        }
    }];
}

@end
