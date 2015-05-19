//
//  BYCustomButton.h
//  IBY
//
//  Created by panshiyu on 14/12/22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

//这里的button必须有icon和title，并且是icon和title以间距12居中的
@interface BYCustomButton : UIControl

@property (nonatomic, strong, readonly) UILabel* titleLabel;
@property (nonatomic, strong, readonly) UIImageView* iconView;
@property (nonatomic, strong, readonly) UIImageView* bgView;

+ (instancetype)btnWithFrame:(CGRect)frame
                        icon:(NSString*)icon
                       title:(NSString*)title
                   titleFont:(UIFont*)font
                  titleColor:(UIColor*)color;

- (void)setNormalBg:(NSString*)normalBg;
- (void)setHighlightBg:(NSString*)highlightBg;

- (void)updateIconImg:(NSString*)imgString;
- (void)resetUI;
@end
