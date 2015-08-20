//
//  BYPoolNetworkView.m
//  IBY
//
//  Created by panshiyu on 15/1/4.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYPoolNetworkView.h"

@implementation BYPoolNetworkView

+ (instancetype)poolNetworkView
{
    BYPoolNetworkView* view = [[self alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    view.userInteractionEnabled = NO;
    return view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat topPadding = 100;
        
        UIImageView* iconView = [[UIImageView alloc] initWithFrame:BYRectMake(0, 28 + topPadding, 52, 44)];
        iconView.image = [UIImage imageNamed:@"icon_poolNetwork"];
        iconView.centerX = self.width / 2;
        [self addSubview:iconView];

        UILabel* tipsLabel = [UILabel labelWithFrame:BYRectMake(0, iconView.bottom + 12, self.width, 24) font:Font(16) andTextColor:BYColor666];
        tipsLabel.text = @"内容加载失败";
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipsLabel];

        UILabel* subTipsLabel = [UILabel labelWithFrame:BYRectMake(0, tipsLabel.bottom + 12, self.width, 20) font:Font(14) andTextColor:BYColor666];
        subTipsLabel.text = @"点击重新加载";
        subTipsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:subTipsLabel];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    if (self.isHidden) {
        return NO;
    }
    
    for (UIView* view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

@end

@implementation BYEmptyView

+ (instancetype)emptyviewWithIcon:(NSString*)icon
                             tips:(NSString*)tips;
{
    BYEmptyView* view = [[self alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) icon:icon tips:tips];
    //    view.userInteractionEnabled = NO;
    return view;
}

- (id)initWithFrame:(CGRect)frame icon:(NSString*)icon
               tips:(NSString*)tips
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BYColorClear;

        if (icon) {
            UIImageView* iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
            iconView.centerX = self.width / 2;
            iconView.top = 28;
            [self addSubview:iconView];
        }

        UILabel* tipsLabel = [UILabel labelWithFrame:BYRectMake(0, 90, self.width, 20) font:Font(14) andTextColor:BYColor666];
        tipsLabel.text = tips;
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipsLabel];

        _contentBottom = tipsLabel.bottom;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    for (UIView* view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

@end
