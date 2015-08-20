//
//  UIViewExtend.h
//  DVMobile
//
//  Created by panshiyu on 14-11-3.
//  Copyright (c) 2014年 mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

- (void)addTapAction:(SEL)tapAction target:(id)target;

//- (UIView*)findViewThatIsFirstResponder;
- (UIViewController*)viewController;

- (void)removeAllSubviews;

@end
