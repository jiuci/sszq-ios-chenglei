//
//  BYAppCenter.h
//  IBY
//
//  Created by coco on 14-9-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BYUser.h"
#import "BYLoginVC.h"

extern NSString* const BYAppLoginNotification;
extern NSString* const BYAppLogoutNotification;
extern NSString* const BYAppShakeNotification;
extern NSString* const BYAppWeixinAuthNotification;
extern NSString* const BYAppSessionInvalidNotification;


@interface BYAppCenter : NSObject

@property (nonatomic, strong, readonly) BYUser* user;
@property (nonatomic, copy) NSString* uuid;
@property (nonatomic, copy) NSString* appName; // app名称，如biyao
@property (nonatomic, copy) NSString* appVersion; //版本
@property (nonatomic, copy) NSString* platform; //所在平台，iOS、Android、WP
@property (nonatomic, copy) NSString* channel; //发布渠道，如 Appstore、小米商城
@property (nonatomic, copy) NSString* deviceType; //设备类型，如iPhone4s、小米4 等
@property (nonatomic, copy) NSString* systemVersion; //系统版本，如：ios7、android2.3
@property (nonatomic, assign) int numVersion; //version的num显示,用作版本对比
@property (nonatomic, copy) NSString* sessionId; //客户端自己维护的session信息
@property (nonatomic, copy) NSString* payPlatform; //mobile pc

@property (nonatomic, copy) NSString* visitCode; //用户没有登录时，服务端用来标识用户的id

@property (nonatomic, strong) NSDictionary* paramsMapForHeader;

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isNetConnected;
@property (nonatomic, copy) NSString* pushId;//用来统计push的参数
@property (nonatomic, copy) NSString* WXloginState;//用来统计push的参数

+ (instancetype)sharedAppCenter;

- (void)didLogin:(BYUser*)user;

- (void)setupConfiguration;
- (void)updateUidAndToken;
- (void)doUpgradeIfNeeded;
- (void)didActive;
- (void)logout;

- (void)invalidPushId;

- (void)checkVersionInfo;
- (void)checkNetworkStatus;
- (void)updateUserLatestStatus:(void (^)(BOOL isSuccess, BYError* error))finished;

- (void)uploadToken:(NSString*)token;
- (void)receivedPushInActive:(int)isactive;

- (void)runAfterLoginFromVC:(UIViewController*)vc withSuccessBlk:(BYLoginSuccessBlock)blk cancelBlk:(BYLoginCancelBlock)cblk;
- (void)runAfterLoginFromVC:(UIViewController*)vc withBlk:(BYLoginSuccessBlock)blk;

@end
