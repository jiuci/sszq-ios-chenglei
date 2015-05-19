//
//  BYMutiSwitch.h
//  IBY
//
//  Created by panshiyu on 14-10-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BYStatusBarTapNotification @"com.biyao.statusBarTapNotification"

@interface BYStatusBar : UIWindow {
    /**
     *  透明按钮，用来相应点击状态栏事件
     */
    UIButton *_button;
}

@property (nonatomic, strong) UIButton *button;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)id userInfo;

+ (BYStatusBar *)sharedStatusBar;
+ (void)disappear:(BOOL)animated;

/**
 * message：状态栏上显示的内容，nil表示内容不变
 * second：状态栏消失的时间，0表示一直不消失
 */
+ (void)showStatusBarMessage:(NSString *)message disappearAfter:(NSTimeInterval)second;

/**
 * 此方法修改的状态栏，收到点击时会发出通知，通知名为：BYStatusBarTapNotification
 * message：状态栏上显示的内容，nil表示内容不变
 * second：状态栏消失的时间，0表示一直不消失
 * userInfo: Notification所带的object
 */
+ (void)showStatusBarMessage:(NSString *)message disappearAfter:(NSTimeInterval)second userInfo:(id)userInfo;

@end
