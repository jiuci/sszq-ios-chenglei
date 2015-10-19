//
//  BYIMPassWordService.m
//  IBY
//
//  Created by forbertl on 15/10/13.
//  Copyright © 2015年 com.biyao. All rights reserved.
//

#import "BYIMService.h"
#import "BYIMEngine.h"

@implementation BYIMService
- (void)loadpassword:(void (^)(NSString * password, BYError* error))finished
{
    [BYIMEngine loadpassword:finished];
}


- (void)getTargetStatus:(NSString *)user finish:(void (^)(BOOL online, BYError* error))finished
{
    if (_token) {
        [BYIMEngine getTargetStatus:user token:_token finish:finished];
        return;
    }
    __weak typeof (self) wself = self;
    [BYIMEngine getToken:^(NSString * token,BYError* error){
        if (error) {
            NSLog(@"error%@",error);
            finished(NO,error);
        }else{
            self.token = token;
            [self getTargetStatus:user finish:finished];
        }
    }];
}
@end
