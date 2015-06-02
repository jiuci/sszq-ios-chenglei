//
//  BYLoginMenu.m
//  IBY
//
//  Created by panshiyu on 14/12/23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYLoginMenu.h"

@implementation BYLoginMenu

+ (instancetype)loginMenu
{
    BYLoginMenu* instance = [[[NSBundle mainBundle] loadNibNamed:@"BYLoginMenu" owner:nil options:nil] lastObject];
    instance.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    return instance;
}

@end
