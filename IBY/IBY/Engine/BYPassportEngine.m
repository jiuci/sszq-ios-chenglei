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
        }else {
            finished(nil,error);
        }
    }];
}

@end
