//
//  BYNumberTip.m
//  IBY
//
//  Created by kangjian on 15/8/3.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYNumberTip.h"
@interface BYNumberTip ()
@property (nonatomic, strong) UILabel * numberLabel;
@end
@implementation BYNumberTip

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)numberTipwithFrame:(CGRect)rect inView:(UIView *)backView
{
    BYNumberTip * tip =[[BYNumberTip alloc]initWithFrame:rect];
    [backView addSubview:tip];
    tip.number = 0;
    tip.top = 5;
    tip.centerX = backView.width / 2 + 10;

    [tip setupUI];
    return tip;
}

- (void)setupUI
{
    UIImageView * backGround = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.width, self.height)];
    
    backGround.image = [UIImage imageNamed:@"bg_new_superscript"];
    [self addSubview:backGround];
//    _numberLabel = [[UILabel alloc]init];
//    _numberLabel.adjustsFontSizeToFitWidth = YES;
//    [self addSubview:_numberLabel];
//    _numberLabel.center = CGPointMake(self.width / 2, self.height / 2);
//    _numberLabel.font = [UIFont systemFontOfSize:8];
//    _numberLabel.textColor = HEXCOLOR(0xb08fb1);
    
    
}
- (void)setNumber:(int)number
{
    _number = number;
    if (_number == 0) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
//    if (_number < 100 && _number > 0) {
//        _numberLabel.text = [NSString stringWithFormat:@"%d",number];
//    }else{
//        _numberLabel.text = @"...";
//    }
    
}
@end
