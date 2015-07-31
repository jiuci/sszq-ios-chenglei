//
//  BYMinewVC.m
//  IBY
//
//  Created by coco on 14-9-13.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYMineVC.h"
#import "BYLoginVC.h"

#import "BYMineHeaderView.h"
#import "BYLinearScrollView.h"

#import "BYMineCell.h"

#import "BYRegist1VC.h"
//#import "BYOrderlistVC.h"
//#import "BYMyDesignsVC.h"
#import "BYSettingVC.h"
//#import "BYMessageVC.h"
#import "BYAboutVC.h"
//#import "BYMyDesignsVC.h"
#import "BYAddressManagelistVC.h"
#import "BYUserService.h"
//#import "BYOrder.h"

#import "BYCaptureVC.h"
#import "BYGlassPageVC.h"

#import "BYBarButtonItem.h"
#import "BYCommonWebVC.h"

#import "BYAvatarSettingVC.h"
//#import "BYtest.h"

@interface BYMineVC ()
@property (nonatomic, strong) BYLinearScrollView* bodyView;
@property (nonatomic, strong) BYMineHeaderView* headerView;
@property (nonatomic, strong) BYUserService* service;
@end

@implementation BYMineVC
+ (instancetype)sharedMineVC
{
    static BYMineVC* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _service = [[BYUserService alloc] init];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
    [self updateData];
    [self.mutiSwitch setSelectedAtIndex:2];
    
    
}

- (void)updateData
{
    if ([BYAppCenter sharedAppCenter].isLogin) {
        [_service fetchUserLatestStatus:^(BOOL isSuccess, BYError* error) {
            if (isSuccess) {
                [self updateUI];
            }
        }];
    }
}

- (void)updateUI
{
    [self.headerView updateUI];
    [MBProgressHUD topHide];
}

- (void)setupUI
{
    //nav
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImgName:@"icon_message" highImgName:@"icon_message" handler:^(id sender) {
        [[BYAppCenter sharedAppCenter] runAfterLoginFromVC:self withSuccessBlk:^{
        
//                [[BYPortalCenter sharedPortalCenter] portTo:BYPortalMessage];
            } cancelBlk:^{
                
            }];
    }];
    
    _bodyView = [[BYLinearScrollView alloc] initWithFrame:BYRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.height - 46 - [[UIApplication sharedApplication] statusBarFrame].size.height)];
//    _bodyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _bodyView.autoAdjustContentSize = NO;
    _bodyView.minContentSizeHeight = 0;
    [self.view addSubview:_bodyView];

    _headerView = [BYMineHeaderView headerView];
    [_headerView setupUI];
    _headerView.mineVC = self;
    [self.bodyView by_addSubview:_headerView paddingTop:0];

    [self appendCell:@"icon_usercenter_orderinquiry"
               title:@"我的订单"
                 top:12
                 sel:@selector(onOrders)];

    [self appendCell:@"icon_usercenter_collection"
               title:@"我的作品集"
                 top:0
                 sel:@selector(onMydesigns)];

    [self appendCell:@"icon_usercenter_addressadmin"
               title:@"我的地址"
                 top:0
                 sel:@selector(onAdress)];
    
    [self appendCell:@"icon_usercenter_addressadmin"
               title:@"退款管理"
                 top:0
                 sel:@selector(onAdress)];

    [self appendCell:@"icon_usercenter_setting"
               title:@"设置"
                 top:12
                 sel:@selector(onSetting)];
    
    [self appendCell:@"icon_usercenter_setting"
               title:@"客服电话"
                 top:0
                 sel:@selector(onService)];
//    [self appendCell:@"icon_usercenter_setting"
//               title:@"相机"
//                 top:12
//                 sel:@selector(onCamera)];
//    
//    [self appendCell:@"icon_usercenter_setting"
//               title:@"pageView"
//                 top:12
//                 sel:@selector(pageScroll)];
    
    [self.view addSubview:self.mutiSwitch];
    
    [self.mutiSwitch mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@46);
        make.bottom.equalTo(self.view);
    }];
    
    
}
- (BYMutiSwitch*)mutiSwitch
{
    if (!_mutiSwitch) {
        _mutiSwitch = [[BYMutiSwitch alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, 46)];
        _mutiSwitch.backView.image = [[UIImage imageNamed:@"bg_tabbar"] resizableImage];
        
        __weak BYMineVC* wself = self;
        
        UIButton* btn1 = [BYBarButton barBtnWithIcon:@"icon_home" hlIcon:@"icon_home_highlight" title:@"主页"];
        [_mutiSwitch addButtonWithBtn:btn1
                               handle:^(id sender) {
                                   wself.exitBlk(BYURL_HOME);
                               }];
        
        UIButton* btn2 = [BYBarButton barBtnWithIcon:@"icon_cart" hlIcon:@"icon_cart_highlight" title:@"购物车"];
        [_mutiSwitch addButtonWithBtn:btn2
                               handle:^(id sender) {
                                   wself.exitBlk(BYURL_CARTLIST);
                               }];
        
        UIButton* btn3 = [BYBarButton barBtnWithIcon:@"icon_mine" hlIcon:@"icon_mine_highlight" title:@"我的必要"];
        [_mutiSwitch addButtonWithBtn:btn3
                               handle:^(id sender) {
                                   //再进我的必要就不响应了
                                   [wself.mutiSwitch setSelectedAtIndex:2];
                               }];
        
        [self.view addSubview:_mutiSwitch];
    }
    return _mutiSwitch;
}
- (void)appendCell:(NSString*)icon title:(NSString*)title top:(CGFloat)top sel:(SEL)selecor
{
    BYMineCell* cell = [BYMineCell cellWithTitle:title icon:icon target:self sel:selecor];
    [self.bodyView by_addSubview:cell paddingTop:top];
    
}

#pragma mark -

- (void)pageScroll{
//    
//    BYtest* test = [[BYtest alloc] init];
//    [test detectEyes];
}

- (void)onCamera
{
    
    
    NSString* glassCache = @"glassCache";
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:glassCache];
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if(array.count == 0){
        BYCaptureVC* capVC = [[BYCaptureVC alloc] init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:capVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
    }else{
        BYGlassPageVC* pageVC = [[BYGlassPageVC alloc]init];
        [self.navigationController pushViewController:pageVC animated:YES];
    }
}

- (void)onMydesigns
{
//    [[BYAppCenter sharedAppCenter] runAfterLoginFromVC:self withBlk:^{
//        BYMyDesignsVC *vc = [[BYMyDesignsVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
    if (![BYAppCenter sharedAppCenter].isLogin) {
        [self loginAction];
        return;
    }
    _exitBlk(@"http://m.biyao.com/account/myworks");
}

- (void)onAdress
{
    if (![BYAppCenter sharedAppCenter].isLogin) {
        [self loginAction];
        return;
    }
    [[BYAppCenter sharedAppCenter] runAfterLoginFromVC:self withBlk:^{
        BYAddressManagelistVC *vc = [[BYAddressManagelistVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)onOrders
{
//    [[BYAppCenter sharedAppCenter] runAfterLoginFromVC:self withBlk:^{
//        BYOrderlistVC *vc = [[BYOrderlistVC alloc] init];
//        vc.filterStatus = STATUS_All;
//        vc.title = @"订单查询";
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
    if (![BYAppCenter sharedAppCenter].isLogin) {
        [self loginAction];
        return;
    }
    _exitBlk(@"http://m.biyao.com/order/orderlist");
}

- (void)onToPayOrders
{
    //TODO: sitong
//    [[BYAppCenter sharedAppCenter] runAfterLoginFromVC:self withBlk:^{
//        BYOrderlistVC *vc = [[BYOrderlistVC alloc] init];
//        vc.filterStatus = STATUS_UNPAY;
//        vc.titleString = @"待付款订单";
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
    if (![BYAppCenter sharedAppCenter].isLogin) {
        [self loginAction];
        return;
    }
    _exitBlk(@"http://m.biyao.com/order/orderlist?orderStatus=1");

    
}

- (void)onInProcessOrders
{
    //TODO: sitong
//    [[BYAppCenter sharedAppCenter] runAfterLoginFromVC:self withBlk:^{
//        BYOrderlistVC *vc = [[BYOrderlistVC alloc] init];
//        vc.filterStatus = STATUS_PRODUCING;
//        vc.titleString = @"生产中订单";
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
    if (![BYAppCenter sharedAppCenter].isLogin) {
        [self loginAction];
        return;
    }
    _exitBlk(@"http://m.biyao.com/order/orderlist?orderStatus=3");
}

- (void)onToDeliverConfirmOrders
{
//    //TODO: sitong
//    [[BYAppCenter sharedAppCenter] runAfterLoginFromVC:self withBlk:^{
//        BYOrderlistVC *vc = [[BYOrderlistVC alloc] init];
//        vc.filterStatus = STATUS_DILIVER;
//        vc.titleString = @"待收货订单";
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
    if (![BYAppCenter sharedAppCenter].isLogin) {
        [self loginAction];
        return;
    }
    _exitBlk(@"http://m.biyao.com/order/orderlist?orderStatus=4");
}

- (void)onService
{
    _exitBlk(@"http://m.biyao.com/service");
    
}

- (void)loginAction
{
    [self.navigationController presentViewController:makeLoginnav(nil,nil) animated:YES completion:nil];
}

- (void)onSetting
{
    BYSettingVC* vc = [[BYSettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)onAvatar
//{
//    BYAvatarSettingVC* vc = [[BYAvatarSettingVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    
//}

BYNavVC* makeMinenav(BYMineExitBlock blk)
{
    BYMineVC* vc = [BYMineVC sharedMineVC];
    BYNavVC* nav = [BYNavVC nav:vc title:@"个人中心"];
    vc.exitBlk = blk;
    return nav;
}
@end
