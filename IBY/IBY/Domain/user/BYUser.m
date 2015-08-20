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

+ (instancetype)userWithLoginDict:(NSDictionary*)info
{
    BYUser* user = [[BYUser alloc] init];
    user.userID = [info[@"userid"] intValue];
    user.nickname = info[@"userinfo"][@"nickname"];
    user.avatar = info[@"userinfo"][@"avater_url"];
    user.token = info[@"token"][@"token"];
    user.phoneNum = info[@"userinfo"][@"mobile"];
    user.gender = [info[@"userinfo"][@"gender"] intValue];
    user.email = info[@"userinfo"][@"email"];
    user.idCard = info[@"userinfo"][@"idcard"];
    if (![user.email.class isSubclassOfClass:[NSString class]]) {
        user.email = @"";
    }
    user.cardID = info[@"userinfo"][@"idcard"];

    return user;
}

+ (instancetype)userWithUpdateDict:(NSDictionary*)info
{
    BYUser* user = [[BYUser alloc] init];
    user.userID = [info[@"customer"][@"customer_id"] intValue];
    user.nickname = info[@"customer"][@"nickname"];
    user.avatar = info[@"customer"][@"avater_url"];
    user.gender = [info[@"customer"][@"gender"] intValue];
    user.phoneNum = info[@"customer"][@"mobile"];
    user.refundNum = [info[@"refundNum"] intValue];
    user.toReceiveOrderNum = [info[@"toReceiveOrderNum"] intValue];
    user.notPayOrderNum = [info[@"notPayOrderNum"] intValue];
    user.messageNum = [info[@"messageNum"] intValue];
    user.idCard = info[@"customer"][@"idcard"];
    return user;
}

- (void)updateWithAnother:(BYUser*)user
{
    if (!user) {
        return;
    }
    if (_userID != user.userID) {
        return;
    }

    _avatar = user.avatar;
    _phoneNum = user.phoneNum;
    _nickname = user.nickname;
    _gender = user.gender;
    _avatar = user.avatar;
    _toReceiveOrderNum = user.toReceiveOrderNum;
    _notPayOrderNum = user.notPayOrderNum;
    _refundNum = user.refundNum;
    _messageNum = user.messageNum;
}

- (BOOL)isValid
{
    if ( _userID && _token && _token.length > 3) {
        return YES;
    }
    return NO;
}

- (NSString*)cookieUserInfoStr
{
    //userinfo 规则: 昵称,头像地址,uid ,手机号    写入Cookie前需要做URLEncoder
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@", _nickname, _avatar, @(_userID), _phoneNum,_userType];
}

@end
