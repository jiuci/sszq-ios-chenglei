//
//  BYHomeInfoSimple.m
//  IBY
//
//  Created by kangjian on 15/8/19.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYHomeInfoSimple.h"

@implementation BYHomeInfoSimple

- (BOOL)isValid
{
    if (!_imagePath||_imagePath.length == 0) {
        return NO;
    }
    if (!_link||_link.length == 0) {
        return NO;
    }
    return YES;
}

@end
