//
//  WeixinFriendsEngine.m
//  SAKShareKit
//
//  Created by psy on 14-1-2.
//  Copyright (c) 2014年 psy. All rights reserved.
//

#import "SAKPipeWeixinFriends.h"

@implementation SAKPipeWeixinFriends

- (void)share:(id<SAKSharerProcotol>)sharer from:(UIViewController*)fromVC willShare:(SAKWillShareBlock)willBlock didShare:(SAKDidShareBlock)finishBlock
{
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
            req.scene = WXSceneTimeline;
            if (![WXApi sendReq:req]) {
                NSError* error = [NSError errorWithDomain:kSAKShareErrorDomain code:SAKShareErrorUnknown userInfo:nil];
                finishBlock(error);
            }
        }
        return;
    }

    WXMediaMessage* message = [WXMediaMessage message];

    message.title = [sharer content];
    message.description = @"";

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
        req.scene = WXSceneTimeline;
        if (![WXApi sendReq:req]) {
            NSError* error = [NSError errorWithDomain:kSAKShareErrorDomain code:SAKShareErrorUnknown userInfo:nil];
            finishBlock(error);
        }
    }
}

@end
