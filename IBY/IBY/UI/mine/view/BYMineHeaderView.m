//
//  BYHeaderView.m
//  IBY
//
//  Created by coco on 14-9-18.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYMineHeaderView.h"
#import "BYUser.h"
//#import "BYOrderlistVC.h"
//#import "BYSetNicknameVC.h"
#import "BYLoginVC.h"
#import "BYRegist1VC.h"
#import "BYImageView.h"
#import "BYMineVC.h"

@interface BYMineHeaderView ()
@property (weak, nonatomic) IBOutlet BYImageView* userIcon;
@property (weak, nonatomic) IBOutlet UILabel* userName;
@property (weak, nonatomic) IBOutlet UIView* loginView;
@property (weak, nonatomic) IBOutlet UIView* orderStatusView;

@property (nonatomic, strong) UIButton* loginButton;
@property (nonatomic, strong) UIButton* registButton;
@property (nonatomic, strong) UIButton* notPayOrderBtn;
@property (nonatomic, strong) UIButton* producingOrderBtn;
@property (nonatomic, strong) UIButton* notReceivedOrderBtn;

@end

@implementation BYMineHeaderView
+ (instancetype)headerView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BYMineHeaderView" owner:nil options:nil] lastObject];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 164);
}

- (void)setupUI
{
    //点击昵称  跳转到昵称 修改页面
    [_userName addTapAction:@selector(resetNickname) target:self];
    //setup  登录项
    UIImageView* bgImagview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _loginView.width, _loginView.height)];
    UIImage* bgImage = [UIImage imageNamed:@"bg_userscreen_login"];
    bgImagview.image = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width / 2 topCapHeight:0.];
    [_loginView addSubview:bgImagview];

//    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, _loginView.height)];
//    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
//    [_loginButton setTitleColor:BYColorb768 forState:UIControlStateNormal];
//    _loginButton.titleLabel.font = [UIFont systemFontOfSize:11];
//    [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
//    [_loginView addSubview:_loginButton];
//
//    UIImageView* loginSepLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 15)];
//    loginSepLineView.left = _loginButton.right;
//    loginSepLineView.center = CGPointMake(_loginView.width / 2, _loginView.height / 2);
//    loginSepLineView.image = [UIImage imageNamed:@"line_usercenter_login"];
//    [_loginView addSubview:loginSepLineView];
//
//    _registButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, _loginView.height)];
//    [_registButton setTitle:@"注册" forState:UIControlStateNormal];
//    _registButton.titleLabel.font = [UIFont systemFontOfSize:11];
//    [_registButton setTitleColor:BYColorb768 forState:UIControlStateNormal];
//    _registButton.left = loginSepLineView.right;
//    [_registButton addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
//    [_loginView addSubview:_registButton];

    //setup 订单项目
    CGFloat btnWidth = (SCREEN_WIDTH - 2) / 3;
    CGFloat btnHeight = 40;
    //待付款订单btn
    _notPayOrderBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, btnWidth, btnHeight) icon:@"icon_usercenter_orderpayment" iconEdge:UIEdgeInsetsMake(0, 0, 0, 10) bgIcon:nil title:@"待付款"];
    _notPayOrderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_notPayOrderBtn setTitleColor:BYColorWhite forState:UIControlStateNormal];
    _notPayOrderBtn.left = 0;
    [_notPayOrderBtn addTarget:_mineVC action:@selector(onToPayOrders) forControlEvents:UIControlEventTouchUpInside];
    [_orderStatusView addSubview:_notPayOrderBtn];

    UIImageView* orderSepLineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 22)];
    orderSepLineView1.image = [UIImage imageNamed:@"line_usercenter_separate"];
    orderSepLineView1.left = _notPayOrderBtn.right;
    orderSepLineView1.centerY = _orderStatusView.height / 2;
    [_orderStatusView addSubview:orderSepLineView1];

    //生产中订单
    _producingOrderBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, btnWidth, btnHeight) icon:@"icon_usercenter_producing" iconEdge:UIEdgeInsetsMake(0, 0, 0, 10) bgIcon:nil title:@"生产中"];
    _producingOrderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_producingOrderBtn setTitleColor:BYColorWhite forState:UIControlStateNormal];
    _producingOrderBtn.left = orderSepLineView1.right;
    [_producingOrderBtn addTarget:_mineVC action:@selector(onInProcessOrders) forControlEvents:UIControlEventTouchUpInside];
    [_orderStatusView addSubview:_producingOrderBtn];

    UIImageView* orderSepLineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 22)];
    orderSepLineView2.image = [UIImage imageNamed:@"line_usercenter_separate"];
    orderSepLineView2.left = _producingOrderBtn.right;
    orderSepLineView2.centerY = _orderStatusView.height / 2;
    [_orderStatusView addSubview:orderSepLineView2];

    _notReceivedOrderBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, btnWidth, btnHeight) icon:@"icon_usercenter_orderdeliver" iconEdge:UIEdgeInsetsMake(0, 0, 0, 10) bgIcon:nil title:@"待收货"];
    _notReceivedOrderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_notReceivedOrderBtn setTitleColor:BYColorWhite forState:UIControlStateNormal];
    _notReceivedOrderBtn.left = orderSepLineView2.right;
    [_notReceivedOrderBtn addTarget:_mineVC action:@selector(onToDeliverConfirmOrders) forControlEvents:UIControlEventTouchUpInside];
    [_orderStatusView addSubview:_notReceivedOrderBtn];
}

- (void)updateUI
{
    if ([BYAppCenter sharedAppCenter].isLogin) {
        self.userName.userInteractionEnabled = YES;
        self.userName.text = [BYAppCenter sharedAppCenter].user.nickname;

        [self.userIcon setImageWithUrl:[BYAppCenter sharedAppCenter].user.avatar placeholderName:@"icon_user_default"];
        [_userIcon.layer setCornerRadius:_userIcon.width / 2];
        CALayer* imageLayer = _userIcon.layer;
        [imageLayer setMasksToBounds:YES];

        _loginView.hidden = YES;
    }
    else {
        self.userName.userInteractionEnabled = NO;
        self.userIcon.image = [UIImage imageNamed:@"icon_user_default"];
        self.userName.text = nil;

        _loginView.hidden = NO;
    }
}

- (void)resetNickname
{
    NSLog(@"resetNickname");
//    BYSetNicknameVC* setNicknameVC = [[BYSetNicknameVC alloc] init];
//    [self.mineVC.navigationController pushViewController:setNicknameVC animated:YES];
}

//- (void)loginAction
//{
//    [self.mineVC.navigationController presentViewController:makeLoginnav(nil,nil) animated:YES completion:nil];
//}
//
//- (void)registAction
//{
//    BYRegist1VC* registerVC = [[BYRegist1VC alloc] init];
//    [self.mineVC.navigationController pushViewController:registerVC animated:YES];
//}

//- (void)onToPayOrders
//{
//    //TODO: sitong
//    [[BYAppCenter sharedAppCenter] runAfterLoginFromVC:self.mineVC withBlk:^{
//        BYOrderlistVC *vc = [[BYOrderlistVC alloc] init];
//        vc.filterStatus = STATUS_UNPAY;
//        vc.titleString = @"待付款订单";
//        [self.mineVC.navigationController pushViewController:vc animated:YES];
//    }];
//}

//- (void)onInProcessOrders
//{
//    //TODO: sitong
//    [[BYAppCenter sharedAppCenter] runAfterLoginFromVC:self.mineVC withBlk:^{
//        BYOrderlistVC *vc = [[BYOrderlistVC alloc] init];
//        vc.filterStatus = STATUS_PRODUCING;
//        vc.titleString = @"生产中订单";
//        [self.mineVC.navigationController pushViewController:vc animated:YES];
//    }];
//}

//- (void)onToDeliverConfirmOrders
//{
    //TODO: sitong
//    [[BYAppCenter sharedAppCenter] runAfterLoginFromVC:self.mineVC withBlk:^{
//        BYOrderlistVC *vc = [[BYOrderlistVC alloc] init];
//        vc.filterStatus = STATUS_DILIVER;
//        vc.titleString = @"待收货订单";
//        [self.mineVC.navigationController pushViewController:vc animated:YES];
//    }];
//}

@end
