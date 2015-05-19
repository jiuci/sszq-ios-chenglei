//
//  BYBasePopoverView.h
//  IBY
//
//  Created by panshiyu on 14-10-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYBasePopoverView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL autoHideWhenTapBg; //default is YES
+ (instancetype)createPopoverView;

- (void)showInView:(UIView*)view;
- (void)hide;

@end
