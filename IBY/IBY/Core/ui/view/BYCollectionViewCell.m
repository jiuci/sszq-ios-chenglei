//
//  BYCollectionViewCell.m
//  IBY
//
//  Created by panshiyu on 14/12/9.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYCollectionViewCell.h"

@implementation BYCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
}

@end
