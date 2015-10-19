//
//  BYIMPassWordEngine.m
//  IBY
//
//  Created by forbertl on 15/10/13.
//  Copyright © 2015年 com.biyao. All rights reserved.
//

#import "BYIMEngine.h"

@implementation BYIMEngine
+ (void)loadpassword:(void (^)(NSString * password, BYError* error))finished
{
    NSString* url = @"/webim/password";
    
    [BYNetwork get:url params:nil finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        finished(data[@"password"],nil);
    }];

}


+ (void)getTargetStatus:(NSString *)user token:(NSString *)token finish:(void (^)(BOOL online, BYError* error))finished
{
    NSString* orgName = @"zhaohua";
    NSString* appName = @"im";
    NSString* completeUrl = [NSString stringWithFormat:@"https://a1.easemob.com/%@/%@/users/%@/status",orgName,appName,user];
    NSString* brarerToken = [NSString stringWithFormat:@"Bearer %@",token];
    NSDictionary* header = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Content-Type",
                            brarerToken,@"Authorization",
                         nil];
    
    [BYNetwork getComplete:completeUrl params:nil header:header finish:^(NSDictionary * data, BYError * error){
//        NSLog(@"%@",data);
        if (error) {
            finished(NO,error);
            return ;
        }
        BOOL isOnline ;//= YES;
        NSString * str = data[@"data"][user];
        if ([str isEqualToString:@"online"]) {
            isOnline = YES;
        }else{
            isOnline = NO;
        }
        finished(isOnline,nil);
    }];
}

+ (void)getToken:(void (^)(NSString * token, BYError * error))finished
{
    NSString* orgName = @"zhaohua";
    NSString* appName = @"im";
    NSString* completeUrl = [NSString stringWithFormat:@"https://a1.easemob.com/%@/%@/token",orgName,appName];
    NSDictionary* header = @{ @"Content-Type" : @"application/json" };
    NSDictionary* body = @{ @"grant_type" : @"client_credentials",
                             @"client_id" : @"YXA6ux_OcFajEeWnHOsBoSt5KA",
                             @"client_secret" : @"YXA6S4kyKvezYV8PaDlT3zDZswxvG88"
                             };

    [BYNetwork postComplete:completeUrl params:body header:header finish:^(NSDictionary * data, BYError * error){
        if (error) {
            finished(nil,error);
            return ;
        }
        finished(data[@"access_token"],nil);
    }];
}
@end
