//
//  BYMineCell.h
//  IBY
//
//  Created by panshiyu on 14/12/28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseCell.h"

@interface BYMineCell : BYBaseCell

+ (instancetype)cellWithTitle:(NSString*)title
                         icon:(NSString*)icon
                       target:(id)target
                          sel:(SEL)selector;

@end
