//
//  BYIMPassWordEngine.h
//  IBY
//
//  Created by forbertl on 15/10/13.
//  Copyright © 2015年 com.biyao. All rights reserved.
//

#import "BYBaseEngine.h"

@interface BYIMEngine : BYBaseEngine

+ (void)loadpassword:(void (^)(NSString * password, BYError* error))finished;

+ (void)getTargetStatus:(NSString *)user token:(NSString *)token finish:(void (^)(BOOL online, BYError* error))finished;

+ (void)getToken:(void (^)(NSDictionary * dic, BYError * error))finished;

@end
