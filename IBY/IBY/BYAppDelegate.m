//
//  BYAppDelegate.m
//  IBY
//
//  Created by pan Shiyu on 14-8-26.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYAppDelegate.h"
#import "BYAppCenter.h"
#import "BYMonitorService.h"

#import "SAKShareConfig.h"
#import "SAKShareEngine.h"
#import "BYShareConfig.h"

#import "BYPayCenter.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "BYPushCenter.h"
#import "BYWelcomeVC.h"
#import "BYNavVC.h"
#import "BYHomeVC.h"
#import "BYLoginVC.h"
#import "BYLoginService.h"

#import <CoreLocation/CoreLocation.h>

#import <BaiduMapAPI/BMapKit.h>

@interface BYAppDelegate () <WXApiDelegate, WeiboSDKDelegate,TencentSessionDelegate>

@property (nonatomic, strong) BYWelcomeVC* welcomeVC;

@end

@implementation BYAppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    _window = [[iConsoleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //支持摇一摇
    
    
    application.applicationSupportsShakeToEdit = YES;

//    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[BYAppCenter sharedAppCenter] setupConfiguration];
    [[BYAppCenter sharedAppCenter] doUpgradeIfNeeded];

    [BYAnalysis logEvent:@"App通用事件" action:@"启动" desc:nil];
    
    [self registerShareSdk];
    [WXApi registerApp:@"wxa0286879d34677b0"];

    _homeVC = [[BYHomeVC alloc] init];
    
//    NSURL* url = [NSURL URLWithString:BYURL_HOME];
//    [_homeVC.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
//    NSLog(@"%@",_homeVC.webView);
    _homeNav = [BYNavVC nav:_homeVC title:@""];
    _window.rootViewController = _homeNav;
    [_window makeKeyAndVisible];

    [self showWelcomeVC];

    //    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
    //        // iOS 8 Notifications
    //        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)categories:nil]];
    //        [application registerForRemoteNotifications];
    //    }
    //    else {
    //        // iOS < 8 Notifications
    //        [application registerForRemoteNotificationTypes:
    //                         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    //    }

    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // iOS 8 Notifications
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                                               (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    [BYMonitorService startMonitoring];
    CLLocationManager* location = [CLLocationManager new];
    if ([location respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [location requestWhenInUseAuthorization];
    }
    
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"com.biyao.push.token"]);
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    if (IS_OS_8_OR_LATER) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }
    
    return YES;
}

- (void)showWelcomeVC
{
    //            [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //            _welcomeVC = [[BYWelcomeVC alloc] init];
    //            [self.window addSubview:_welcomeVC.view];
    //            [_welcomeVC setTutorialDone:^{
    //                [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //            }];
    //
    //            return;

    NSString* kHasShowWelcome = @"kHasShowWelcome";
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:kHasShowWelcome];
    if (!dict) {
        dict = [NSDictionary dictionary];
    }
    BOOL hasShow = [dict[[BYAppCenter sharedAppCenter].appVersion] boolValue];
//    hasShow = NO;
    if (!hasShow) {
        hasShow = YES;
        NSMutableDictionary* mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
        mdict[[BYAppCenter sharedAppCenter].appVersion] = @(YES);
        [[NSUserDefaults standardUserDefaults] setObject:mdict forKey:kHasShowWelcome];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        _welcomeVC = [[BYWelcomeVC alloc] init];
        [self.window addSubview:_welcomeVC.view];
        [_welcomeVC setTutorialDone:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }];
    }
}

- (void)registerShareSdk
{
    SAKShareConfig* config = [[BYShareConfig alloc] init];
    [SAKShareEngine enableShareWithConfig:config];
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    [BMKMapView willBackGround];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) ¬or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    
    [BYAnalysis logEvent:@"App通用事件" action:@"进入后台" desc:nil];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[BYAppCenter sharedAppCenter] didActive];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    [BYAnalysis logEvent:@"App通用事件" action:@"进入前台" desc:nil];
    
    [[BYAppCenter sharedAppCenter] checkVersionInfo];
    [BMKMapView didForeGround];
    //可以手动设置cookies
    [_homeVC reloadData];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[BYPushCenter sharedPushCenter] handleRemoteInfoWithApplication:application userinfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    //[MBProgressHUD topShowTmpMessage:userInfo[@"aps"][@"alert"]];

    //    // 记录远程通知和回调，在数据加载完成之后需要这些信息
    //    self.userInfo = userInfo;
    //    self.completionHandler = completionHandler;
    //
    //    // 如果是Silent Push则上报给服务器。
    //    if ([SAKRemotePushUtil isSilentPush:userInfo]) {
    //        [SAKRemotePushUtil reportPush:userInfo];
    //    }
    //
    //    [self handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* token = [NSString stringWithFormat:@"%@", deviceToken];
//    NSLog(@"%@",token);
    [iConsole log:@"设备token:%@",token];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"com.biyao.push.token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[BYAppCenter sharedAppCenter] uploadToken:token];
    
    //[MBProgressHUD topShowTmpMessage:token];

    //    [SAKEnvironment environment].pushToken = token;
    //
    //    // 需要把pushToken保存起来，因为在Silent Push的回执接口中需要用到
    //    [SAKRemotePushUtil savePushToken:token];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    NSLog(@"fail!!!－%@", error);
}

#pragma mark -share

- (void)didReceiveWeiboRequest:(WBBaseRequest*)request
{
}

- (void)didReceiveWeiboResponse:(WBBaseResponse*)response
{
    return;
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{

    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication
           annotation:(id)annotation
{
    if ([SAKShareEngine isCapableOfURL:url]) {
        [SAKShareEngine handleOpenURL:url didShare:^(NSError* error){

        }];
    }
    
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary* resultDic) {
            BYLog(@"result = %@",resultDic);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                [[BYPayCenter payCenter] preCheckPayStatus];
            }

            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPayResult" object:nil userInfo:@{ @"errCode" : @(resp.errCode) }];
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]) { //支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary* resultDic) {
            BYLog(@"result = %@",resultDic);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                [[BYPayCenter payCenter] preCheckPayStatus];
            }
        }];
    }

    //微信支付 和 微信授权
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }

    //新浪微博分享
    //    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
    //        [WeiboSDK handleOpenURL:url delegate:self];
    //    }
    
    //腾讯登录
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Where from" message:url.description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        //[alertView show];
        return [TencentOAuth HandleOpenURL:url];
    }
    return NO;
}

- (void)onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        //        NSString* strTitle = [NSString stringWithFormat:@"支付结果"];
        NSString* strMsg = [NSString stringWithFormat:@""];
        switch (resp.errCode) {
        case WXSuccess: {
            strMsg = @"支付成功";
             [[BYPayCenter payCenter] preCheckPayStatus];

        } break;
        case -1:
            strMsg = resp.errStr;
            break;
        case -2:
            strMsg = @"取消支付";
            break;
        default:
            break;
        }
        BYLog(@"---pay back %@",strMsg);
//        [iConsole log:@"---pay back %@",strMsg];
    }else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode==0) {
            SendAuthResp *rp = (SendAuthResp *)resp;
            __weak BYLoginVC * loginVC = [BYLoginVC sharedLoginVC];
            if ([rp.state isEqualToString: [BYAppCenter sharedAppCenter].WXloginState]) {
                //授权第三方登录
                if (rp.code) {
                    [MBProgressHUD topShow:@"登录中..."];
                    BYLoginService * loginService = [[BYLoginService alloc]init];
                    [loginService loginWithWXcode:rp.code finish:^(BYUser* user, BYError* error) {
                        [MBProgressHUD topHide];
                        if (!error) {
//                            NSLog(@"%@",user);
                            if (loginVC.successBlk) {
                                loginVC.successBlk();
                                
                            }else{
                                [loginVC.navigationController
                                 dismissViewControllerAnimated:YES
                                 completion:^{
                                 
                             }];
                            }
                        }else{
                            alertError(error);
                        }
                    }];
                }
                else if (rp.code) {
                [self.homeVC.commonWebVC onWeixinAuth:rp.code];
            }
            
//            BYLog(@"用户同意%@",rp.code);
        }else if(resp.errCode==-4){
            BYLog(@"用户拒绝授权");
            
        }else if (resp.errCode==-2){
            BYLog(@"用户取消");
            }
        }
    }
}
- (BOOL)onTencentReq:(TencentApiReq *)req
{
//    NSLog(@"req %@",req);
    
    return YES;
}
- (BOOL)onTencentResp:(TencentApiResp *)resp
{
//    NSLog(@"resp %@",resp);
    return YES;
}

@end

