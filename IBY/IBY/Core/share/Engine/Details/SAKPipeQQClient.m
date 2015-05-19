//
//  QQClientEngine.m
//  SAKShareKit
//
//  Created by psy on 14-1-2.
//  Copyright (c) 2014年 psy. All rights reserved.
//

#import "SAKPipeQQClient.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface SAKPipeQQClient () <TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth* tencentOAuth;

@end

@implementation SAKPipeQQClient

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

- (void)handleOpenURL:(NSURL*)url didShare:(SAKDidShareBlock)finishBlock
{
    QQApiMessage* message = [QQApi handleOpenURL:url];
    if (!message) {
        return;
    }
    switch (message.type) {
    case QQApiMessageTypeSendMessageToQQResponse: {
        QQApiResultObject* resultObject = (QQApiResultObject*)message.object;
        NSString* error = resultObject.error;

        if ([error isEqualToString:@"0"]) {
            finishBlock(nil);
        }
        else {
            NSString* errorString = resultObject.errorDescription ? [resultObject.errorDescription copy] : @"unknown error";
            NSError* error = [NSError errorWithDomain:kSAKShareErrorDomain
                                                 code:SAKShareErrorUnknown
                                             userInfo:[NSDictionary dictionaryWithObject:errorString
                                                                                  forKey:NSLocalizedDescriptionKey]];
            finishBlock(error);
        }
    } break;

    default:
        break;
    }
}

- (void)share:(id<SAKSharerProcotol>)sharer from:(UIViewController*)fromVC willShare:(SAKWillShareBlock)willBlock didShare:(SAKDidShareBlock)finishBlock
{
    QQApiNewsObject* sendObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[sharer detailURLString]]
                                                        title:[sharer title]
                                                  description:[sharer content]
                                              previewImageURL:[NSURL URLWithString:[sharer thumbURL]]];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:sendObj];
    QQApiSendResultCode result = [QQApiInterface sendReq:req];
    if (result != EQQAPISENDSUCESS) {
        NSError* error = [NSError errorWithDomain:kSAKShareErrorDomain code:SAKShareErrorUnknown userInfo:nil];
        finishBlock(error);
    }
}

- (void)tencentDidLogin {}
- (void)tencentDidLogout {}
- (void)tencentDidNotNetWork {}
- (void)tencentDidNotLogin:(BOOL)cancelled {}

@end
