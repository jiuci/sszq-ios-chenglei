//
//  BYLinearComponent.m
//  IBY
//
//  Created by panShiyu on 14/12/5.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYLinearItem.h"

@implementation BYLinearItem

- (id)initWithView:(UIView*)aView paddingTop:(float)top paddingBottom:(float)bottom
{
    self = [super init];
    if (self) {
        _view = aView;
        _paddingTop = top;
        _paddingBottom = bottom;
    }
    return self;
}

@end
