//
//  BYBaseCell.h
//  IBY
//
//  Created by panShiyu on 14-9-15.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface BYBaseCell : UIControl

@property (nonatomic, strong) UIImage* highlightBg;
@property (nonatomic, strong) UIImage* normalBg;
@property (nonatomic, assign) BOOL showRightArrow;
@property (nonatomic, assign) BOOL showBottomLine;

@property (nonatomic, strong) UIImageView* bottomLine;

@end

@interface BYTitleCell : BYBaseCell

@property (nonatomic, strong) UILabel* keyLabel;
@property (nonatomic, strong) UILabel* valueLabel;
@property (nonatomic, strong) UILabel* descLabel; //用来扩展用

+ (instancetype)controlWithFrame:(CGRect)frame key:(NSString*)key
                           value:(NSString*)value;

@end
