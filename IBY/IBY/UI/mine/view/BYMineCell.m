//
//  BYMineCell.m
//  IBY
//
//  Created by panshiyu on 14/12/28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYMineCell.h"

@interface BYMineCell ()
//@property (nonatomic, strong) UILabel* titleLabel;
//@property (nonatomic, strong) UIImageView* iconView;
@end

@implementation BYMineCell

+ (instancetype)cellWithTitle:(NSString*)title
                         icon:(NSString*)icon
                       target:(id)target
                          sel:(SEL)selector
{
    BYMineCell* cell = [[self alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, 44)];
    cell.titleLabel.text = title;
    if (icon) {
        cell.iconView.image = [UIImage imageNamed:icon];
    }else{
        cell.titleLabel.left -= cell.iconView.width;
    }
    [cell addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
  
    return cell;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _iconView = [[UIImageView alloc] initWithFrame:BYRectMake(12, 0, 20, 20)];
        _iconView.centerY = self.height / 2;
        [self addSubview:_iconView];
        
        
        _titleLabel = [UILabel labelWithFrame:BYRectMake(47, 0, 200, 44) font:Font(14) andTextColor:BYColor333];
        [self addSubview:_titleLabel];

        
//        self.showRightArrow = YES;
        self.showBottomLine = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [HEXACOLOR(0x000000, .12) CGColor];
        self.layer.shadowOpacity = .5;
        self.layer.shadowOffset = CGSizeMake(0.0f, .5f);
    }
    return self;
}

@end
