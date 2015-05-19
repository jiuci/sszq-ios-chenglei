//
//  WeixinEngine.m
//  SAKShareKit
//
//  Created by psy on 14-1-2.
//  Copyright (c) 2014年 psy. All rights reserved.
//

#import "SAKPipeWeixin.h"

@implementation SAKPipeWeixin

- (id)init
{
    self = [super init];
    if (self) {
        [WXApi registerApp:[SAKShareConfig sharedInstance].weixinClientKey];
    }
    return self;
}

- (SAKShareMediaAvailability)isAvailable
{
    if (![WXApi isWXAppInstalled]) {
        return SAKShareMediaNotAvailable; //没有安装微信
    }
    if (![WXApi isWXAppSupportApi]) {
        return SAKShareMediaCanNotShare; //微信api不支持
    }

    return SAKShareMediaAvailable;
}

- (void)handleOpenURL:(NSURL*)url didShare:(SAKDidShareBlock)finishBlock
{
    self.finishBlock = finishBlock;
    [WXApi handleOpenURL:url delegate:self];
}

- (void)onReq:(BaseReq*)req
{
    _isOpenFromWeixin = YES;
}

- (void)onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        [self onShareResp:resp];
    }
    //支付跳转直接在appdelegate里面就处理了
//    else if ([resp isKindOfClass:[PayResp class]]) {
//        [self onPayResp:resp];
//    }
    
    _gotResponse = YES;
}

- (void)onShareResp:(BaseResp*)resp
{
    if (resp.errCode == 0) {
        //分享成功
        if (self.finishBlock) {
            self.finishBlock(nil);
        }
    }
    else if (resp.errCode == WXErrCodeUserCancel) {
        //用户取消后不显示任何提示
    }
    else {
        //分享失败
        if (self.finishBlock) {
            NSString* errorString = resp.errStr ? [resp.errStr copy] : @"unknown error";
            NSError* error = [NSError errorWithDomain:kSAKShareErrorDomain
                                                 code:SAKShareErrorUnknown
                                             userInfo:[NSDictionary dictionaryWithObject:errorString
                                                                                  forKey:NSLocalizedDescriptionKey]];
            self.finishBlock(error);
        }
    }
}

- (void)share:(id<SAKSharerProcotol>)sharer from:(UIViewController*)fromVC willShare:(SAKWillShareBlock)willBlock didShare:(SAKDidShareBlock)finishBlock
{
    if (![sharer thumbImage]) {
        return;
    }

    _gotResponse = NO;

    //木有url，就发text
    if (![sharer detailURLString]) {
        if (_isOpenFromWeixin) {
            _isOpenFromWeixin = NO;
            GetMessageFromWXResp* req = [[GetMessageFromWXResp alloc] init];
            req.bText = YES;
            req.text = [sharer content];
            [WXApi sendResp:req];
        }
        else {
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = YES;
            req.text = [sharer content];
            req.scene = WXSceneSession;
            if (![WXApi sendReq:req]) {
                NSError* error = [NSError errorWithDomain:kSAKShareErrorDomain code:SAKShareErrorUnknown userInfo:nil];
                finishBlock(error);
            }
        }
        return;
    }

    WXMediaMessage* message = [WXMediaMessage message];

    message.title = [sharer title];
    message.description = [sharer content];

    [message setThumbImage:[sharer thumbImage]];

    WXWebpageObject* ext = [WXWebpageObject object];
    ext.webpageUrl = [sharer detailURLString];
    message.mediaObject = ext;

    if (_isOpenFromWeixin) {
        _isOpenFromWeixin = NO;
        GetMessageFromWXResp* req = [[GetMessageFromWXResp alloc] init];
        req.bText = NO;
        req.message = message;
        [WXApi sendResp:req];
    }
    else {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        if (![WXApi sendReq:req]) {
            NSError* error = [NSError errorWithDomain:kSAKShareErrorDomain code:SAKShareErrorUnknown userInfo:nil];
            finishBlock(error);
        }
    }
}

@end
