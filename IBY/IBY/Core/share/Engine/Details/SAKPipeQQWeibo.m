//
//  QQWeiboEngine.m
//  SAKShareKit
//
//  Created by psy on 14-1-3.
//  Copyright (c) 2014年 psy. All rights reserved.
//

#import "SAKPipeQQWeibo.h"

static NSString *kQQWeiboShare = @"https://open.t.qq.com/api/t/add_pic_url";

@implementation SAKPipeQQWeibo

- (void)share:(id<SAKSharerProcotol>)sharer from:(UIViewController *)fromVC willShare:(SAKWillShareBlock)willBlock didShare:(SAKDidShareBlock)finishBlock
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict safeSetValue:[SAKShareConfig sharedInstance].qqweiboAppKey forKey:@"oauth_consumer_key"];
    [paramDict safeSetValue:[SAKShareConfig sharedInstance].qqweiboAccessToken forKey:@"access_token"];
    [paramDict safeSetValue:[SAKShareConfig sharedInstance].qqweiboOpenID forKey:@"openid"];
    [paramDict safeSetValue:@"" forKey:@"clientip"];
    [paramDict setObject:@"2.a" forKey:@"oauth_version"];
    [paramDict setObject:@"json" forKey:@"format"];
    
    [paramDict safeSetValue:[sharer thumbURL] forKey:@"pic_url"];
    [paramDict safeSetValue:[sharer content] forKey:@"content"];
    
    [self postPath:kQQWeiboShare params:paramDict finish:^(NSDictionary *result, NSError *error) {
        if (error) {
            finishBlock(error);
            return;
        }
        
        if (result && result[@"ret"] && [result[@"ret"] intValue] == 0) {
            finishBlock(nil);
            return;
        }
        
        NSError *aError = [NSError errorWithDomain:kSAKShareErrorDomain code:SAKOAuth2ErrorNetworkError userInfo:nil];
        finishBlock(aError);
    }];
}

@end
