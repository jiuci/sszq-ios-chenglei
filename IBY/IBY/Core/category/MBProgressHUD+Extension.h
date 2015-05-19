//
//  MBProgressHUD+Extension.h
//  IBY
//
//  Created by coco on 14-9-23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)

+ (void)showSuccess:(NSString*)success toView:(UIView*)view;
+ (void)showError:(NSString*)error toView:(UIView*)view;

+ (MBProgressHUD*)showMessage:(NSString*)message toView:(UIView*)view;

+ (void)showSuccess:(NSString*)success;
+ (void)showError:(NSString*)error;

+ (MBProgressHUD*)showMessage:(NSString*)message;

+ (void)hideHUDForView:(UIView*)view;
+ (void)hideHUD;

//add by psy
+ (void)topShow:(NSString*)message;
+ (void)topHide;

+ (void)topShowTmpMessage:(NSString*)message;

@end
