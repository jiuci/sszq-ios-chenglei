
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

#import "MJRefresh.h"

#import "BYLinearScrollView.h"
#import "BYImageView.h"
#import "MJRefreshHeaderView.h"

#import "SDCycleScrollView.h"
#import "BYPoolNetworkView.h"
@interface BYHomeVC ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) BYHomeService * service;
@property (nonatomic, strong) BYHomeInfo * info;
@property (nonatomic, strong) BYLinearScrollView * bodyView;
@property (nonatomic, strong) UIImageView* hasNewMessage;
@property (nonatomic, strong) BYPoolNetworkView* poolNetworkView;
@property (nonatomic, assign) BOOL isLoading;
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
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImgName:@"btn_meassages" highImgName:@"btn_meassages" handler:^(id sender) {
        if (![BYAppCenter sharedAppCenter].isLogin) {
            [self loginAction];
            return;
        }
        JumpToWebBlk(@"http://m.biyao.com/message", nil);
    }];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImgName:@"icon_index_logo" highImgName:@"icon_index_logo" handler:nil];
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
        ((MJRefreshHeaderView*)view).showTimeLabel = NO;
    }
    _info = [BYHomeInfo loadInfo];
    
    
    
    [_poolNetworkView removeFromSuperview];
    _poolNetworkView = [BYPoolNetworkView poolNetworkView];
    [self.view addSubview:_poolNetworkView];
    UIButton* btn = [[UIButton alloc] initWithFrame:_poolNetworkView.frame];
    btn.backgroundColor = BYColorClear;
    [btn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    [_poolNetworkView addSubview:btn];
    _poolNetworkView.hidden = YES;
    _poolNetworkView.backgroundColor = BYColorBG;
    
    [self reloadData];
}
-(void)updateUI
{
    [_bodyView headerEndRefreshing];
    if (!_info) {
        return;
    }
    self.isLoading = YES;
    
    _hasNewMessage.hidden = YES;
    BYUser * user = [BYAppCenter sharedAppCenter].user;
    _hasNewMessage.hidden = user.messageNum == 0;
    [_bodyView by_removeAllSubviews];
    __weak BYHomeVC * wself = self;
    [_bodyView addHeaderWithCallback:^{
        [wself reloadData];
    }];
    if (_info.bannerArray.count == 1) {
        BYImageView * image = [[BYImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH/ (float)_info.bannerWidth*_info.bannerHeight)];
        BYHomeInfoSimple * simple = _info.bannerArray[0];
        image.jumpURL = simple.link;
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
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH/ (float)_info.bannerWidth*_info.bannerHeight) imageURLsGroup:imagesURL placeHolderImage:[UIImage imageNamed:@"bg_placeholder"]];
        cycleScrollView.delegate = self;
        cycleScrollView.autoScrollTimeInterval = 3.0;
        
        [_bodyView by_addSubview:cycleScrollView paddingTop:0];


    }
    for (int i = 0; i < _info.adArray.count; i++) {
        
        BYImageView * image = [[BYImageView alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-24, _info.adHeight *(SCREEN_WIDTH-24)/(float)_info.adWidth)];
        BYHomeInfoSimple * simple = _info.adArray[i];
        image.jumpURL = simple.link;
        image.image = [UIImage imageNamed:@"bg_placeholder"];
        [image setImageWithUrl:simple.imagePath placeholderName:@"bg_placeholder"];
        [image addTapAction:@selector(onImagetap:) target:image];
        [_bodyView by_addSubview:image paddingTop:8 + (i == 0) * 4];
        
    }
    if (!_info.bbsArray||_info.bbsArray.count == 0) {
        self.isLoading = NO;
        return;
    }
    NSDictionary *attrDict1 = @{ NSFontAttributeName: Font(14),
                                NSForegroundColorAttributeName: BYColor333};
    NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: [_info.bbsTitle substringWithRange: NSMakeRange(0, _info.bbsTitle.length)] attributes: attrDict1];
    NSDictionary *attrDict2 = @{ NSFontAttributeName: Font(12),
                                 NSForegroundColorAttributeName: BYColor333 };
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString: [_info.bbsHalfTitle substringWithRange: NSMakeRange(0, _info.bbsHalfTitle.length)] attributes: attrDict2];
    UILabel* bbsTitleLabel= [[UILabel alloc]initWithFrame:CGRectMake(12, 0, self.view.width*.8, 44)];
    NSMutableAttributedString *attributedStr03 = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr1];
    [attributedStr03 appendAttributedString: attrStr2];
    
    [bbsTitleLabel setAttributedText:attributedStr03];
    
    UILabel* moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width*.2, 44)];
    moreLabel.text = @"更多>>";
    moreLabel.textAlignment = NSTextAlignmentRight;
    moreLabel.font = Font(12);
    moreLabel.textColor = HEXCOLOR(0x523669);
    moreLabel.right = SCREEN_WIDTH - 12;
    [moreLabel addTapAction:@selector(onMore) target:self];
    
    UIView * bbsTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [bbsTitleView addSubview:bbsTitleLabel];
    [bbsTitleView addSubview:moreLabel];
    
    [_bodyView by_addSubview:bbsTitleView paddingTop:0];
    UIView * bbsTempView;
    for (int i = 0; i < _info.bbsArray.count; i++) {
        float bbsImageWith = (SCREEN_WIDTH - 12 * 2 - 8) /2;
        BYImageView * image = [[BYImageView alloc]initWithFrame:CGRectMake(12, 0, bbsImageWith, _info.bbsHeight * bbsImageWith/(float)_info.bbsWidth)];
        BYHomeInfoSimple * simple = _info.bbsArray[i];
        image.jumpURL = simple.link;
        image.image = [UIImage imageNamed:@"bg_placeholder"];
        [image setImageWithUrl:simple.imagePath placeholderName:@"bg_placeholder"];
        [image addTapAction:@selector(onImagetap:) target:image];
        UILabel * bbsImageTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, image.height, image.width, 28)];
        bbsImageTitle.text = simple.title;
        bbsImageTitle.textColor = BYColor333;
        bbsImageTitle.textAlignment = NSTextAlignmentCenter;
        bbsImageTitle.font = Font(12);
        bbsImageTitle.backgroundColor = BYColorWhite;
        
        
        if (i%2 == 0) {
            bbsTempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, image.height + 28)];
            [bbsTempView addSubview:image];
            [bbsTempView addSubview:bbsImageTitle];
            [_bodyView by_addSubview:bbsTempView paddingTop:0 + (i != 0) * 12];
        }else{
            image.right = SCREEN_WIDTH - 12;
            bbsImageTitle.right = SCREEN_WIDTH - 12;
            [bbsTempView addSubview:bbsImageTitle];
            [bbsTempView addSubview:image];
        }
        

    }
    [self.mutiSwitch setSelectedAtIndex:0];
    self.isLoading = NO;
    
}
-(void)reloadData
{
    NSLog(@"reload");
    __weak BYHomeVC * wself = self;
    if ([BYAppCenter sharedAppCenter].isNetConnected) {
        [_service loadHomePagefinish:^(BYHomeInfo*info,BYError *error){
            if (error) {
                alertError(error);
                [_bodyView headerEndRefreshing];
                return;
            }
            wself.info = info;
            if (wself.isLoading) {
                return;
            }
            _poolNetworkView.hidden = YES;
            [wself updateUI];
        }];
    }else{
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
    addCookies(@"http://m.biyao.com/index", @"gobackuri", @".biyao.com");
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    [self.mutiSwitch setSelectedAtIndex:0];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
    
}

- (void)loginAction
{
    [self.navigationController presentViewController:makeLoginnav(nil,nil) animated:YES completion:nil];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BYHomeInfoSimple * simple = _info.bannerArray[index];
    JumpToWebBlk(simple.link, nil);
}
- (void)onMore
{
    JumpToWebBlk(@"http://home.biyao.com", nil);
}
- (void)onImagetap:(BYImageView*)sender
{
    JumpToWebBlk(sender.jumpURL, nil);
}
- (BYMutiSwitch*)mutiSwitch
{
    if (!_mutiSwitch) {
        _mutiSwitch = [[BYMutiSwitch alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, 46)];
        _mutiSwitch.backView.image = [[UIImage imageNamed:@"bg_tabbar"] resizableImage];
        
        __weak BYHomeVC* wself = self;
        
        UIButton* btn1 = [BYBarButton barBtnWithIcon:@"icon_hoicon_home_highlightme" hlIcon:@"icon_home_highlight" title:@"首页"];
        [btn1 setTitleColor:BYColorb768 forState:UIControlStateHighlighted];
        [_mutiSwitch addButtonWithBtn:btn1
                               handle:^(id sender) {
                                   [wself reloadData];
                                   [wself.mutiSwitch setSelectedAtIndex:0];
                               }];
        
        UIButton* btn2 = [BYBarButton barBtnWithIcon:@"icon_cart" hlIcon:@"icon_cart" title:@"购物车"];
        [btn2 setTitleColor:BYColorb768 forState:UIControlStateHighlighted];
        [_mutiSwitch addButtonWithBtn:btn2
                               handle:^(id sender) {
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
- (void)refreshUIIfNeeded {

}

-(BOOL)canBecomeFirstResponder {
    return YES;
}
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event
//{
//    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
//        [self onAppShake];
//    }
//}



@end
