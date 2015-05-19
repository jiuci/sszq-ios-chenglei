//
//  BYFCodeService.h
//  IBY
//
//  Created by panshiyu on 15/3/3.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYFCodeService : BYBaseService

+ (void)verifyFCode:(NSString*)fcode finish:(void (^)(BOOL success, BOOL needRevokeFCode, BYError* error))finished;

@end

BOOL isFCodeError(BYError* error);
