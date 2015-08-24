//
//  BYTools.h
//  IBY
//
//  Created by panShiyu on 14/12/4.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYTools : NSObject

@end

void clearCookies();
void inputCookies();
BOOL checkLoginCookies();
void resetCookies();
void logCookies();
void loggobackCookies();
void addCookies(NSString* uriStr,NSString* inCookieName, NSString* inCookiePath);
void setCookies(NSString* name, NSString* value);
NSHTTPCookie* createCookie(NSString* name, NSString* value);

UIImageView* makeSepline();
UIImageView* makeImgView(CGRect frame, NSString* picName);

void alertError(NSError* error);
void alertCommonError(NSError* error, NSString* defaultMessage);
void alertPoolnetError();
void alertPushSimplely(NSString* info);

#pragma mark - block tools

void runOnMainQueue(void (^block)(void));
void runOnBackgroundQueue(void (^block)(void));
void runBlockAfterDelay(float delaySeconds, void (^block)(void));
