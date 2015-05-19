//
//  BYProcessView.m
//  IBY
//
//  Created by panshiyu on 15/1/6.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYProcessView.h"

@implementation BYProcessView {
    UIView* _frontView;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _frontView = [[UIView alloc] initWithFrame:BYRectMake(0, 0, self.width, self.height)];
    _frontView.backgroundColor = [UIColor clearColor];
    [self addSubview:_frontView];
}

- (void)updateWithValue:(CGFloat)value
{
    self.backgroundColor = _bgColor;
    _frontView.backgroundColor = _frontColor;

    _frontView.width = self.width * value;
}

@end
