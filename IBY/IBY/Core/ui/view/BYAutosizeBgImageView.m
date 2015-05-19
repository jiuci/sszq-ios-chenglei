//
//  BYAutosizeBgImageView.m
//  IBY
//
//  Created by panshiyu on 14/12/23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYAutosizeBgImageView.h"

@implementation BYAutosizeBgImageView

- (void)awakeFromNib
{
    [super awakeFromNib];

    UIImage* normalImg = self.image;
    if (normalImg) {
        [self setImage:[normalImg resizableImage]];
    }

    UIImage* hlImg = self.highlightedImage;
    if (hlImg) {
        [self setImage:[hlImg resizableImage]];
    }
}

@end
