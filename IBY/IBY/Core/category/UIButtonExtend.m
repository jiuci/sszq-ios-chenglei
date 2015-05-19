//
//  UIButtonExtend.m
//  IBY
//
//  Created by panShiyu on 14/12/3.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "UIButtonExtend.h"

@implementation UIButton (helper)

+ (instancetype)buttonWithNormalIconName:(NSString*)normalIcon hlIconName:(NSString*)hlIcon
{
    UIButton* button = [[UIButton alloc] init];
    button.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    [button setImage:[UIImage imageNamed:normalIcon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hlIcon] forState:UIControlStateHighlighted];
    CGSize imgSize = button.imageView.image.size;
    button.size = CGSizeMake(imgSize.width, imgSize.height + 20);
    return button;
}

+ (instancetype)buttonWithIconName:(NSString*)icon
{
    return [self buttonWithNormalIconName:icon hlIconName:icon];
}

+ (instancetype)buttonWithNormalBg:(NSString*)normalBg hlBg:(NSString*)hlBg
{
    UIButton* button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:normalBg] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hlBg] forState:UIControlStateHighlighted];
    return button;
}

+ (instancetype)buttonWithFrame:(CGRect)frame
                           icon:(NSString*)icon
                       iconEdge:(UIEdgeInsets)iconEdge
                         bgIcon:(NSString*)bgIcon
                          title:(NSString*)title
{
    UIButton* button = [[UIButton alloc] initWithFrame:frame];

    if (icon) {
        button.imageEdgeInsets = iconEdge;
        [button setImage:[[UIImage imageNamed:icon] resizableImage] forState:UIControlStateNormal];
    }

    if (bgIcon) {
        [button setBackgroundImage:[[UIImage imageNamed:bgIcon] resizableImage] forState:UIControlStateNormal];
    }

    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];

    return button;
}

+ (instancetype)buttonWithFrame:(CGRect)frame
                          title:(NSString*)title
                     titleColor:(UIColor*)color
                         bgName:(NSString*)bgIcon
                        handler:(void (^)(id sender))handler
{
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];

    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateHighlighted];

    button.backgroundColor = [UIColor clearColor];

    if (bgIcon) {
        [button setBackgroundImage:[[UIImage imageNamed:bgIcon] resizableImage] forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed:bgIcon] resizableImage] forState:UIControlStateHighlighted];
    }

    if (handler) {
        [button bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    }

    return button;
}

+ (instancetype)redButton
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_red"] resizableImage] forState:UIControlStateNormal];
    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_red_on"] resizableImage] forState:UIControlStateHighlighted];
    btn.titleLabel.font = Font(16);
    [btn setTitleColor:BYColorWhite forState:UIControlStateNormal];
    [btn setTitleColor:BYColorWhite forState:UIControlStateHighlighted];
    return btn;
}

@end
