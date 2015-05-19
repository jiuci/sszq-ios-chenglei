//
//  BYBaseVC.m
//  IBY
//
//  Created by panShiyu on 14-9-10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"
#import "BYPopMenu.h"
#import "BYPoolNetworkView.h"

@interface BYBaseVC () <UIGestureRecognizerDelegate>

@end

@implementation BYBaseVC {
    UIView* _tipsView;
    UITapGestureRecognizer* _tapGesture;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = BYColorBG;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)setAutoHideKeyboard:(BOOL)autoHideKeyboard
{
    _autoHideKeyboard = autoHideKeyboard;

    if (!_autoHideKeyboard) {
        if (_tapGesture) {
            //            [_tapGesture removeTarget:self action:@selector(onBackgroundTap)];
            [self.view removeGestureRecognizer:_tapGesture];
            _tapGesture = nil;
        }
    }
    else {
        if (!_tapGesture) {
            _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundTap)];
            _tapGesture.cancelsTouchesInView = NO;
            _tapGesture.delegate = self;
            [self.view addGestureRecognizer:_tapGesture];
        }
    }
}

- (void)onBackgroundTap
{
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if ([touch.view isKindOfClass:[UIControl class]]) {
            return NO;
        }
    }

    return YES;
}

#pragma mark - tips

- (void)showTipsView:(NSString*)tips icon:(NSString*)icon
{
    [self showTipsView:tips icon:icon subView:nil];
}

- (void)showTipsView:(NSString*)tips icon:(NSString*)icon subView:(UIView*)subView
{
    [self hideTipsView];

    _tipsView = [BYEmptyView emptyviewWithIcon:icon tips:tips];
    if (subView) {
        subView.top = ((BYEmptyView*)_tipsView).contentBottom;
        [_tipsView addSubview:subView];
    }
    _tipsView.top = _tipsTopPadding;
    [self.view addSubview:_tipsView];
}

- (void)showPoolnetworkView
{
    [self hideTipsView];
    _tipsView = [BYPoolNetworkView poolNetworkView];
    _tipsView.top = _tipsTopPadding;
    [self.view addSubview:_tipsView];
}

- (void)hideTipsView
{
    if (_tipsView) {
        [_tipsView removeFromSuperview];
        _tipsView = nil;
    }
}

#pragma mark - portal

- (void)showPortalView:(NSArray*)aims
{
    BYPopMenu* popMenu = [BYPopMenu createPopoverView];

//    NSArray* titles = @[ @"首页",
//                         @"购物车",
//                         @"我的预约",
//                         @"我的必要",
//                         @"消息" ];
//    NSArray* icons = @[ @"icon_topmenu_home",
//                        @"icon_topmenu_cart",
//                        @"icon_topmenu_book",
//                        @"icon_topmenu_mine",
//                        @"icon_topmenu_message" ];

//    [aims enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL* stop) {
//        BYPortal portal = [obj intValue];
//        if (portal > BYPortalMessage) {
//            return ;
//        }
//        
//        NSString *title = titles[portal];
//        NSString *icon = icons[portal];
//        [popMenu addBtnWithTitle:title
//                            icon:icon
//                         hasLine:(idx != aims.count-1)
//                         handler:^(id sender) {
//                             [[BYPortalCenter sharedPortalCenter] portTo:portal];
//                         }];
//    }];

    [popMenu show];
}

#pragma mark - 下拉刷新和上拉加载

- (void)refreshData
{
    //更新全部数据
}

- (void)loadMore
{
    //加载下一页
}

#pragma mark - 

- (void)refreshUIIfNeeded {
    
}

#pragma mark - for test,不可以作为平时功能调用

- (void)toTestpage:(NSString*)pageName
{
    [self.navigationController pushViewController:[[NSClassFromString(pageName) alloc] init] animated:YES];
}

@end
