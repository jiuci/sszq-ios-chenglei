//
//  BYProcessView.h
//  IBY
//
//  Created by panshiyu on 15/1/6.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYProcessView : UIView

@property (nonatomic, strong) UIColor* bgColor;
@property (nonatomic, strong) UIColor* frontColor;

- (void)updateWithValue:(CGFloat)value;

@end

