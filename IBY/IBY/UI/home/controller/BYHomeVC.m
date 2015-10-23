  
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

#import "BYMineVC.h"
#import "BYHomeService.h"

#import "BYHomeInfo.h"
#import "BYHomeInfoSimple.h"
#import "BYHomeFloorInfo.h"

#import "MJRefresh.h"

#import "BYLinearScrollView.h"
#import "BYImageView.h"
#import "MJRefreshHeaderView.h"

#import "SDCycleScrollView.h"
#import "BYPoolNetworkView.h"

#import "BYIMViewController.h"

#import "BYThemeVC.h"

#import "RESideMenu.h"

#import "BYLeftMenuViewController.h"
#import "BYAppDelegate.h"
@interface BYHomeVC ()<SDCycleScrollViewDelegate,BYImageViewTapDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) BYHomeService * service;
@property (nonatomic, strong) BYHomeInfo * info;
@property (nonatomic, strong) BYLinearScrollView * bodyView;
@property (nonatomic, strong) UIImageView* hasNewMessage;
@property (nonatomic, strong) BYPoolNetworkView* poolNetworkView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, weak) BYLeftMenuViewController * leftViewController;

@end
@implementation BYHomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.view addSubview:self.mutiSwitch];
    self.commonWebVC = [BYCommonWebVC sharedCommonWebVC];
    [self.mutiSwitch mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@46);
        make.bottom.equalTo(self.view);
    }];
    _service = [[BYHomeService alloc]init];
    _bodyView = [[BYLinearScrollView alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, self.view.height - 20 - 46 - 46)];
    _bodyView.backgroundColor = BYColorBG;
    [self.view addSubview:_bodyView];
    self.bodyView.alwaysBounceVertical = YES;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImgName:@"btn_index_menu" highImgName:@"btn_index_menu" target:self action:@selector(leftNav)];
  
    [self.navigationItem setTitle:@"必要商城"];
    _hasNewMessage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
    
    _hasNewMessage.image = [UIImage imageNamed:@"bg_messages_hasmessage"];
    [self.navigationItem.rightBarButtonItem.customView addSubview:_hasNewMessage];
    _hasNewMessage.right = _hasNewMessage.superview.width + 5;
    _hasNewMessage.bottom = _hasNewMessage.superview.height / 2 - 4;
    
    _hasNewMessage.hidden = YES;
    __weak BYHomeVC * wself = self;
    [self.bodyView addHeaderWithCallback:^{
        [wself reloadData];
    }];
    for (UIView* view in self.bodyView.subviews) {
        if (![view.class isSubclassOfClass:[MJRefreshHeaderView class]]) {
            continue;
        }
        ((MJRefreshHeaderView*)view).showTimeLabel = NO;
    }
    
    
    
    [_poolNetworkView removeFromSuperview];
    _poolNetworkView = [BYPoolNetworkView poolNetworkView];
    [self.view addSubview:_poolNetworkView];
    UIButton* btn = [[UIButton alloc] initWithFrame:_poolNetworkView.frame];
    btn.backgroundColor = BYColorClear;
    [btn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    [_poolNetworkView addSubview:btn];
    _poolNetworkView.hidden = YES;
    _poolNetworkView.backgroundColor = BYColorBG;
    
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    _info = [BYHomeInfo loadInfo];
    self.leftViewController.info = _info;
    if (_info) {
        [self updateUI];
    }
    [self reloadData];

    
  
}


-(void)updateUI
{
    if (!_info) {
        return;
    }
    self.isLoading = YES;
    _hasNewMessage.hidden = YES;
//    BYUser * user = [BYAppCenter sharedAppCenter].user; 
//    _hasNewMessage.hidden = user.messageNum == 0;
    [_bodyView by_removeAllSubviews];
    __weak BYHomeVC * wself = self;
    [_bodyView addHeaderWithCallback:^{
        [wself reloadData];
    }];
    if (_info.bannerArray.count == 1) {
        BYImageView * image = [[BYImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH/ (float)_info.bannerWidth*_info.bannerHeight)];
        BYHomeInfoSimple * simple = _info.bannerArray[0];
        image.jumpURL = simple.link;
        image.categoryId = simple.categoryID;
        image.tapDelegate = self;
        image.tag = simple.categoryID;
        image.image = [UIImage imageNamed:@"bg_placeholder"];
        [image setImageWithUrl:simple.imagePath placeholderName:@"bg_placeholder"];
        [image addTapAction:@selector(onImagetap:) target:image];
        [_bodyView by_addSubview:image paddingTop:0];
    }else if (_info.bannerArray.count > 1){
        NSMutableArray *imagesURL = [NSMutableArray array];
        for (int i =0; i<_info.bannerArray.count; i++) {
            BYHomeInfoSimple *simpe = _info.bannerArray[i];
            [imagesURL addObject:[NSURL URLWithString:simpe.imagePath]];
        }
        if (_cycleScrollView) {
            _cycleScrollView.imageURLsGroup = imagesURL;
        }
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH/ (float)_info.bannerWidth*_info.bannerHeight) imageURLsGroup:imagesURL placeHolderImage:[UIImage imageNamed:@"bg_placeholder"]];
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 3.0;
        _cycleScrollView.backgroundColor = HEXCOLOR(0xfcfcfc);
        [_bodyView by_addSubview:_cycleScrollView paddingTop:0];
    }
    
    
    for (int i = 0; i < _info.floorArray.count; i++) {
        BYHomeFloorInfo *floorInfo = _info.floorArray[i];
        if (floorInfo.title.length) {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28)];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = BYColorNav;
            titleLabel.font = Font(18);
            titleLabel.text = floorInfo.title;
            [_bodyView by_addSubview:titleLabel paddingTop:16];
        }
        if (floorInfo.subtitle.length) {
            UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
            subTitleLabel.textAlignment = NSTextAlignmentCenter;
            subTitleLabel.textColor = BYColor333;
            subTitleLabel.font = Font(14);
            subTitleLabel.text = floorInfo.subtitle;
            [_bodyView by_addSubview:subTitleLabel paddingTop:8];
        }
        if (floorInfo.imgtitle.length) {
            BYImageView * image = [[BYImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _info.adImgTitleHeight *(SCREEN_WIDTH-24)/(float)_info.adImgTitleWidth)];
            [image setImageWithUrl:floorInfo.imgtitle placeholderName:@"bg_placeholder"];
            [_bodyView by_addSubview:image paddingTop:14];
        }
        for (int j = 0; j < floorInfo.adsArray.count;j++ ) {
            BYImageView * image = [[BYImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _info.adHeight *(SCREEN_WIDTH-24)/(float)_info.adWidth)];
            //图片边界效果
//            UIView *leftLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 196)];
//            leftLineView.backgroundColor = HEXCOLOR(0xe8e8e8);
//            UIView *rightLineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 32, 0, 1, 196)];
//            rightLineView.backgroundColor = HEXCOLOR(0xe8e8e8);
//            [image addSubview:leftLineView];
            
//            [image addSubview:rightLineView];
            
            NSArray *adsArray = floorInfo.adsArray;
            BYHomeInfoSimple * simple = adsArray[j];
            image.categoryId = simple.categoryID;
            image.jumpURL = simple.link;
            image.tapDelegate = self;
//            image.image = [UIImage imageNamed:@"bg_placeholder"];
            [image setImageWithUrl:simple.imagePath placeholderName:@"bg_placeholder"];
            [image addTapAction:@selector(onImagetap:) target:image];
            [_bodyView by_addSubview:image paddingTop:0];
        }
    }
    
    
    [self.mutiSwitch setSelectedAtIndex:0];
    self.isLoading = NO;
}
-(void)reloadData
{
    __weak BYHomeVC * wself = self;
    if ([BYAppCenter sharedAppCenter].isNetConnected) {
        [_service loadHomePagefinish:^(BYHomeInfo*info,BYError *error){
            if (error) {
                alertError(error);
                [_bodyView headerEndRefreshing];
                return;
            }
            wself.info = info;
            wself.leftViewController.info = info;
            if (wself.isLoading) {
                return;
            }
            _poolNetworkView.hidden = YES;
            [_bodyView headerEndRefreshing];
            [wself performSelector:@selector(updateUI) withObject:nil afterDelay:.4];
        }];
    }else{
        [_bodyView headerEndRefreshing];
        _info = [BYHomeInfo loadInfo];
        if (_info) {
            [MBProgressHUD topShowTmpMessage:@"网络异常，请检查您的网络"];
            return;
        }
        _poolNetworkView.hidden = NO;
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    [self.navigationController setNavigationBarHidden:NO];
    
    
    addCookies(@"http://m.biyao.com/index", @"gobackuri", @".biyao.com");
    
//    addCookies(@"", @"gobackuri", @".biyao.com");
//    _needJumpUrl = @"http://ibuyfun.biyao.com/nvzhuang?f_upd-fa-114";
    if ([_needJumpUrl hasPrefix:@"http://"]) {
        [_commonWebVC.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_needJumpUrl]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:_commonWebVC animated:YES];
        });
        _needJumpUrl = nil;
    }
//    BYUser * user = [BYAppCenter sharedAppCenter].user;
//    _hasNewMessage.hidden = user.messageNum == 0;
//    [self.navigationController pushViewController:[BYCommonWebVC sharedCommonWebVC] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
    
}

- (BYLeftMenuViewController *)leftViewController
{
    if (_leftViewController) {
        return _leftViewController;
    }
    BYAppDelegate * dele =(BYAppDelegate*)[UIApplication sharedApplication].delegate;
    RESideMenu * menu = dele.reSideMenu;
    _leftViewController = (BYLeftMenuViewController *)menu.leftMenuViewController;
    return _leftViewController;
}

- (void)loginAction
{
    [self.navigationController presentViewController:makeLoginnav(nil,nil) animated:YES completion:nil];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BYHomeInfoSimple * simple = _info.bannerArray[index];
    if (simple.categoryID == 0) {
        JumpToWebBlk(simple.link, nil);
    }else{
        BYThemeVC * themeVC = [BYThemeVC sharedThemeWithId:simple.categoryID];
        themeVC.url = simple.link;
        [self.navigationController pushViewController:themeVC animated:YES];
    }
//    JumpToWebBlk(simple.link, nil);
}
- (void)onMore
{
    JumpToWebBlk(@"http://home.biyao.com", nil);
}
- (void)onImagetap:(BYImageView*)sender
{
    
    if (sender.categoryId == 0) {
        JumpToWebBlk(sender.jumpURL, nil);
    }else{
        BYThemeVC * themeVC = [BYThemeVC sharedThemeWithId:sender.categoryId];
        themeVC.url = sender.jumpURL;
        [self.navigationController pushViewController:themeVC animated:YES];
    }
    
}
- (void)onCelltap:(NSString*)link
{
    if ([link hasPrefix:@"http"]) {
        JumpToWebBlk(link, nil);
        return;
    }else if (link.intValue > 1000){
        BYThemeVC * themeVC = [BYThemeVC sharedThemeWithId:link.intValue];
        themeVC.url = [NSString stringWithFormat:@"com.biyao.fu.theme:%d",link.intValue];
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}
- (BYMutiSwitch*)mutiSwitch
{
    if (!_mutiSwitch) {
        _mutiSwitch = [[BYMutiSwitch alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, 46)];
        _mutiSwitch.backView.image = [[UIImage imageNamed:@"bg_tabbar"] resizableImage];
        
        __weak BYHomeVC* wself = self;
        
        UIButton* btn1 = [BYBarButton barBtnWithIcon:@"icon_home_highlight" hlIcon:@"icon_home_highlight" title:@"首页"];
        [btn1 setTitleColor:BYColorb768 forState:UIControlStateHighlighted|UIControlStateNormal];
        [_mutiSwitch addButtonWithBtn:btn1
                               handle:^(id sender) {
                                   [wself reloadData];
                                   [wself.mutiSwitch setSelectedAtIndex:0];
                               }];
        
        UIButton* btn2 = [BYBarButton barBtnWithIcon:@"icon_cart" hlIcon:@"icon_cart" title:@"购物车"];
        [btn2 setTitleColor:BYColorb768 forState:UIControlStateHighlighted];
        [_mutiSwitch addButtonWithBtn:btn2
                               handle:^(id sender) {
//                                   [wself.navigationController pushViewController:[[BYIMViewController alloc]init] animated:YES];
                                   
                                   JumpToWebBlk(BYURL_CARTLIST, nil);
                                   [wself.mutiSwitch setSelectedAtIndex:0];
                               }];
        
        UIButton* btn3 = [BYBarButton barBtnWithIcon:@"icon_mine" hlIcon:@"icon_mine" title:@"我的必要"];
        [btn3 setTitleColor:BYColorb768 forState:UIControlStateHighlighted];
        [_mutiSwitch addButtonWithBtn:btn3
                               handle:^(id sender) {
                                   NSURL* url = [NSURL URLWithString:BYURL_MINE];
                                   [wself.navigationController pushViewController:[BYMineVC sharedMineVC] animated:NO];
                                   wself.navigationItem.hidesBackButton = YES;
                               }];
        
        [self.view addSubview:_mutiSwitch];
    }
    return _mutiSwitch;
}

- (void)leftNav
{
    if (!_info) {
        return;
    }
    [self presentLeftMenuViewController:nil];
}


- (void)refreshUIIfNeeded {

}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    if ([self.navigationController.visibleViewController isEqual:[BYMineVC sharedMineVC]]||
        [self.navigationController.visibleViewController isEqual:[BYCommonWebVC sharedCommonWebVC]]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    NSLog(@"%@",gestureRecognizer);
    return YES;
}
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event
//{
//    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
//        [self onAppShake];
//    }
//}





@end
