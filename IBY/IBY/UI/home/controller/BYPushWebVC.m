//
//  BYPushWebVC.m
//  IBY
//
//  Created by chenglei on 15/12/3.
//  Copyright © 2015年 com.biyao. All rights reserved.
//

#import "BYPushWebVC.h"

@interface BYPushWebVC ()

@property (nonatomic, strong) UIWebView *webView;


@end

@implementation BYPushWebVC

//+ (instancetype)sharedPushWebVC {
//    static BYPushWebVC *instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc] init];
//    });
//    return instance;
//}



- (void)viewDidLoad {
    [super viewDidLoad];

    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SSZQURL_BASE, SSZQURL_RANK]];
    if (_urlStr.length == 0 || !_urlStr) {
        _urlStr = [NSString stringWithFormat:@"%@%@", SSZQURL_BASE, SSZQURL_ERROR];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
}


@end
