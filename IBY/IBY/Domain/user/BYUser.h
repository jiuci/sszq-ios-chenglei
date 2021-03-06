//
//  BYUser.h
//  IBY
//
//  Created by pan Shiyu on 14-8-26.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseDomain.h"

@interface BYUser : BYBaseDomain

@property (nonatomic, assign) UInt32 userID;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, assign) int gender; //性别
@property (nonatomic, copy) NSString* avatar;
@property (nonatomic, assign) int role; //角色，用普通用户、商户、设计师几种
@property (nonatomic, copy) NSString* phoneNum;
@property (nonatomic, copy) NSString* idCard;

@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* cardID;

@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* userType;

@property (nonatomic, assign) int refundNum;
@property (nonatomic, assign) int toReceiveOrderNum;
@property (nonatomic, assign) int notPayOrderNum;

@property (nonatomic, assign) int messageNum;

+ (instancetype)userWithLoginDict:(NSDictionary*)info;
+ (instancetype)userWithUpdateDict:(NSDictionary*)info;

- (void)updateWithAnother:(BYUser*)user;

- (BOOL)isValid;

- (NSString*)cookieUserInfoStr;

@end
