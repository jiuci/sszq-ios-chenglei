//
//  BYUser.m
//  IBY
//
//  Created by pan Shiyu on 14-8-26.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYUser.h"

@implementation BYUser

//数据不健全，所以这段内容未启用
- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{
        @"avatar" : @"avater_url",
        @"role" : @"userrole"
    };
}

- (BOOL)isValid
{
    if (_token && _token.length > 3) {
        return YES;
    }
    return NO;
}

- (void)updateWithLatestInfo:(NSDictionary*)info
{
    if (!info) {
        return;
    }

    if (![info isKindOfClass:[NSDictionary class]]) {
        return;
    }

    if (_userID != [info[@"customer_id"] intValue]) {
        return;
    }

    _avatar = info[@"avater_url"];
    _phoneNum = info[@"mobile"];
    _nickname = info[@"nickname"];
    _gender = [info[@"gender"] intValue];
}

@end
