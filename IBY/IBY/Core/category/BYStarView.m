//
//  BYStarView.m
//  IBY
//
//  Created by panshiyu on 14/11/10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYStarView.h"

@implementation BYStarView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _starView];
}
- (void)_starView
{
    UIImage* yellowImg = [UIImage imageNamed:@"icon_item_stars_full"];
    UIImage* grayImg = [UIImage imageNamed:@"icon_item_stars_empty"];

    //创建灰色星星
    _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, grayImg.size.width * 5, grayImg.size.height)];
    _grayView.backgroundColor = [UIColor colorWithPatternImage:grayImg];
    [self addSubview:_grayView];

    //创建黄色星星
    _yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, yellowImg.size.width * 5, yellowImg.size.height)];
    _yellowView.backgroundColor = [UIColor colorWithPatternImage:yellowImg];
    [self addSubview:_yellowView];

    self.backgroundColor = [UIColor clearColor];

    //设置当前视图的宽度为高度的5倍
    //    self.width = self.frame.size.height * 5;

    //放大或缩小星星
    //计算缩放的倍数
    CGFloat scale = self.frame.size.height / yellowImg.size.height;
    _grayView.transform = CGAffineTransformMakeScale(scale, scale);
    _yellowView.transform = CGAffineTransformMakeScale(scale, scale);

    _grayView.left = 0;
    _grayView.top = 0;
    _yellowView.left = 0;
    _yellowView.top = 0;
}

- (void)setRating:(CGFloat)rating
{
    _rating = rating;

    //计算分数的百分比
    CGFloat rate = rating / 5.0;

    //根据分数的百分比设置金色星星的宽度
    CGFloat width = rate * _grayView.width;
    _yellowView.width = width;
}

@end
