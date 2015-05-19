//
//  QzoneEngine.m
//  SAKShareKit
//
//  Created by psy on 14-1-3.
//  Copyright (c) 2014年 psy. All rights reserved.
//

#import "SAKPipeQzone.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

static NSString* kQzoneShare = @"https://graph.qq.com/share/add_share";

@interface SAKPipeQzone () <TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth* tencentOAuth;

@end

@implementation SAKPipeQzone

- (id)init
{
    self = [super init];
    if (self) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:[SAKShareConfig sharedInstance].qqClientKey andDelegate:self];
        //[QQApi registerPluginWithId:[SAKShareConfig sharedInstance].qqClientKey];
    }

    return self;
}

- (SAKShareMediaAvailability)isAvailable
{
    if (![QQApi isQQInstalled]) {
        return SAKShareMediaNotAvailable; //没有安装QQ
    }
    if (![QQApi isQQSupportApi]) {
        return SAKShareMediaCanNotShare; //QQ api不支持
    }
    
    return SAKShareMediaAvailable;
}

- (void)share:(id<SAKSharerProcotol>)sharer from:(UIViewController*)fromVC willShare:(SAKWillShareBlock)willBlock didShare:(SAKDidShareBlock)finishBlock
{
    QQApiNewsObject* newObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[sharer detailURLString]]
                                                          title:[sharer title]
                                                    description:[sharer content]
                                                previewImageURL:[NSURL URLWithString:[sharer thumbURL]]];

    SendMessageToQQReq* sendReq = [SendMessageToQQReq reqWithContent:newObject];
    QQApiSendResultCode result = [QQApiInterface SendReqToQZone:sendReq];

    if (result == EQQAPISENDSUCESS) {
        finishBlock(nil);
        return;
    }
    else {
        NSError* aError = [NSError errorWithDomain:kSAKShareErrorDomain code:SAKOAuth2ErrorNetworkError userInfo:nil];
        finishBlock(aError);
    }
}

- (void)tencentDidLogin {}
- (void)tencentDidLogout {}
- (void)tencentDidNotLogin:(BOOL)cancelled {}
- (void)tencentDidNotNetWork {}

@end
