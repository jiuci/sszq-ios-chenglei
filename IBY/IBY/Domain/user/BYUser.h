//
//  BYUser.h
//  IBY
//
//  Created by pan Shiyu on 14-8-26.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseDomain.h"

@interface BYUser : BYBaseDomain

@property (nonatomic, assign) int userID;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, assign) int gender; //性别
@property (nonatomic, copy) NSString* avatar;
@property (nonatomic, assign) int role; //角色，用普通用户、商户、设计师几种
@property (nonatomic, copy) NSString* phoneNum;

@property (nonatomic, copy) NSString* token;

- (BOOL)isValid;

- (void)updateWithLatestInfo:(NSDictionary*)info;

@end
