//
//  BYRegistService.h
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYRegistService : BYBaseService

@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* verifyCode;

- (void)registByUser:(NSString*)user pwd:(NSString*)pwd verycode:(NSString*)code finsh:(void (^)(NSDictionary* data, BYError* error))finished;

- (void)fetchVerifyCode:(NSString*)phone finsh:(void (^)(NSDictionary* data, BYError* error))finished;

- (void)verifyCode:(NSString*)code phone:(NSString*)phone finsh:(void (^)(NSDictionary* data, BYError* error))finished;

//验证手机号是否已注册
- (void)checkIfRegisted:(NSString*)phone finish:(void (^)(BOOL result, BYError* error))finished;

@end
