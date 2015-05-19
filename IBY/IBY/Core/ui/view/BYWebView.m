//
//  BYWebView.m
//  IBY
//
//  Created by panshiyu on 15/3/2.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYWebView.h"

#import "BYAlertView.h"
#import "BYSettingVC.h"
#import "BYNavVC.h"
#import "BYAppDelegate.h"
#import "BYHomeVC.h"

#import "BYCommonWebVC.h"

#import "BYShareCenter.h"

#import "WXApi.h"
#import "WXApiObject.h"

#import "BYCaptureController.h"

@interface BYWebView ()


@end

@implementation BYWebView

- (id)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    inputCookies();
}

@end

#pragma mark -

@implementation BYH5Unit;

+ (instancetype)unitWithH5Info:(NSDictionary*)info
{
    if (info[@"type"] && info[@"des"]) {
        return [[self alloc] initWithH5Info:info];
    }
    return nil;
}

- (id)initWithH5Info:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        _des = info[@"des"];
        _type = [info[@"type"] intValue];
        _h5Params = info[@"values"];
    }
    return self;
}

- (void)runFromVC:(UIViewController*)fromVC
{
    switch (_type) {
        case BYH5TypeHome: {
            [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome];
        } break;
        case BYH5TypeShare: {
            [[BYShareCenter shareCenter] shareFromWebBymedia:[_h5Params[@"platform"] intValue]
                                                       title:_h5Params[@"title"]
                                                     content:_h5Params[@"content"]
                                                      imgUrl:_h5Params[@"imageUrl"]
                                                         url:_h5Params[@"url"]
                                                       fromVC:fromVC];
        } break;
        case BYH5TypeSetting:{
            BYNavVC* nav = ((BYAppDelegate*)[UIApplication sharedApplication].delegate).homeNav;
            BYSettingVC* settingVC = [[BYSettingVC alloc]init];
            [nav pushViewController:settingVC animated:YES];
        }break;
        case BYH5TypeGoWeixinAuth:{
            if (![WXApi isWXAppInstalled]) {
                [MBProgressHUD topShowTmpMessage:@"此功能需要微信授权,请先安装微信"];
            }else{
                //构造SendAuthReq结构体
                SendAuthReq* req =[[SendAuthReq alloc ] init ];
                req.scope = @"snsapi_base,snsapi_userinfo" ;
                req.state = @"123" ;
                //第三方向微信终端发送一个SendAuthReq消息结构
                [WXApi sendReq:req];
            }
        }break;
        case BYH5TypeGlassWearing:{
            if (self.h5Params[@"designId"]) {
                [BYCaptureController sharedGlassesController].designId = [self.h5Params[@"designId"] intValue];
                BYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                BYHomeVC* homeVC = appDelegate.homeVC;
                [[BYCaptureController sharedGlassesController]goGlassWearingFromVC:homeVC];
            }

        }break;
        default:
            break;
    }
}

@end
