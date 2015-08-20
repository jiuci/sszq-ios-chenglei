//
//  BYAddBookUnit.m
//  IBY
//
//  Created by panshiyu on 15/3/11.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYAddBookUnit.h"

@implementation BYAddBookUnit

- (BOOL)isValid
{
    if (_designId != 0 && _num > 0 && _sizeName) {
        return YES;
    }
    return NO;
}

@end
