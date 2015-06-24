//
//  BYLoginService.m
//  IBY
//
//  Created by panshiyu on 15/6/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYLoginService.h"
#import "BYPassportEngine.h"
#import "BYUserEngine.h"

@implementation BYLoginService

- (void)loginByUser:(NSString*)user
                pwd:(NSString*)pwd
             finish:(void (^)(BYUser* user, BYError* error))finished {
    [BYPassportEngine loginByUser:user pwd:pwd finish:^(BYUser *user, BYError *error) {
        if (user&&!error) {
            [[BYAppCenter sharedAppCenter] didLogin:user];
            finished(user,nil);
            
            [BYUserEngine syncUserDataAfterLogin:^(BOOL isSuccess, BYError *error) {
                //无论结果如何，不处理，不显示
            }];
            
        }else{
            finished(user,error);
        }
    }];
}

@end
