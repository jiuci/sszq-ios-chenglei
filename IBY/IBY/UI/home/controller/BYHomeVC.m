//
//  BYHomeVC.m
//  IBY
//
//  Created by panShiyu on 14-9-10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYHomeVC.h"

#import "BYBaseWebVC.h"
#import "BYWebView.h"

#import "BYStatusBar.h"

@implementation BYHomeVC

- (void)viewDidLoad{
    [super viewDidLoad];
    _jumpURL = @"";
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)refreshUIIfNeeded {
    if (!self.webView) {
        return;
    }
    
    
    if([_jumpURL isEqualToString:@""]){
        NSURL* url = [NSURL URLWithString:BYURL_HOME];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }else{
        NSURL* url = [NSURL URLWithString:_jumpURL];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event
{
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        [self onAppShake];
    }
}



@end
