//
//  MBProgressHUD+Extension.m
//  IBY
//
//  Created by coco on 14-9-23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)
#pragma mark 显示信息
+ (void)show:(NSString*)text icon:(NSString*)icon view:(UIView*)view
{
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    // 1秒之后再消失
    [hud hide:YES afterDelay:0.7];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString*)error toView:(UIView*)view
{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString*)success toView:(UIView*)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD*)showMessage:(NSString*)message toView:(UIView*)view
{
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

+ (void)showSuccess:(NSString*)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString*)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD*)showMessage:(NSString*)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView*)view
{
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

static MBProgressHUD* keyWindowHUD = nil;
+ (void)topShow:(NSString*)message
{
    [self topHide];

    //    keyWindowHUD = [self showMessage:message toView:[UIApplication sharedApplication].keyWindow];

    // 快速显示一个提示信息
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    keyWindowHUD = hud;
}

+ (void)topHide
{
    if (keyWindowHUD) {
        [keyWindowHUD removeFromSuperview];
        keyWindowHUD = nil;
    }
}

+ (void)topShowTmpMessage:(NSString*)message
{
    [self topHide];

    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = message;
//    hud.detailsLabelText = message;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    //    hud.dimBackground = YES;
    [hud hide:YES afterDelay:2.0];
}


@end
