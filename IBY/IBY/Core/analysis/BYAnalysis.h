//
//  ZWZAnalysis.h
//  gannicus
//
//  Created by psy on 13-12-10.
//  Copyright (c) 2013年 bbk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYAnalysis : NSObject

+ (void)startTracker;

//通用事件记录
+ (void)logEvent:(NSString*)eventName
          action:(NSString*)action
            desc:(NSString*)desc;

//页面记录
+ (void)logPage:(NSString*)pageName withParameters:(NSDictionary*)parameters;

+ (NSNumber*)lastEventTime;

@end
