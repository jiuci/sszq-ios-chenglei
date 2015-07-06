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

#import "BYLoginVC.h"

#import <CFNetwork/CFHost.h>
#import <netinet/in.h>
#import <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface BYCommonWebVC () <UIWebViewDelegate>
@property (nonatomic, strong) WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) BYPoolNetworkView* poolNetworkView;
@property (nonatomic, assign) int loginCount;
@property (nonatomic, copy) NSString* currentUrl;
@end

@implementation BYCommonWebVC

#pragma mark - dns解析
- (NSString*)getAddressFromArray:(CFArrayRef)addresses
{
    struct sockaddr* addr;
    char ipAddress[INET6_ADDRSTRLEN];
    CFIndex index, count;
    int err;

    assert(addresses != NULL);

    count = CFArrayGetCount(addresses);
    for (index = 0; index < count; index++) {
        addr = (struct sockaddr*)CFDataGetBytePtr(CFArrayGetValueAtIndex(addresses, index));
        assert(addr != NULL);

        /* getnameinfo coverts an IPv4 or IPv6 address into a text string. */
        err = getnameinfo(addr, addr->sa_len, ipAddress, INET6_ADDRSTRLEN, NULL, 0, NI_NUMERICHOST);
        //        if (err == 0) {
        //            NSLog(@"解析到ip地址：%s\n", ipAddress);
        //        } else {
        //            NSLog(@"地址格式转换错误：%d\n", err);
        //        }
    }
    return [[NSString alloc] initWithFormat:@"%s", ipAddress]; //这里只返回最后一个，一般认为只有一个地址
}

- (bool)getReachability:(CFDataRef)data withNameOrAddress:(CFStringRef)nameOrAddress
{
    SCNetworkConnectionFlags* flags;
    CFIndex length;
    char* input;
    Boolean success;

    assert(data != NULL);
    assert(nameOrAddress != NULL);

    /* CFStringGetMaximumSizeForEncoding determines max bytes a string of specified length will take up if encoded. */
    length = CFStringGetMaximumSizeForEncoding(CFStringGetLength(nameOrAddress), kCFStringEncodingASCII);
    input = malloc(length + 1);
    assert(input != NULL);

    success = CFStringGetCString(nameOrAddress, input, length + 1, kCFStringEncodingASCII);
    assert(success);

    flags = (SCNetworkConnectionFlags*)CFDataGetBytePtr(data);
    assert(flags != NULL);

    /* If you only have a PPP interface enabled, the flags will be 0 because of a bug. <rdar://problem/3627771> */
    //    if (*flags == 0) NSLog(@"%s -> Reachability Unknown\n", input);
    //
    //    if (*flags & kSCNetworkFlagsTransientConnection)  NSLog(@"%s -> Transient Connection\n",  input);
    //    if (*flags & kSCNetworkFlagsReachable)           {
    //        NSLog(@"%s -> Reachable\n",             input);
    //        success = YES;
    //    }else {
    //        success = NO;
    //    }
    //    if (*flags & kSCNetworkFlagsConnectionRequired)   NSLog(@"%s -> Connection Required\n",   input);
    //    if (*flags & kSCNetworkFlagsConnectionAutomatic)  NSLog(@"%s -> Connection Automatic\n",  input);
    //    if (*flags & kSCNetworkFlagsInterventionRequired) NSLog(@"%s -> Intervention Required\n", input);
    //    if (*flags & kSCNetworkFlagsIsLocalAddress)       NSLog(@"%s -> Is Local Address\n",      input);
    //    if (*flags & kSCNetworkFlagsIsDirect)             NSLog(@"%s -> Is Direct\n",             input);
    //
    free(input);
    return success;
}

- (NSString*)serverResoluton
{

    NSMutableSet* whiteList = [NSMutableSet setWithObjects:
                                                @"118.144.72.198",
                                            nil]; //此处为白名单需要服务器协助维护，todo
    NSMutableSet* whiteListTest = [NSMutableSet setWithObjects:
                                                    @"118.144.72.200",
                                                @"192.168.99.60",
                                                @"192.168.99.231",
                                                nil]; //此处为白名单需要服务器协助维护，todo
    NSString* serverAddress = @"m.biyao.com";
    CFStringRef hostName = (__bridge CFStringRef)serverAddress;
    CFHostRef host;
    CFStreamError error;
    Boolean success;
    CFArrayRef addressArray;
    CFDataRef ReachableData;

    assert(hostName != NULL);

    /* Creates a new host object with the given name. */
    host = CFHostCreateWithName(kCFAllocatorDefault, hostName);
    assert(host != NULL);

    success = CFHostStartInfoResolution(host, kCFHostAddresses, &error);
    if (!success) { //此处表象应为网络连接失败，并不需要单独处理
        //        NSLog(@"CFHostStartInfoResolution 返回错误 (%ld, %d)", error.domain, (int)error.error);//如果解析地址失败，使用直接指定IP
        //        NSLog(@"启用直接指定IP：%@",@"118.144.72.198");
        //        serverAddress = @"118.144.72.198";
    }
    else {
        addressArray = CFHostGetAddressing(host, nil);
        serverAddress = [[NSString alloc] initWithFormat:@"%@", [self getAddressFromArray:addressArray]];
        if ([whiteListTest containsObject:serverAddress]) { //解析地址不在白名单中，给予警告
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"正在测试环境下运行" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
            return nil;
            //            NSLog(@"%@",serverAddress);
        }
        if (![whiteList containsObject:serverAddress]) { //解析地址不在白名单中，给予警告
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"检测到你即将访问的地址并非必要官方网站，建议检查您网络提供者的DNS设置" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
            //            NSLog(@"%@",serverAddress);
        }
    }
    return nil;
    //使用新地址来确认可连接性
    hostName = (__bridge CFStringRef)serverAddress;
    host = CFHostCreateWithName(kCFAllocatorDefault, hostName);
    success = CFHostStartInfoResolution(host, kCFHostReachability, &error);
    if (!success) {
        //        NSLog(@"CFHostStartInfoResolution 返回错误 (%ld, %d)", error.domain, (int)error.error);
        //暂不知到这里会在什么情况下发生
    }
    else {
        ReachableData = CFHostGetReachability(host, nil);
        success = [self getReachability:ReachableData withNameOrAddress:(CFStringRef)hostName];
        if (!success) {
            serverAddress = @"118.144.72.198"; //在这里添加备用服务器
        }
    }
    return serverAddress;
}
#pragma mark -

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{

    [BYAnalysis logEvent:@"App通用事件" action:@"url跳转" desc:nil];

    NSString* preUrlString = nil;
    NSString* requestString = [request.URL absoluteString];
    NSArray* urlPiece = [requestString componentsSeparatedByString:@"?"];
    if (urlPiece.count > 0) {
        preUrlString = urlPiece[0];
        if ([preUrlString hasSuffix:@"/"]) {
            preUrlString = [preUrlString substringToIndex:preUrlString.length - 1];
        }
    }
    if (!preUrlString) {
        return NO;
    }

    BOOL willShowTabbar = NO;
//    NSLog(@"requestString: %@",preUrlString);
    //非biyao.com域直接放行
    if ([preUrlString rangeOfString:@"biyao.com"].length == 0) {
        self.showTabbar = willShowTabbar;
        _currentUrl = requestString;
        return YES;
    }

    //对我们自己的地址进行分类处理
    if ([preUrlString rangeOfString:@"http://m.biyao.com/appindex"].length > 0
        || [preUrlString isEqualToString:@"http://m.biyao.com"]
        || [preUrlString isEqualToString:@"http://m.biyao.com/index"]) {
        [self.mutiSwitch setSelectedAtIndex:0];
        willShowTabbar = YES;
    }
    else if ([preUrlString rangeOfString:@"http://m.biyao.com/shopcar/list"].length > 0) {
        [self.mutiSwitch setSelectedAtIndex:1];
        willShowTabbar = YES;
    }
    else if ([preUrlString rangeOfString:@"http://m.biyao.com/account/mine"].length > 0) {
        [self.mutiSwitch setSelectedAtIndex:2];
        willShowTabbar = YES;
    }
    else if ([preUrlString rangeOfString:@"http://192.168.97.69:8080/"].length > 0){
        willShowTabbar = YES;
    }

    if ([preUrlString rangeOfString:@"login"].length > 0) {
//        NSLog(@"det login!");
        __weak BYCommonWebVC* bself = self; //本地化登录
        BYLoginSuccessBlock blk = ^() {
//            NSLog(@"login success");
//            NSLog(@"%@",bself.webView.request);
//            NSLog(@"%@",_currentUrl);
            if (![bself.webView.request.URL.absoluteString containsString:bself.currentUrl]) {
                [bself.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:bself.currentUrl]]];
            }else{
                [bself onAPPLogin];
//                NSLog(@"onapplogin");
            }
            
//            [bself dismissViewControllerAnimated:NO completion:nil];
//            [[BYAppCenter sharedAppCenter] updateUidAndToken];
//            [[BYAppCenter sharedAppCenter] uploadToken:nil];
            //TODO 发送消息给服务器已经登录
        };

        BYNavVC* nav = makeLoginnav(blk);
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
    }
    self.showTabbar = willShowTabbar;

    if (!([preUrlString rangeOfString:@"/order/pay2"].length > 0) && [preUrlString rangeOfString:@"/order/pay"].length > 0) {
        [[BYAppCenter sharedAppCenter] updateUidAndToken];
        NSDictionary* parameters = [[request.URL query] parseURLParams];
        [[BYPortalCenter sharedPortalCenter] portTo:BYPortalpay params:parameters];
        return NO;
    }
    _currentUrl = requestString;
//    NSLog(@"_currentUrl :%@",_currentUrl);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView*)webView
{
    if ([BYAppCenter sharedAppCenter].isNetConnected) {
        _poolNetworkView.hidden = YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    if ([BYAppCenter sharedAppCenter].isNetConnected) {
        _poolNetworkView.hidden = YES;
    }
//    if ([self.currentUrl containsString:@"m.biyao.com/product/show"]&&![self.currentUrl containsString:@"192.168.97.69"]) {
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.97.69:8080/m.biyao.com/product/show?designid=63786"]]];
//    }
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
    if (![BYAppCenter sharedAppCenter].isNetConnected) {
        _poolNetworkView.hidden = NO;
    }
}

#pragma mark - methods

- (void)onPoolNetwork
{
    NSString* willUrl = _currentUrl ? _currentUrl : BYURL_HOME;
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

- (void)onAppShake
{
    NSString* jsCallBack = [NSString stringWithFormat:@"appdidshake()"];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

- (void)onWeixinAuth:(NSString*)code
{
    NSString* jsCallBack = [NSString stringWithFormat:@"appdidwxauth('%@')", code];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

- (void)onSelectGlasses:(int)designId
{
    NSString* jsCallBack = [NSString stringWithFormat:@"appdidtryglasses('%d')", designId];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

#pragma mark -

- (id)init
{
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAPPLogin) name:BYAppLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAPPLogout) name:BYAppLogoutNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI
{
    if (!_webView) {
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;

        BYWebView* webView = [[BYWebView alloc] initWithFrame:BYRectMake(0, 0, self.view.width, self.view.height)];
        webView.parentVC = self;
        webView.scrollView.showsVerticalScrollIndicator = NO;
        webView.scalesPageToFit = YES;
        webView.backgroundColor = BYColorClear;
        webView.delegate = self;
        [self.view addSubview:webView];

        _bridge = [WebViewJavascriptBridge bridgeForWebView:webView
                                            webViewDelegate:self
                                                    handler:^(id data, WVJBResponseCallback responseCallback) {

                                                        if (![data isKindOfClass:[NSDictionary class]]) {
                                                            return;
                                                        }

                                                        BYH5Unit* unit = [BYH5Unit unitWithH5Info:data];

                                                        if (unit) {
                                                            [unit runFromVC:self];
                                                        }

                                                    }];

        _poolNetworkView = [BYPoolNetworkView poolNetworkView];
        [self.view addSubview:_poolNetworkView];
        UIButton* btn = [[UIButton alloc] initWithFrame:_poolNetworkView.frame];
        btn.backgroundColor = BYColorClear;
        [btn addTarget:self action:@selector(onPoolNetwork) forControlEvents:UIControlEventTouchUpInside];
        [_poolNetworkView addSubview:btn];
        _poolNetworkView.hidden = YES;
        _poolNetworkView.backgroundColor = BYColorBG;

        [self.view addSubview:self.mutiSwitch];

        [self.mutiSwitch mas_makeConstraints:^(MASConstraintMaker* make) {
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

        //        UIButton *btn1 = [UIButton redButton];
        //        btn1.frame = BYRectMake(0, 200, 40, 40);
        //        [btn1 setTitle:@"photo" forState:UIControlStateNormal];
        //        [btn1 bk_addEventHandler:^(id sender) {
        //            [BYCaptureController sharedGlassesController].designId = 31020;
        //            [[BYCaptureController sharedGlassesController] goGlassWearingFromVC:self];
        //
        //        } forControlEvents:UIControlEventTouchUpInside];
        //        [self.view addSubview:btn1];
    }
    _loginCount = 10;
}

- (BYMutiSwitch*)mutiSwitch
{
    if (!_mutiSwitch) {
        _mutiSwitch = [[BYMutiSwitch alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, 46)];
        _mutiSwitch.backView.image = [[UIImage imageNamed:@"bg_tabbar"] resizableImage];

        __weak BYCommonWebVC* wself = self;

        UIButton* btn1 = [BYBarButton barBtnWithIcon:@"icon_home" hlIcon:@"icon_home_highlight" title:@"主页"];
        [_mutiSwitch addButtonWithBtn:btn1
                               handle:^(id sender) {
                                   NSURL* url = [NSURL URLWithString:BYURL_HOME];
                                   [wself.webView loadRequest:[NSURLRequest requestWithURL:url]];
                               }];

        UIButton* btn2 = [BYBarButton barBtnWithIcon:@"icon_cart" hlIcon:@"icon_cart_highlight" title:@"购物车"];
        [_mutiSwitch addButtonWithBtn:btn2
                               handle:^(id sender) {
                                   NSURL* url = [NSURL URLWithString:BYURL_CARTLIST];
                                   [wself.webView loadRequest:[NSURLRequest requestWithURL:url]];
                               }];

        UIButton* btn3 = [BYBarButton barBtnWithIcon:@"icon_mine" hlIcon:@"icon_mine_highlight" title:@"我的必要"];
        [_mutiSwitch addButtonWithBtn:btn3
                               handle:^(id sender) {
                                   NSURL* url = [NSURL URLWithString:BYURL_MINE];
                                   [wself.webView loadRequest:[NSURLRequest requestWithURL:url]];
                               }];

        [self.view addSubview:_mutiSwitch];
    }
    return _mutiSwitch;
}

- (void)setShowTabbar:(BOOL)showTabbar
{

    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;

    if (!_showTabbar && showTabbar) {
        self.mutiSwitch.hidden = NO;

        [self.webView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).with.offset(statusBarHeight);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-self.mutiSwitch.height);
        }];
    }
    else if (_showTabbar && !showTabbar) {
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    NSString * preUrlString = self.webView.request.URL.absoluteString;
    BOOL willShowTabbar = NO;
    
    //非biyao.com域直接放行
    if ([preUrlString rangeOfString:@"biyao.com"].length == 0) {
        self.showTabbar = willShowTabbar;
        return;
    }
    
    //对我们自己的地址进行分类处理
    if ([preUrlString rangeOfString:@"http://m.biyao.com/appindex"].length > 0
        || [preUrlString isEqualToString:@"http://m.biyao.com"]
        || [preUrlString isEqualToString:@"http://m.biyao.com/index"]) {
        [self.mutiSwitch setSelectedAtIndex:0];
        willShowTabbar = YES;
    }
    else if ([preUrlString rangeOfString:@"http://m.biyao.com/shopcar/list"].length > 0) {
        [self.mutiSwitch setSelectedAtIndex:1];
        willShowTabbar = YES;
    }
    else if ([preUrlString rangeOfString:@"http://m.biyao.com/account/mine"].length > 0) {
        [self.mutiSwitch setSelectedAtIndex:2];
        willShowTabbar = YES;
    }
    self.showTabbar = willShowTabbar;
    //[self serverResoluton];
    
}

@end

@interface BYBarButton ()
@property (nonatomic, strong) UIImageView* iconView;
@property (nonatomic, strong) UILabel* sublabel;
@end

@implementation BYBarButton

+ (instancetype)barBtnWithIcon:(NSString*)normalIcon hlIcon:(NSString*)hlIcon title:(NSString*)title
{
    BYBarButton* btn = [[self alloc] init];
    btn.frame = BYRectMake(0, 0, SCREEN_WIDTH / 3, 46);

    UIImageView* icon = [[UIImageView alloc] initWithFrame:BYRectMake(0, 6, 16, 16)];
    icon.centerX = btn.width / 2;
    icon.image = [UIImage imageNamed:normalIcon];
    icon.highlightedImage = [UIImage imageNamed:hlIcon];
    [btn addSubview:icon];

    UILabel* label = [UILabel labelWithFrame:BYRectMake(0, 30, btn.width, 24) font:Font(12) andTextColor:BYColor333];
    label.bottom = btn.height - 4;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [btn addSubview:label];

    btn.iconView = icon;
    btn.sublabel = label;

    return btn;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _iconView.highlighted = selected;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    _iconView.highlighted = highlighted;
}

@end
