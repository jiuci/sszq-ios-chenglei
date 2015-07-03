//
//  BYBaseWebVC.m
//  IBY
//
//  Created by panshiyu on 14-10-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseWebVC.h"

@implementation BYBaseWebVC

- (void)dealloc
{
    _webView.delegate = nil;
}
- (id)initWithURL:(NSURL*)url
{
    self = [super init];
    if (self) {
        _url = url;
        _useWebTitle = NO;
    }
    return self;
}

- (void)loadView
{
    self.view = self.webView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadRequestWithURL:_url];
}

- (void)loadRequestWithURL:(NSURL*)url
{
    self.url = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (UIWebView*)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (UIActivityIndicatorView*)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = self.view.center;
        [self.view addSubview:_indicatorView];
    }

    return _indicatorView;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{

    BOOL shouldStart = YES;
    //    if ([_delegate respondsToSelector:@selector(webViewController:shouldLoadRequest:navigationType:)]) {
    //        shouldStart =  [_delegate webViewController:self shouldLoadRequest:request navigationType:navigationType];
    //    }
    if (shouldStart) {
        [self.indicatorView startAnimating];
    }

    return shouldStart;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    if (_useWebTitle) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    [self.indicatorView stopAnimating];
}

@end
