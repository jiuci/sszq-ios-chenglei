//
//  SAKShareConfig.m
//  SAKShareKit
//
//  Created by pan Shiyu on 14-1-6.
//  Copyright (c) 2014年 psy. All rights reserved.
//

#import "SAKShareConfig.h"

static SAKShareConfig* shareConfig = nil;
@implementation SAKShareConfig

+ (SAKShareConfig*)sharedInstance
{
    NSCAssert(shareConfig != nil, @"先初始化再用");
    return shareConfig;
}

+ (SAKShareConfig*)sharedInstanceWithConfig:(SAKShareConfig*)config
{
    NSCAssert(shareConfig == nil, @"既然初始化过了，就别再用这个方法啦");

    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareConfig = config;
    });

    return shareConfig;
}

//qq
- (NSString*)qqClientKey
{
    return nil;
}

//weixin
- (NSString*)weixinClientKey
{
    return nil;
}

//qqweibo
- (NSString*)qqweiboAccessToken
{
    return nil;
}

- (NSString*)qqweiboAppKey
{
    return nil;
}

- (NSString*)qqweiboOpenID
{
    return nil;
}

//qzone
- (NSString*)qzoneAccessToken
{
    return nil;
}

- (NSString*)qzoneAppID
{
    return nil;
}

- (NSString*)qzoneOpenID
{
    return nil;
}

//sina
- (NSString*)sinaAccessToken
{
    return nil;
}

- (NSString*)sinaAppKey
{
    return nil;
}

- (NSString*)sinaClientKey
{
    return nil;
}

@end
