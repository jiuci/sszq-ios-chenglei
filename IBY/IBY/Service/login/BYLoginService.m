//
//  BYLoginService.m
//  IBY
//
//  Created by panshiyu on 15/6/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYLoginService.h"
#import "BYPassportEngine.h"
#import "BYUserEngine.h"
#import "BYShareConfig.h"
#import "BYLoginVC.h"
@implementation BYLoginService

- (void)loginByUser:(NSString*)user
                pwd:(NSString*)pwd
             finish:(void (^)(BYUser* user, BYError* error))finished {
    NSString* dzvisit = loadCookies(@"DZVISIT", @".biyao.com");
    
    [BYPassportEngine loginByUser:user pwd:pwd finish:^(BYUser *user, BYError *error) {
        if (user&&!error) {
            [[BYAppCenter sharedAppCenter] didLogin:user];
            finished(user,nil);
            NSString* orginDZVISIT = [BYAppCenter sharedAppCenter].visitCode;
            [BYAppCenter sharedAppCenter].visitCode = dzvisit;
            [BYUserEngine syncUserDataAfterLogin:^(BOOL isSuccess, BYError *error) {
                //无论结果如何，不处理，不显示
            }];
            [BYAppCenter sharedAppCenter].visitCode = orginDZVISIT;
            [[BYAppCenter sharedAppCenter] uploadToken:nil];
            
        }else{
            finished(user,error);
        }
    }];
}
- (void)QQlogin;
{
    [self QQgrantAuthorization];
}
- (void)QQgrantAuthorization{
    
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    BYShareConfig * config = [[BYShareConfig alloc]init];
    _oAuth = [[TencentOAuth alloc] initWithAppId:config.qqClientKey andDelegate:self];
    [_oAuth authorize:permissions inSafari:NO];
}

- (void)WXlogin;
{
    [self WXgrantAuthorization];
}
- (void)WXgrantAuthorization{
    SendAuthReq* req =[[SendAuthReq alloc ] init  ];
    req.scope = @"snsapi_userinfo" ;
    int random = arc4random();
    req.state = [NSString stringWithFormat:@"%d",random];
    [BYAppCenter sharedAppCenter].WXloginState = req.state;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)loginWithWXcode:(NSString*)code finish:(void (^)(BYUser* user, BYError* error))finished
{
//    NSLog( @"wx授权完成 %@",code);
    NSString* dzvisit = loadCookies(@"DZVISIT", @".biyao.com");
    [BYPassportEngine loginWithWXcode:code finish:^(BYUser *user, BYError *error) {
        if (user&&!error) {
            [[BYAppCenter sharedAppCenter] didLogin:user];
            finished(user,nil);
            
            
            NSString* orginDZVISIT = [BYAppCenter sharedAppCenter].visitCode;
            [BYAppCenter sharedAppCenter].visitCode = dzvisit;
            [BYUserEngine syncUserDataAfterLogin:^(BOOL isSuccess, BYError *error) {
                //无论结果如何，不处理，不显示
            }];
            [BYAppCenter sharedAppCenter].visitCode = orginDZVISIT;
            
            [[BYAppCenter sharedAppCenter] uploadToken:nil];
        }else{
            finished(user,error);
        }
    }];

}
- (BOOL)canUseWXlogin
{
    if (![WXApi isWXAppInstalled]) {
        return NO;
    }
    if (![WXApi isWXAppSupportApi]) {
        return NO;
    }
    return YES;
}

- (BOOL)canUseQQlogin
{
    if (![TencentOAuth iphoneQQInstalled])
    {
        return NO;
    }
    if (![TencentOAuth iphoneQQSupportSSOLogin])
    {
        return NO;
    }
    return YES;
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
- (void)tencentDidLogin
{
//    NSLog( @"QQ授权完成");
    
    NSString* dzvisit = loadCookies(@"DZVISIT", @".biyao.com");
    if (_oAuth.accessToken && 0 != [_oAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
//        NSLog(@"%@", _oAuth.accessToken);
//        NSLog(@"%@",_oAuth.openId);
        __weak BYLoginVC * loginVC = [BYLoginVC sharedLoginVC];
        [MBProgressHUD topShow:@"登录中..."];
        [BYPassportEngine loginWithQQaccess:_oAuth.accessToken openID:_oAuth.openId finish:^(BYUser* user, BYError* error) {
            [MBProgressHUD topHide];
//            NSLog(@"%@,%@",error,user);
            if (!error) {
//                NSLog(@"%@",user);
                [[BYAppCenter sharedAppCenter] didLogin:user];
                NSString* orginDZVISIT = [BYAppCenter sharedAppCenter].visitCode;
                [BYAppCenter sharedAppCenter].visitCode = dzvisit;
                [BYUserEngine syncUserDataAfterLogin:^(BOOL isSuccess, BYError *error) {
                    //无论结果如何，不处理，不显示
                }];
                [BYAppCenter sharedAppCenter].visitCode = orginDZVISIT;
                
                [[BYAppCenter sharedAppCenter] uploadToken:nil];
                
                if (loginVC.successBlk) {
//                    [MBProgressHUD topShow:@"登录成功!"];
                    
                    [loginVC.navigationController
                     dismissViewControllerAnimated:YES
                     completion:^{
                         loginVC.successBlk();
                     }];
                    
                }else{
//                    [MBProgressHUD showSuccess:@"登录成功!"];
                    
                    
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
    else
    {
//        NSLog(@"fail");
    }
}
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
//        NSLog(@"取消");
    }
    else
    {
//        NSLog(@"失败");
    }
}
-(void)tencentDidNotNetWork
{
    [MBProgressHUD topShowTmpMessage:@"无网络连接，请设置网络"];
}
@end
