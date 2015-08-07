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
#
#import "BYNumberTip.h"

@interface BYMineHeaderView ()
{
    BYNumberTip * notPayOrderTip;
    BYNumberTip * toReceiveOrderTip;
    BYNumberTip * refundOrderTip;
}
@property (weak, nonatomic) IBOutlet BYImageView* userIcon;
@property (weak, nonatomic) IBOutlet UILabel* userName;
@property (weak, nonatomic) IBOutlet UIView* loginView;
@property (weak, nonatomic) IBOutlet UIView* orderStatusView;

@property (nonatomic, strong) UIButton* loginButton;
@property (nonatomic, strong) UIButton* registButton;
@property (nonatomic, strong) UIButton* notPayOrderBtn;
@property (nonatomic, strong) UIButton* refundOrderBtn;
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
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
}

- (void)setupUI
{
    //点击昵称  跳转到昵称 修改页面
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    [_userName addTapAction:@selector(resetNickname) target:self];
    _userName.shadowColor = HEXACOLOR(0x000000, .2);
    _userName.shadowOffset = CGSizeMake(0, 1.0);
    //setup  登录项
    UIImageView* bgImagview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _loginView.width, _loginView.height)];
    UIImage* bgImage = [UIImage imageNamed:@"bg_usercenter_header"];
    bgImagview.image = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width / 2 topCapHeight:0.];
//    [_loginView addSubview:bgImagview];
    _mineVC = [BYMineVC sharedMineVC];
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
    [_loginButton setTitle:@"登录 / 注册" forState:UIControlStateNormal];
    [_loginButton setTitleColor:BYColorb768 forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_loginButton addTarget:_mineVC action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    _loginButton.backgroundColor = [UIColor clearColor];
    [_loginButton setBackgroundImage:[[UIImage imageNamed:@"bg_usercenter_trans_login"] resizableImage] forState:UIControlStateNormal];
    _loginView.backgroundColor = [UIColor clearColor];
    [_loginView addSubview:_loginButton];

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
    CGFloat btnHeight = 52;
    //
    _notPayOrderBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, btnWidth, btnHeight) icon:@"icon_usercenter_orderpayment" iconEdge:UIEdgeInsetsMake(0, 20, 10, 0) bgIcon:nil title:@"待付款"];
    CGSize size = [_notPayOrderBtn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil]];
    [_notPayOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake( 0,-[_notPayOrderBtn imageForState:UIControlStateNormal].size.width, -26,0)];
    [_notPayOrderBtn setImageEdgeInsets:UIEdgeInsetsMake(-18, 0,0, -size.width)];
    _notPayOrderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_notPayOrderBtn setTitleColor:BYColorWhite forState:UIControlStateNormal];
    _notPayOrderBtn.left = 0;
    [_notPayOrderBtn addTarget:_mineVC action:@selector(onToPayOrders) forControlEvents:UIControlEventTouchUpInside];
    [_orderStatusView addSubview:_notPayOrderBtn];
    notPayOrderTip = [BYNumberTip numberTipwithFrame:CGRectMake(20, 0, 8, 8) inView:_notPayOrderBtn];
    

    UIImageView* orderSepLineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 32)];
    orderSepLineView1.image = [UIImage imageNamed:@"line_usercenter_separate"];
    orderSepLineView1.left = _notPayOrderBtn.right;
    orderSepLineView1.centerY = _orderStatusView.height / 2;
    [_orderStatusView addSubview:orderSepLineView1];

    //
    _notReceivedOrderBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, btnWidth, btnHeight) icon:@"icon_usercenter_receive" iconEdge:UIEdgeInsetsMake(0, 0, 0, 10) bgIcon:nil title:@"待收货"];
    size = [_notReceivedOrderBtn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil]];
    [_notReceivedOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake( 0,-[_notReceivedOrderBtn imageForState:UIControlStateNormal].size.width, -26,0)];
    [_notReceivedOrderBtn setImageEdgeInsets:UIEdgeInsetsMake(-18, 0,0, -size.width)];
    _notReceivedOrderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_notReceivedOrderBtn setTitleColor:BYColorWhite forState:UIControlStateNormal];
    _notReceivedOrderBtn.left = orderSepLineView1.right;
    [_notReceivedOrderBtn addTarget:_mineVC action:@selector(onToDeliverConfirmOrders) forControlEvents:UIControlEventTouchUpInside];
    [_orderStatusView addSubview:_notReceivedOrderBtn];
    
    toReceiveOrderTip = [BYNumberTip numberTipwithFrame:CGRectMake(20, 0, 8, 8) inView:_notReceivedOrderBtn];

    UIImageView* orderSepLineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 32)];
    orderSepLineView2.image = [UIImage imageNamed:@"line_usercenter_separate"];
    orderSepLineView2.left = _notReceivedOrderBtn.right;
    orderSepLineView2.centerY = _orderStatusView.height / 2;
    [_orderStatusView addSubview:orderSepLineView2];

    _refundOrderBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, btnWidth, btnHeight) icon:@"icon_usercenter_refund" iconEdge:UIEdgeInsetsMake(0, 0, 0, 10) bgIcon:nil title:@"退款/售后"];
    size = [_refundOrderBtn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil]];
    [_refundOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake( 0,-[_refundOrderBtn imageForState:UIControlStateNormal].size.width, -26,0)];
    [_refundOrderBtn setImageEdgeInsets:UIEdgeInsetsMake(-18, 0,0, -size.width)];
    _refundOrderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_refundOrderBtn setTitleColor:BYColorWhite forState:UIControlStateNormal];
    _refundOrderBtn.left = orderSepLineView2.right;
    [_refundOrderBtn addTarget:_mineVC action:@selector(onInRefundOrders) forControlEvents:UIControlEventTouchUpInside];
    [_orderStatusView addSubview:_refundOrderBtn];
    refundOrderTip = [BYNumberTip numberTipwithFrame:CGRectMake(20, 0, 8, 8) inView:_refundOrderBtn];
    
//    [_userIcon addTapAction:@selector(onAvatar) target:_mineVC];
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
        
        refundOrderTip.number = [BYAppCenter sharedAppCenter].user.refundNum;
        toReceiveOrderTip.number = [BYAppCenter sharedAppCenter].user.toReceiveOrderNum;
        notPayOrderTip.number = [BYAppCenter sharedAppCenter].user.notPayOrderNum;
        
//        refundOrderTip.number = 10;
//        toReceiveOrderTip.number = 15;
//        notPayOrderTip.number = 5;
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
