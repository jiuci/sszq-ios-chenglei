//
//  BYCartParams.m
//  IBY
//
//  Created by panshiyu on 14-10-17.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYCartParams.h"

@implementation BYCartParamsAdd

+ (instancetype)defaultCartAddParams
{
    BYCartParamsAdd* cartParams = [[BYCartParamsAdd alloc] init];
    cartParams.payStatus = 0;
    return cartParams;
}

- (BOOL)isValid
{
    if (_designId != 0 && _sizeName && _supplierId != 0 && _modelId != 0 && _num > 0) {
        return YES;
    }
    return NO;
}

@end
