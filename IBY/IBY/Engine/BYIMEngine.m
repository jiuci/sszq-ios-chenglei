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
    NSString* orgName = @"biyao-tech";
    NSString* appName = @"biyao";
    NSString* completeUrl = [NSString stringWithFormat:@"https://a1.easemob.com/%@/%@/users/%@/status",orgName,appName,user];
    NSString* brarerToken = [NSString stringWithFormat:@"Bearer %@",token];
    NSDictionary* header = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Content-Type",
                            brarerToken,@"Authorization",
                         nil];
    
    [BYNetwork getComplete:completeUrl params:nil header:header finish:^(NSDictionary * data, BYError * error){
        if (error) {
            finished(NO,error);
            return ;
        }
        BOOL isOnline;
        NSString * str = data[@"data"][user];
        if ([str isEqualToString:@"online"]) {
            isOnline = YES;
        }else{
            isOnline = NO;
        }
        finished(isOnline,nil);
    }];
}

+ (void)getToken:(void (^)(NSDictionary * dic, BYError * error))finished
{
    NSString* orgName = @"biyao-tech";
    NSString* appName = @"biyao";
    NSString* completeUrl = [NSString stringWithFormat:@"https://a1.easemob.com/%@/%@/token",orgName,appName];
    NSDictionary* header = @{ @"Content-Type" : @"application/json" };
    NSDictionary* body = @{ @"grant_type" : @"client_credentials",
                             @"client_id" : @"YXA6pHJU0HcLEeW8lhFDW02otw",
                             @"client_secret" : @"YXA66rFeMTmPE_LolnNA-Q0V0rGuEtY"
                             };

    [BYNetwork postComplete:completeUrl params:body header:header finish:^(NSDictionary * data, BYError * error){
        if (error) {
            finished(nil,error);
            return ;
        }
        finished(data,nil);
    }];
}
@end
