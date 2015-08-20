//
//  BYNumberTip.h
//  IBY
//
//  Created by kangjian on 15/8/3.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYNumberTip : UIView

@property (nonatomic, assign)int number;
+ (instancetype)numberTipwithFrame:(CGRect)rect inView:(UIView *)backView;


@end
