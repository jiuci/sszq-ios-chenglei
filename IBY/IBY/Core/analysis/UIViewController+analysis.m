//
//  UIViewController+analysis.m
//  gannicus
//
//  Created by psy on 13-12-11.
//  Copyright (c) 2013年 bbk. All rights reserved.
//

#import "UIViewController+analysis.h"
#import <objc/runtime.h>
#import "BYAnalysis.h"

@implementation UIViewController (analysis)

+ (void)load
{
    Method viewDidAppear = class_getInstanceMethod([UIViewController class], @selector(viewDidAppear:));
    Method trackPageViewDidAppear = class_getInstanceMethod([UIViewController class], @selector(trackPageViewDidAppear:));
    method_exchangeImplementations(viewDidAppear, trackPageViewDidAppear);
}

- (NSString*)pageName
{
    return [self.class description] ? [self.class description] : @"unknownPage";
}

- (NSMutableDictionary*)pageParameter
{
    return nil;
}

- (void)trackPageViewDidAppear:(BOOL)animation
{
    [self trackPageViewDidAppear:animation];

    NSString* pageName = self.pageName ? self.pageName : [self.class description];
    //屏蔽掉一些非主动的页面
    if ([pageName isEqualToString:@"BYNavVC"] || [pageName isEqualToString:@"BYTabBarVC"] || [pageName isEqualToString:@"UIInputWindowController"]) {
        return;
    }

    [BYAnalysis logPage:pageName withParameters:self.pageParameter];
}

@end
