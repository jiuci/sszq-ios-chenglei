//
//  ZWZAnalysis.m
//  gannicus
//
//  Created by psy on 13-12-10.
//  Copyright (c) 2013年 bbk. All rights reserved.
//

#import "BYAnalysis.h"
#import "BYAnalysisConfig.h"
#import "BYNetwork.h"
#import "BYAppCenter.h"
#import "BYAppDelegate.h"

@implementation BYAnalysis

+ (void)startTracker
{
    //    [Flurry setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    //    [Flurry setCrashReportingEnabled:YES];
    //    [Flurry startSession:Flurry_ID];
    //    [Flurry logEvent:@"start" withParameters:@{@"time": [[NSDate date] description]}];
}

+ (void)logEvent:(NSString*)eventName
          action:(NSString*)action
            desc:(NSString*)desc
{
//    NSMutableDictionary* flurryDict = [NSMutableDictionary dictionary];
//    [flurryDict setValue:action forKey:@"action"];
//    [flurryDict setValue:desc forKey:@"desc"];
    //    [Flurry logEvent:eventName withParameters:flurryDict];

    [self saveCurrentEventTime];
}

+ (void)logPage:(NSString*)pageName withParameters:(NSDictionary*)parameters
{
    //    [Flurry logEvent:pageName withParameters:parameters];//弄个事件做备份
    //    [Flurry logPageView];

    [self logByType1:BYAnalysisTypePageVisit
               type2:nil
               type3:nil
                page:pageName
           extension:parameters];
    [self saveCurrentEventTime];
}

+ (void)logByType1:(BYAnalysisType)type1
             type2:(NSNumber*)type2
             type3:(NSNumber*)type3
              page:(NSString*)page
         extension:(NSDictionary*)extensions
{
    runOnBackgroundQueue(^{
        NSString* extensionStr = @"-";
        if (extensions && [extensions allValues]) {
            extensionStr = [[extensions allValues] componentsJoinedByString:@"|"];
        }
        
        BYAppCenter* app = [BYAppCenter sharedAppCenter];
        NSString* empty = @"-";
        
        NSMutableString* stat = [NSMutableString stringWithString:@""];
        [stat appendFormat:@"\"%d\" ", type1];
        [stat appendFormat:@"\"%@\" ", type2 ? type2 : empty];
        [stat appendFormat:@"\"%@\" ", type3 ? type3 : empty];
        
        [stat appendFormat:@"\"%@\" ", app.uuid];
        [stat appendFormat:@"\"%@\" ", app.user ? @(app.user.userID) : empty];
        [stat appendFormat:@"\"%@\" ", app.user ? app.user.token : empty];
        [stat appendFormat:@"\"%@\" ", app.sessionId];
        [stat appendFormat:@"\"%@\" ", page ? page : empty];
        [stat appendFormat:@"\"%@\" ", app.appName];
        [stat appendFormat:@"\"%@\" ", app.payPlatform];
        [stat appendFormat:@"\"%@\" ", app.appVersion];
        [stat appendFormat:@"\"%d\" ", app.numVersion];
        [stat appendFormat:@"\"%@\" ", app.platform];
        [stat appendFormat:@"\"%@\" ", app.deviceType];
        [stat appendFormat:@"\"%@\" ", app.systemVersion];
        [stat appendFormat:@"\"%@\" ", empty]; //浏览器
        [stat appendFormat:@"\"%@\" ", ((BYAppDelegate*)[UIApplication sharedApplication].delegate).activeVC]; //referer
        //TODO:referer字段会比较不好做，来源统计需要好好考虑下
        [stat appendFormat:@"\"%@\" ", [[NSDate date] dateStringWithFormat:BYDateFormatyyyyMMddHHmm]]; //客户端time
        [stat appendFormat:@"\"%@\" ", app.channel];
        [stat appendFormat:@"\"%@\" ", extensionStr];
        
        NSDictionary* params = @{
                                 @"log" : stat
                                 };
        NSLog(@"%@",stat);
        [BYNetwork postByBaseUrl:@"http://track.biyao.com/" suffix:@"" params:params finish:^(NSDictionary* data, NSError* error) {
            //暂时不关心是否传过去
            BYLog(@"");
        }];
        
        ((BYAppDelegate*)[UIApplication sharedApplication].delegate).activeVC = page;
    });
}

#pragma mark -

#define kLastEventTime @"kLastEventTime"
+ (NSNumber*)lastEventTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLastEventTime];
}

+ (void)saveCurrentEventTime
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@([[NSDate date] timeIntervalSince1970]) forKey:kLastEventTime];
    [userDefaults synchronize];
}

#pragma mark -

+ (void)postLogInfo:(NSDictionary*)info
{
}

@end
