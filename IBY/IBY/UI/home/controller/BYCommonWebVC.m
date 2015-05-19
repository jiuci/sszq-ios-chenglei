//
//  BYCommonWebVC.m
//  IBY
//
//  Created by panshiyu on 15/3/30.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYCommonWebVC.h"
#import "Masonry.h"
#import "BYMutiSwitch.h"

#import "WebViewJavascriptBridge.h"
#import "BYPoolNetworkView.h"

#import "WXApi.h"
#import "WXApiObject.h"

#import "BYCaptureController.h"

@interface BYCommonWebVC ()<UIWebViewDelegate>
@property (nonatomic, strong) WebViewJavascriptBridge* bridge;
@property (nonatomic,strong) BYPoolNetworkView* poolNetworkView;
@property (nonatomic,copy)NSString *currentUrl;
@end

@implementation BYCommonWebVC

#pragma mark -

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *preUrlString = nil;
    NSString* requestString = [request.URL absoluteString];
    NSArray *urlPiece = [requestString componentsSeparatedByString:@"?"];
    if (urlPiece.count > 0) {
        preUrlString = urlPiece[0];
        if ([preUrlString hasSuffix:@"/"]) {
            preUrlString = [preUrlString substringToIndex:preUrlString.length - 1];
        }
    }
    
    
    BYLog(@"%@",preUrlString);
    
    if (!preUrlString) {
        return NO;
    }
    
    BOOL willShowTabbar = NO;
    if ([preUrlString rangeOfString:@"biyao.com"].length > 0) {
        if ([preUrlString rangeOfString:@"http://m.biyao.com/appindex"].length > 0
            || [preUrlString isEqualToString:@"http://m.biyao.com"]
            || [preUrlString isEqualToString:@"http://m.biyao.com/index"]) {
            [self.mutiSwitch setSelectedAtIndex:0];
            willShowTabbar = YES;
        }else if ([requestString rangeOfString:@"http://m.biyao.com/shopcar/list"].length > 0) {
            [self.mutiSwitch setSelectedAtIndex:1];
            willShowTabbar = YES;
            
        }else if ([requestString rangeOfString:@"http://m.biyao.com/account/mine"].length > 0) {
            [self.mutiSwitch setSelectedAtIndex:2];
            willShowTabbar = YES;
        }
        
    }
    
    self.showTabbar = willShowTabbar;
    
    if (!([requestString rangeOfString:@"/order/pay2"].length > 0) &&[requestString rangeOfString:@"/order/pay"].length > 0 ){
        [[BYAppCenter sharedAppCenter] updateUidAndToken];
        NSDictionary* parameters = [[request.URL query] parseURLParams];
        [[BYPortalCenter sharedPortalCenter] portTo:BYPortalpay params:parameters];
        return NO;
    }
    
    _currentUrl = requestString;
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([BYAppCenter sharedAppCenter].isNetConnected) {
        _poolNetworkView.hidden = YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    if ([BYAppCenter sharedAppCenter].isNetConnected) {
        _poolNetworkView.hidden = YES;
    }
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
    if (![BYAppCenter sharedAppCenter].isNetConnected) {
        _poolNetworkView.hidden = NO;
    }
}

#pragma mark - methods

- (void)onPoolNetwork{
    NSString *willUrl = _currentUrl ? _currentUrl : BYURL_HOME;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:willUrl]]];
}

- (void)onAPPLogin
{
    NSString* jsCallBack = [NSString stringWithFormat:@"appdidlogin()"];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

- (void)onAPPLogout
{
    NSString* jsCallBack = [NSString stringWithFormat:@"appdidlogout()"];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

- (void)onAppShake{
    NSString* jsCallBack = [NSString stringWithFormat:@"appdidshake()"];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

- (void)onWeixinAuth:(NSString*)code{
    NSString * jsCallBack = [NSString stringWithFormat:@"appdidwxauth('%@')",code];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

- (void)onSelectGlasses:(int)designId{
    
    NSString * jsCallBack = [NSString stringWithFormat:@"appdidtryglasses('%d')",designId];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

#pragma mark -

- (id)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    if (!_webView) {
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        
        BYWebView* webView = [[BYWebView alloc] initWithFrame:BYRectMake(0, 0, self.view.width, self.view.height)];
        webView.parentVC = self;
        webView.scrollView.showsVerticalScrollIndicator = NO;
        webView.scalesPageToFit = YES;
        webView.backgroundColor = BYColorClear;
        webView.delegate = self;
        [self.view addSubview:webView];
        
        _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
            
            if (![data isKindOfClass:[NSDictionary class]]) {
                return ;
            }
            
            BYH5Unit *unit = [BYH5Unit unitWithH5Info:data];
            
            if (unit) {
                [unit runFromVC:self];
            }
            
        }];
        
        _poolNetworkView = [BYPoolNetworkView poolNetworkView];
        [self.view addSubview:_poolNetworkView];
        UIButton *btn = [[UIButton alloc] initWithFrame:_poolNetworkView.frame];
        btn.backgroundColor = BYColorClear;
        [btn addTarget:self action:@selector(onPoolNetwork) forControlEvents:UIControlEventTouchUpInside];
        [_poolNetworkView addSubview:btn];
        _poolNetworkView.hidden = YES;
        _poolNetworkView.backgroundColor = BYColorBG;

        
        [self.view addSubview:self.mutiSwitch];
        
        [self.mutiSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.equalTo(@46);
            make.bottom.equalTo(self.view);
        }];
        
        [webView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).with.offset(statusBarHeight);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-self.mutiSwitch.height);
        }];
        
        _showTabbar = YES;
        
        _webView = webView;
        
        
        UIButton *btn1 = [UIButton redButton];
        btn1.frame = BYRectMake(0, 200, 40, 40);
        [btn1 setTitle:@"photo" forState:UIControlStateNormal];
        [btn1 bk_addEventHandler:^(id sender) {
            [BYCaptureController sharedGlassesController].designId = 1;
            [[BYCaptureController sharedGlassesController] goGlassWearingFromVC:self];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn1];
    }
}

- (BYMutiSwitch*)mutiSwitch {
    if (!_mutiSwitch) {
        _mutiSwitch = [[BYMutiSwitch alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, 46)];
        _mutiSwitch.backView.image = [[UIImage imageNamed:@"bg_tabbar"] resizableImage];
        
        __weak BYCommonWebVC* wself = self;
        
        UIButton *btn1 = [BYBarButton barBtnWithIcon:@"icon_home" hlIcon:@"icon_home_highlight" title:@"主页"];
        [_mutiSwitch addButtonWithBtn:btn1 handle:^(id sender) {
            NSURL* url = [NSURL URLWithString:BYURL_HOME];
            [wself.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }];
        
        UIButton *btn2 = [BYBarButton barBtnWithIcon:@"icon_cart" hlIcon:@"icon_cart_highlight" title:@"购物车"];
        [_mutiSwitch addButtonWithBtn:btn2 handle:^(id sender) {
            NSURL* url = [NSURL URLWithString:BYURL_CARTLIST];
            [wself.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }];
        
        UIButton *btn3 = [BYBarButton barBtnWithIcon:@"icon_mine" hlIcon:@"icon_mine_highlight" title:@"我的必要"];
        [_mutiSwitch addButtonWithBtn:btn3 handle:^(id sender) {
            NSURL* url = [NSURL URLWithString:BYURL_MINE];
            [wself.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }];
        
        [self.view addSubview:_mutiSwitch];
        
    }
    return _mutiSwitch;
}

- (void)setShowTabbar:(BOOL)showTabbar {
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    if (!_showTabbar && showTabbar) {
        self.mutiSwitch.hidden = NO;
        
        [self.webView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).with.offset(statusBarHeight);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-self.mutiSwitch.height);
        }];
    }else if (_showTabbar && !showTabbar){
        self.mutiSwitch.hidden = YES;
        
        [self.webView mas_updateConstraints:^(MASConstraintMaker* make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).with.offset(statusBarHeight);
            make.bottom.equalTo(self.view);
        }];
        
    }
    
    _showTabbar = showTabbar;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


@end

@interface BYBarButton()
@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UILabel *sublabel;
@end

@implementation BYBarButton

+(instancetype)barBtnWithIcon:(NSString*)normalIcon hlIcon:(NSString*)hlIcon title:(NSString*)title{
    BYBarButton *btn = [[self alloc] init];
    btn.frame = BYRectMake(0, 0,SCREEN_WIDTH / 3 , 46);
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:BYRectMake(0, 6, 16, 16)];
    icon.centerX = btn.width/2;
    icon.image = [UIImage imageNamed:normalIcon];
    icon.highlightedImage = [UIImage imageNamed:hlIcon];
    [btn addSubview:icon];
    
    UILabel *label = [UILabel labelWithFrame:BYRectMake(0, 30, btn.width, 24) font:Font(12) andTextColor:BYColor333];
    label.bottom = btn.height - 4;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [btn addSubview:label];
    
    btn.iconView = icon;
    btn.sublabel = label;
    
    return btn;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _iconView.highlighted = selected;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    _iconView.highlighted = highlighted;
}

@end
