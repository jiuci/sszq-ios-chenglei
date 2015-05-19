//
//  BYBarButtonItem.m
//  IBY
//
//  Created by panShiyu on 14/11/24.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBarButtonItem.h"

@implementation BYBarButtonItem

- (id)initWithCustomView:(UIView*)customView
{
    self = [super initWithCustomView:customView];
    if (self) {
        if ([customView isKindOfClass:[UIButton class]]) {
            _contentBtn = (UIButton*)customView;
        }
    }
    return self;
}

@end
