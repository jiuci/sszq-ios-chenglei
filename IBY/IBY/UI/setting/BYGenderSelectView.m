//
//  BYGenderSelectView.m
//  IBY
//
//  Created by kangjian on 15/8/5.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYGenderSelectView.h"
@interface BYGenderSelectView ()
@property (nonatomic, strong) UILabel* titlelabel;

@property (nonatomic, copy) NSString* title;
@property (nonatomic, assign) NSInteger selectedNum;

@end
@implementation BYGenderSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.selectedNum = 0;
        
        UIView * back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * .6, 160)];
        [self addSubview:back];
        back.centerX = self.width / 2;
        back.centerY = self.height * .3;
        back.backgroundColor = BYColorWhite;
        back.layer.cornerRadius = 5;
        back.layer.masksToBounds = YES;
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, back.width, 39)];
        [back addSubview:title];
        title.text = @"选择性别";
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = BYColorb768;
        title.textAlignment = NSTextAlignmentCenter;
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, back.width, 1)];
        line1.backgroundColor = BYColorb768;
        [back addSubview:line1];
        
        UIButton * male =[UIButton buttonWithType:UIButtonTypeCustom];
        male.frame = CGRectMake(0, 40, back.width, 40);
        [male setTitle:@"男" forState:UIControlStateNormal];
        male.titleLabel.font = [UIFont systemFontOfSize:14];
        [male setTitleColor:BYColor333 forState:UIControlStateNormal];
        [back addSubview:male];
        [male addTarget:_delegate action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 80, back.width - 22, .5)];
        line2.centerX = back.width / 2;
        line2.backgroundColor = [UIColor grayColor];
        [back addSubview:line2];
        
        UIButton * famale =[UIButton buttonWithType:UIButtonTypeCustom];
        famale.frame = CGRectMake(0, 80, back.width, 40);
        [famale setTitle:@"女" forState:UIControlStateNormal];
        famale.titleLabel.font = [UIFont systemFontOfSize:14];
        [famale setTitleColor:BYColor333 forState:UIControlStateNormal];
        [back addSubview:famale];
        [famale addTarget:_delegate action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 120, back.width - 22, .5)];
        line3.centerX = back.width / 2;
        line3.backgroundColor = [UIColor grayColor];
        [back addSubview:line3];
        
        UIButton * secret =[UIButton buttonWithType:UIButtonTypeCustom];
        secret.frame = CGRectMake(0, 120, back.width, 40);
        [secret setTitle:@"保密" forState:UIControlStateNormal];
        secret.titleLabel.font = [UIFont systemFontOfSize:14];
        [secret setTitleColor:BYColor333 forState:UIControlStateNormal];
        [back addSubview:secret];
        [secret addTarget:_delegate action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.autoHideWhenTapBg = YES;
    }
    
    return self;
}
@end
