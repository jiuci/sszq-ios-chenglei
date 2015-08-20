//
//  BYAddressSelectCell.m
//  IBY
//
//  Created by St on 15/1/7.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYAddressSelectCell.h"

@interface BYAddressSelectCell ()

@property (nonatomic, strong) UIImageView* selectedView;
@property (nonatomic, strong) UILabel* titleLabel;

@end

@implementation BYAddressSelectCell

- (void)setupUI
{
    _selectedView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 20, 20)];
    _selectedView.image = [[UIImage imageNamed:@"icon_address_default"] resizableImage];
    [self addSubview:_selectedView];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_selectedView.right + 16, 0, 200, 44)];
    _titleLabel.textColor = BYColor333;
    [_titleLabel setFont:Font(14)];
    [self addSubview:_titleLabel];

    UIImageView* lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 270, 1)];
    lineView.image = [UIImage imageNamed:@"line_common"];
    [self addSubview:lineView];
}

- (void)updateTitle:(NSString*)title
{
    _titleLabel.text = title;
}

- (void)isSelected:(BOOL)isSelected
{
    if (isSelected) {
        _selectedView.image = [[UIImage imageNamed:@"icon_address_selected"] resizableImage];
    }
    else {
        _selectedView.image = [[UIImage imageNamed:@"icon_address_default"] resizableImage];
    }
}


@end
