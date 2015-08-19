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
#import "BYAppDelegate.h"

#import "WebViewJavascriptBridge.h"
#import "BYPoolNetworkView.h"

#import "WXApi.h"
#import "WXApiObject.h"

#import "BYCaptureController.h"

#import "BYLoginVC.h"
#import "BYMineVC.h"

#import <CFNetwork/CFHost.h>
#import <netinet/in.h>
#import <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import "BYHomeVC.h"
#import "BYBDmapVC.h"

@interface BYCommonWebVC () <UIWebViewDelegate>
@property (nonatomic, strong) WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) BYPoolNetworkView* poolNetworkView;
@property (nonatomic, assign) int loginCount;
@property (nonatomic, copy) NSString* currentUrl;
@property (nonatomic, strong) BYNavVC* mapNV;
@property (nonatomic, assign) BOOL loadingCaches;
@property (nonatomic, assign) BOOL loginSuccessLoading;
@property (nonatomic, strong) UIView * navBackview;
@end

@implementation BYCommonWebVC
+ (instancetype)sharedCommonWebVC
{
    static BYCommonWebVC* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
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
    [iConsole log:@"%@",preUrlString];
//    logCookies();
//    loggobackCookies();
//    if (_loadingCaches) {
//        [iConsole log:@"enter load caches"];
//        if (![preUrlString isEqualToString:@"about:blank"]) {
//            [iConsole log:@"enter load caches"];
//            return NO;
//        }
//        [iConsole log:@"load caches"];
//        [self.mutiSwitch setSelectedAtIndex:0];
//        self.showTabbar = YES;
//        return YES;
//    }
//    [iConsole log:@"mark1"];
    BOOL willShowTabbar = NO;
    //非biyao.com域直接放行
    if ([preUrlString rangeOfString:@"biyao.com"].length == 0) {
        self.showTabbar = willShowTabbar;
        _currentUrl = requestString;
        return YES;
    }
//    [iConsole log:@"mark2"];
    //对我们自己的地址进行分类处理
    if ([preUrlString rangeOfString:@"http://m.biyao.com/appindex"].length > 0
        || [preUrlString isEqualToString:@"http://m.biyao.com"]
        || [preUrlString isEqualToString:@"http://m.biyao.com/index"]) {
//        [self caches:preUrlString];
        [self.mutiSwitch setSelectedAtIndex:0];
        [self.navigationController popToRootViewControllerAnimated:NO];
        willShowTabbar = YES;
        return NO;
    }
    else if ([preUrlString rangeOfString:@"http://m.biyao.com/shopcar/list"].length > 0) {
        [self.mutiSwitch setSelectedAtIndex:1];
        willShowTabbar = YES;
    }
    else if ([preUrlString rangeOfString:@"http://m.biyao.com/account/mine"].length > 0) {
        [self.mutiSwitch setSelectedAtIndex:2];
        willShowTabbar = YES;
    }
//    [iConsole log:@"mark3"];
    //地图搜索-附近的验光点
    if ([preUrlString rangeOfString:@"/bdmap"].length > 0) {
        if (!_mapNV) {
            _mapNV = makeMapnav();
        }
     
        [self presentViewController:_mapNV animated:YES completion:nil];
        return NO;
    }
//    [iConsole log:@"mark4"];
    if ([preUrlString rangeOfString:@"account/mine"].length > 0) {
        

        __weak BYCommonWebVC * wself = self;
        
        if ([self.navigationController.viewControllers containsObject:[BYMineVC sharedMineVC]]) {
            [self.navigationController popToViewController:[BYMineVC sharedMineVC] animated:NO];
        }else{
            [self.navigationController pushViewController:[BYMineVC sharedMineVC] animated:NO];
        }
        return NO;
    }
//    logCookies();
    if ([preUrlString rangeOfString:@"account/login"].length > 0) {
        __weak BYCommonWebVC* bself = self; //本地化登录
        
        BYLoginSuccessBlock blk = ^() {
            runOnMainQueue(^{
            [[BYLoginVC sharedLoginVC] clearData];
            if (![bself.webView.request.URL.absoluteString rangeOfString:bself.currentUrl].length > 0) {
                bself.loginSuccessLoading = YES;
                [bself onAPPLogin];
                [bself.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:bself.currentUrl]]];
            }else{
                [MBProgressHUD topHide];
                [bself onAPPLogin];
                BYLoginVC* vc = [BYLoginVC sharedLoginVC];
                [vc.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            });
        };
        BYLoginCancelBlock cblk = ^(){
            if (bself.webView.request.URL.absoluteString.length == 0) {
                NSURL* url = [NSURL URLWithString:BYURL_HOME];
                [bself.webView loadRequest:[NSURLRequest requestWithURL:url]];
            }
            [[BYLoginVC sharedLoginVC] clearData];
        };
        BYNavVC* nav = makeLoginnav(blk,cblk);
        if ([preUrlString rangeOfString:@"home.biyao.com"].length > 0) {
            [BYLoginVC sharedLoginVC].showThirdPartyLogin = NO;
        }else{
            [BYLoginVC sharedLoginVC].showThirdPartyLogin = YES;
        }
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
//    [MBProgressHUD topHide];
    if (_loginSuccessLoading) {
        _loginSuccessLoading = NO;
        [MBProgressHUD topHide];
        BYLoginVC* vc = [BYLoginVC sharedLoginVC];
        [vc.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    if (_needShow) {
        _needShow = NO;
        [MBProgressHUD topHide];
        BYHomeVC* homeVC = ((BYAppDelegate*)[UIApplication sharedApplication].delegate).homeVC;
        if ([homeVC.navigationController.viewControllers containsObject:self]) {
            [homeVC.navigationController popToViewController:self animated:NO];
        }else{
            [homeVC.navigationController pushViewController:self animated:NO];
        }
    }
    if ([BYAppCenter sharedAppCenter].isNetConnected) {
        _poolNetworkView.hidden = YES;
        [MBProgressHUD topHide];
    }
    [iConsole log:@"finish"];

//    if ([self.currentUrl containsString:@"m.biyao.com/product/show"]&&![self.currentUrl containsString:@"192.168.97.69"]) {
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.97.69:8080/m.biyao.com/product/show?designid=63786"]]];
//    }
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
    [iConsole log:@"fail"];
    [MBProgressHUD topShowTmpMessage:@"网络异常，请检查您的网络"];
    if (_loginSuccessLoading) {
        _loginSuccessLoading = NO;
        [MBProgressHUD topHide];
        BYLoginVC* vc = [BYLoginVC sharedLoginVC];
        [vc.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    if (_needShow) {
        _needShow = NO;
    }
    if (![BYAppCenter sharedAppCenter].isNetConnected) {
        [MBProgressHUD topHide];
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
        
//        [self loadcaches];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAPPLogin) name:BYAppLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAPPLogout) name:BYAppLogoutNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI
{
//    _navBackview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height/2)];
//    [self.view addSubview:_navBackview];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    _navBackview.backgroundColor = BYColorNav;
    if (!_webView) {
        
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        statusBarHeight = 0;
        [_webView removeFromSuperview];
        _webView = [[BYWebView alloc] initWithFrame:BYRectMake(0, 0, self.view.width, self.view.height)];
        _webView.parentVC = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = BYColorClear;
        _webView.delegate = self;
        [self.view addSubview:_webView];

        _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView
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
        [_poolNetworkView removeFromSuperview];
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
        [_webView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).with.offset(statusBarHeight);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-self.mutiSwitch.height);
        }];

        _showTabbar = YES;

//        _webView = webView;

        //        UIButton *btn1 = [UIButton redButton];
        //        btn1.frame = BYRectMake(0, 200, 40, 40);
        //        [btn1 setTitle:@"photo" forState:UIControlStateNormal];
        //        [btn1 bk_addEventHandler:^(id sender) {
        //            [BYCaptureController sharedGlassesController].designId = 31020;
        //            [[BYCaptureController sharedGlassesController] goGlassWearingFromVC:self];
        //
        //        } forControlEvents:UIControlEventTouchUpInside];
        //        [self.view addSubview:btn1];
        self.view.backgroundColor = BYColorBG;
        _webView.clipsToBounds=NO;
    }
    _needShow = NO;
    _loginSuccessLoading = NO;
    _loginCount = 10;
}

- (BYMutiSwitch*)mutiSwitch
{
    if (!_mutiSwitch) {
        _mutiSwitch = [[BYMutiSwitch alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, 46)];
        _mutiSwitch.backView.image = [[UIImage imageNamed:@"bg_tabbar"] resizableImage];

        __weak BYCommonWebVC* wself = self;

        UIButton* btn1 = [BYBarButton barBtnWithIcon:@"icon_home" hlIcon:@"icon_home_highlight" title:@"首页"];
        [btn1 setTitleColor:BYColorb768 forState:UIControlStateHighlighted];
        [_mutiSwitch addButtonWithBtn:btn1
                               handle:^(id sender) {
                                   NSURL* url = [NSURL URLWithString:BYURL_HOME];
                                   [wself.webView loadRequest:[NSURLRequest requestWithURL:url]];
                               }];

        UIButton* btn2 = [BYBarButton barBtnWithIcon:@"icon_cart" hlIcon:@"icon_cart_highlight" title:@"购物车"];
        [btn2 setTitleColor:BYColorb768 forState:UIControlStateHighlighted];
        [_mutiSwitch addButtonWithBtn:btn2
                               handle:^(id sender) {
                                   NSURL* url = [NSURL URLWithString:BYURL_CARTLIST];
                                   [wself.webView loadRequest:[NSURLRequest requestWithURL:url]];
                               }];

        UIButton* btn3 = [BYBarButton barBtnWithIcon:@"icon_mine" hlIcon:@"icon_mine_highlight" title:@"我的必要"];
        [btn3 setTitleColor:BYColorb768 forState:UIControlStateHighlighted];
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
    statusBarHeight = 0;
    if (!_showTabbar && showTabbar) {
        self.mutiSwitch.hidden = NO;
//        _navBackview.backgroundColor = BYColorNav;
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.webView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).with.offset(statusBarHeight);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-self.mutiSwitch.height);
        }];
    }
    else if (_showTabbar && !showTabbar) {
        self.mutiSwitch.hidden = YES;
//        _navBackview.backgroundColor = BYColorBG;
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//        _webView.backgroundColor = [UIColor clearColor];
        [self.webView mas_updateConstraints:^(MASConstraintMaker* make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).with.offset(statusBarHeight);
            make.bottom.equalTo(self.view);
        }];
        
    }
    _showTabbar = showTabbar;
    [self.view setNeedsDisplayInRect:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    if (_showTabbar) {
//        return UIStatusBarStyleLightContent;
//    }else{
//        return UIStatusBarStyleDefault;
//    }
//    
//}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    NSString * preUrlString = self.webView.request.URL.absoluteString;
    BOOL willShowTabbar = NO;
    if (preUrlString.length == 0) {
        willShowTabbar = YES;
    }
    //非biyao.com域直接放行
    if ([preUrlString rangeOfString:@"biyao.com"].length == 0) {
        self.showTabbar = willShowTabbar;
        return;
    }
    
    //对我们自己的地址进行分类处理
    if ([preUrlString rangeOfString:@"http://m.biyao.com/appindex"].length > 0
        || [preUrlString isEqualToString:@"http://m.biyao.com"]
        || [preUrlString isEqualToString:@"http://m.biyao.com/index"]
        || [preUrlString isEqualToString:@"http://m.biyao.com/index/?f=ios&it=biyao"]) {
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

    UILabel* label = [UILabel labelWithFrame:BYRectMake(0, 30, btn.width, 24) font:Font(11) andTextColor:BYColor333];
    label.bottom = btn.height - 4;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.highlightedTextColor = BYColorb768;
    [btn addSubview:label];

    btn.iconView = icon;
    btn.sublabel = label;

    return btn;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _iconView.highlighted = selected;
    _sublabel.highlighted = selected;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    _iconView.highlighted = highlighted;
    _sublabel.highlighted = highlighted;
}

@end
void JumpToWebBlk(NSString*url,BYJumpWebFinish blk)
{
    if (![BYAppCenter sharedAppCenter].isNetConnected) {
        [MBProgressHUD topShowTmpMessage:@"网络异常，请检查您的网络"];
        return;
    }
    [BYCommonWebVC sharedCommonWebVC].needShow = YES;
    [MBProgressHUD topShow:@""];
    [[BYCommonWebVC sharedCommonWebVC].webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10]];
    [BYCommonWebVC sharedCommonWebVC].jumpCallBack = blk;
}