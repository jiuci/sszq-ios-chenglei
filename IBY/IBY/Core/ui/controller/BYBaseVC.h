//
//  BYBaseVC.h
//  IBY
//
//  Created by panShiyu on 14-9-10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYPortalCenter.h"

@interface BYBaseVC : UIViewController

@property (nonatomic, assign) BOOL autoHideKeyboard;
@property (nonatomic, assign) CGFloat tipsTopPadding;

//tips
- (void)showTipsView:(NSString*)tips icon:(NSString*)icon;
- (void)showTipsView:(NSString*)tips icon:(NSString*)icon subView:(UIView*)subView;
- (void)showPoolnetworkView;
- (void)hideTipsView;

//topmenu
- (void)showPortalView:(NSArray*)aims;

//for test easily
- (void)toTestpage:(NSString*)pageName;

- (void)onBackgroundTap;

//刷新数据和加载更多
- (void)refreshData;
- (void)loadMore;

//刷新UI
- (void)refreshUIIfNeeded;

@end
