//
//  SinaWeiboEngine.m
//  SAKShareKit
//
//  Created by psy on 14-1-3.
//  Copyright (c) 2014年 psy. All rights reserved.
//

#import "SAKPipeSinaWeibo.h"

#import "WeiboSDK.h"

#define sinaRedirectURI @"http://m.biyao.com"

static NSString* kSinaWeiboUpdateStatus = @"https://api.weibo.com/2/statuses/update.json";
static NSString* kSinaWeiboUpdateStatusWithImage = @"https://api.weibo.com/2/statuses/upload_url_text.json";

@implementation SAKPipeSinaWeibo

- (id)init
{
    self = [super init];
    if (self) {
//        NSLog(@"%@",[WeiboSDK getSDKVersion]);
        [WeiboSDK enableDebugMode:YES];
        [WeiboSDK registerApp:[SAKShareConfig sharedInstance].sinaAppKey];
    }

    return self;
}

- (SAKShareMediaAvailability)isAvailable
{
    return SAKShareMediaAvailable;
}

- (void)handleOpenURL:(NSURL*)url didShare:(SAKDidShareBlock)finishBlock
{
    self.finishBlock = finishBlock;
    [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest*)request
{
}

- (void)didReceiveWeiboResponse:(WBBaseResponse*)response
{
    WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
    NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"sinaAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"");
}

- (void)share:(id<SAKSharerProcotol>)sharer from:(UIViewController*)fromVC willShare:(SAKWillShareBlock)willBlock didShare:(SAKDidShareBlock)finishBlock
{

    NSString* sinaAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"sinaAccessToken"];
    if (!sinaAccessToken || [sinaAccessToken isEqualToString:@""]) {
        sinaAccessToken = [SAKShareConfig sharedInstance].sinaAccessToken;
    }

    WBAuthorizeRequest* anthRequest = [WBAuthorizeRequest request];
    anthRequest.redirectURI = sinaRedirectURI;
    anthRequest.scope = @"all";

    WBMessageObject* megObject = [WBMessageObject message];
    megObject.text = [NSString stringWithFormat:@"%@ %@", [sharer content], [sharer detailURLString]];

    WBImageObject* imgObject = [WBImageObject object];
    imgObject.imageData = UIImageJPEGRepresentation([sharer thumbImage], 0.3);
    megObject.imageObject = imgObject;

    WBSendMessageToWeiboRequest* request = [WBSendMessageToWeiboRequest requestWithMessage:megObject authInfo:anthRequest access_token:sinaAccessToken];
    request.userInfo = @{ @"company" : @"biyao" };

    [WeiboSDK sendRequest:request];

    return;
}

@end
