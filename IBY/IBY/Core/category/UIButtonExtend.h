//
//  UIButtonExtend.h
//  IBY
//
//  Created by panShiyu on 14/12/3.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (helper)

+ (instancetype)buttonWithNormalIconName:(NSString*)normalIcon hlIconName:(NSString*)hlIcon;
+ (instancetype)buttonWithIconName:(NSString*)icon;

+ (instancetype)buttonWithNormalBg:(NSString*)normalBg hlBg:(NSString*)hlBg;

+ (instancetype)buttonWithFrame:(CGRect)frame
                           icon:(NSString*)icon
                       iconEdge:(UIEdgeInsets)iconEdge
                         bgIcon:(NSString*)bgIcon
                          title:(NSString*)title;

+ (instancetype)buttonWithFrame:(CGRect)frame
                          title:(NSString*)title
                     titleColor:(UIColor*)color
                         bgName:(NSString*)bgIcon
                        handler:(void (^)(id sender))handler;

+ (instancetype)redButton;

@end
