//
//  SAKShareConfig.h
//  SAKShareKit
//
//  Created by pan Shiyu on 14-1-6.
//  Copyright (c) 2014年 psy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAKShareConfig : NSObject

+ (SAKShareConfig*)sharedInstance;
+ (SAKShareConfig*)sharedInstanceWithConfig:(SAKShareConfig*)config;
//qq
- (NSString*)qqClientKey;

//weixin
- (NSString*)weixinClientKey;

//qqweibo
- (NSString*)qqweiboAccessToken;
- (NSString*)qqweiboAppKey;
- (NSString*)qqweiboOpenID;

//qzone
- (NSString*)qzoneAccessToken;
- (NSString*)qzoneAppID;
- (NSString*)qzoneOpenID;

//sina
- (NSString*)sinaAccessToken;
- (NSString*)sinaAppKey;
- (NSString*)sinaClientKey;

@end
