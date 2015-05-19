//
//  BYCaifutongVC.m
//  IBY
//
//  Created by St on 14/11/28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYWebPayVC.h"
#import "BYPayCenter.h"

@implementation BYWebPayVC

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* requestString = [request.URL absoluteString];

    if ([BYPayCenter payCenter].preInfo.callBackUrl) {
        NSRange caifutongPaySuccessRang = [requestString rangeOfString:[BYPayCenter payCenter].preInfo.callBackUrl];
        if (caifutongPaySuccessRang.length > 0) {
            // 财付通网页支付或者支付宝网页支付成功
            // 调用服务器API，看支付是否成功
            if (self.webPayDelegate) {
                [self.navigationController popViewControllerAnimated:NO];
                [self.webPayDelegate didWebPayFinished];
            }
            return NO;
        }
    }
    return YES;
}

@end
