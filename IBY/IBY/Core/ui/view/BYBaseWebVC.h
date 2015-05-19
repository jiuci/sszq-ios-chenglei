//
//  BYBaseWebVC.h
//  IBY
//
//  Created by panshiyu on 14-10-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"

@interface BYBaseWebVC : BYBaseVC <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) NSURL* url;
@property (nonatomic, weak) id /*<MTWebViewControllerDelegate*/ delegate;
@property (nonatomic, strong) UIActivityIndicatorView* indicatorView;

- (id)initWithURL:(NSURL*)url;
- (void)loadRequestWithURL:(NSURL*)url;

@end
