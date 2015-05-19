//
//  BYCustomButton.m
//  IBY
//
//  Created by panshiyu on 14/12/22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYCustomButton.h"

@implementation BYCustomButton

+ (instancetype)btnWithFrame:(CGRect)frame
                        icon:(NSString*)icon
                       title:(NSString*)title
                   titleFont:(UIFont*)font
                  titleColor:(UIColor*)color
{
    BYCustomButton* btn = [[BYCustomButton alloc] initWithFrame:frame
                                                           icon:icon
                                                          title:title
                                                      titleFont:font
                                                     titleColor:color];
    return btn;
}

- (id)initWithFrame:(CGRect)frame
               icon:(NSString*)icon
              title:(NSString*)title
          titleFont:(UIFont*)font
         titleColor:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [[UIImageView alloc] initWithFrame:BYRectMake(0, 0, self.width, self.height)];
        _bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bgView];

        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
        [self addSubview:_iconView];

        _titleLabel = [UILabel labelWithFrame:BYRectMake(0, 0, self.width, self.height) font:font andTextColor:color];
        _titleLabel.text = title;
        [self addSubview:_titleLabel];

        [self resetUI];
    }
    return self;
}

- (void)updateIconImg:(NSString*)imgString
{
    if (_iconView) {
        _iconView.image = [[UIImage imageNamed:imgString] resizableImage];
    }
}

- (void)setNormalBg:(NSString*)normalBg
{
    self.bgView.image = [[UIImage imageNamed:normalBg] resizableImage];
}

- (void)setHighlightBg:(NSString*)highlightBg
{
    self.bgView.highlightedImage = [[UIImage imageNamed:highlightBg] resizableImage];
}

- (void)resetUI
{
    _bgView.width = self.width;

    if (_iconView.hidden) {
        [_titleLabel sizeToFit];
        _titleLabel.centerX = self.width / 2;
    }
    else {
        [_titleLabel sizeToFit];
        float contentWidth = _iconView.width + 6 + _titleLabel.width;
        _iconView.left = (self.width - contentWidth) / 2;
        _titleLabel.left = _iconView.right + 6;
    }
    _iconView.centerY = self.height / 2;
    _titleLabel.centerY = self.height / 2;
}

@end
