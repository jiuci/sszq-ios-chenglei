//
//  BYMonitor.m
//  IBY
//
//  Created by panshiyu on 14-10-15.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYMonitorService.h"
#import "BYSingleton.h"
#import "BYMonitorView.h"

@interface BYMonitorService () <iConsoleDelegate>
+ (instancetype)sharedBYMonitorService;
@end

@implementation BYMonitorService
+ (instancetype)sharedBYMonitorService
{
    static BYMonitorService* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)startMonitoring
{
#ifdef DEBUG
    [iConsole sharedConsole].delegate = [BYMonitorService sharedBYMonitorService];
#endif
}

- (void)handleConsoleCommand:(NSString*)command
{
    UIWindow* keywindow = [UIApplication sharedApplication].keyWindow;

    if ([command isEqualToString:@"h"]) {
        [iConsole hide];
        [iConsole clear];

        BYMonitorView* view = [[BYMonitorView alloc] initWithFrame:keywindow.bounds];
        [keywindow addSubview:view];
        return;
    }

    [iConsole error:@"少侠，密码不对，请重新来过"];
}

@end
