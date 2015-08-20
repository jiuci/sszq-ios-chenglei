//
//  UILabelExtend.m
//  IBY
//
//  Created by panshiyu on 15/2/27.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "UILabelExtend.h"

@implementation UILabel (helper)

+ (instancetype)labelWithFrame:(CGRect)frame font:(UIFont*)font andTextColor:(UIColor*)textColor
{

    UILabel* label = [[self alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    if (textColor) {
        label.textColor = textColor;
    }

    return label;
}

@end