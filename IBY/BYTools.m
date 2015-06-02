//
//  BYTools.m
//  IBY
//
//  Created by panShiyu on 14/12/4.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYTools.h"

@implementation BYTools

@end

void clearCookies()
{
    NSHTTPCookieStorage* cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie* obj in cookies) {
        [cookieJar deleteCookie:obj];
    }
}

void inputCookies()
{
    setCookies(@"DZVISIT", [BYAppCenter sharedAppCenter].visitCode);
    setCookies(@"fromapp", @"ios|9999");
    setCookies(@"uuid", [BYAppCenter sharedAppCenter].uuid);
    
//    if (![BYAppCenter sharedAppCenter].isLogin) {
//        resetCookies();
//        return;
//    }
//    
//    //加入引号，为了解决cookie读取的问题
//    NSString* strUid = IntToString([BYAppCenter sharedAppCenter].user.userID);
//    NSString* token = [NSString stringWithFormat:@"\"%@\"", [BYAppCenter sharedAppCenter].user.token];
//    
//    setCookies(@"uid", strUid);
//    setCookies(@"token", token);
}

NSHTTPCookie* createCookie(NSString* name, NSString* value)
{
    NSMutableDictionary* cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:name forKey:NSHTTPCookieName];
    [cookieProperties setObject:value forKey:NSHTTPCookieValue];

    [cookieProperties setObject:@".biyao.com" forKey:NSHTTPCookieDomain];
//    [cookieProperties setObject:@"192.168.97.69" forKey:NSHTTPCookieDomain];

    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:360000] forKey:NSHTTPCookieExpires];

    NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    return cookie;
}

void setCookies(NSString* name, NSString* value){
    if (name && value) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:createCookie(name, value)];
    }
}

void resetCookies()
{
    NSHTTPCookieStorage* cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie* obj in cookies) {
        if (![obj.name isEqual:@"DZVISIT"] && ![obj.name isEqual:@"fromapp"] && ![obj.name isEqual:@"uuid"]) {
            [cookieJar deleteCookie:obj];
        }
    }
}

void logCookies() {
    NSHTTPCookieStorage* cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie* obj in cookies) {
        BYLog(@"%@ - %@",obj.name,obj.value);
    }
}

UIImageView* makeSepline()
{
    UIImageView* line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_common"]];
    [line setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    return line;
}

UIImageView* makeImgView(CGRect frame, NSString* picName)
{
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = [[UIImage imageNamed:picName] resizableImage];
    return imgView;
}

void alertError(NSError* error)
{
    NSString* str = BYMSG_POOR_NETWORK;
    if (error && (error.userInfo[@"msg"] || error.userInfo[@"message"])) {
        str = error.userInfo[@"msg"] ? error.userInfo[@"msg"] : error.userInfo[@"message"];
    }

    [MBProgressHUD topShowTmpMessage:str];
}

void alertCommonError(NSError* error, NSString* defaultMessage)
{
    NSString* str = defaultMessage;
    if (error && (error.userInfo[@"msg"] || error.userInfo[@"message"])) {
        str = error.userInfo[@"msg"] ? error.userInfo[@"msg"] : error.userInfo[@"message"];
    }

    [MBProgressHUD topShowTmpMessage:str];
}

void alertPoolnetError()
{
    [MBProgressHUD topShowTmpMessage:BYMSG_POOR_NETWORK];
}

void alertPushSimplely(NSString* info)
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:info message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -

void runOnMainQueue(void (^block)(void))
{
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

void runOnBackgroundQueue(void (^block)(void))
{
    dispatch_async(dispatch_get_main_queue(), block);
}

void runBlockAfterDelay(float delaySeconds, void (^block)(void))
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delaySeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

void runBlockWithRetryTimes(NSUInteger retryTimes, CGFloat delayTime, BOOL (^block)())
{
    NSCAssert(block, @"block不能为空");

    if (retryTimes > 0) {
        BOOL hasDone = block();
        if (!hasDone) {
            runBlockAfterDelay(delayTime, ^{
                runBlockWithRetryTimes(retryTimes - 1,delayTime,  block);
            });
        }
    }
}
