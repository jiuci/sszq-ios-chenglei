//
//  BYAutosizeBgButton.m
//  IBY
//
//  Created by panshiyu on 14/12/23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYAutosizeBgButton.h"

@implementation BYAutosizeBgButton

- (void)awakeFromNib
{
    [super awakeFromNib];

    NSCAssert(self.buttonType == UIButtonTypeCustom, @"BYAutosizeBgButton只支持UIButtonTypeCustom，其他类型会导致非正常态失真");

    UIImage* normalImg = [self backgroundImageForState:UIControlStateNormal];
    if (normalImg) {
        [self setBackgroundImage:[normalImg resizableImage] forState:UIControlStateNormal];
    }

    UIImage* hlImg = [self backgroundImageForState:UIControlStateHighlighted];
    if (hlImg) {
        [self setBackgroundImage:[hlImg resizableImage] forState:UIControlStateHighlighted];
    }

    UIImage* selectecImg = [self backgroundImageForState:UIControlStateSelected];
    if (selectecImg) {
        [self setBackgroundImage:[selectecImg resizableImage] forState:UIControlStateSelected];
    }

    UIImage* disableImg = [self backgroundImageForState:UIControlStateDisabled];
    if (disableImg) {
        [self setBackgroundImage:[disableImg resizableImage] forState:UIControlStateDisabled];
    }
}

@end
