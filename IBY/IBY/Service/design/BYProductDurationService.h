//
//  BYProductDurationService.h
//  IBY
//
//  Created by panshiyu on 14/12/30.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYProductDurationService : BYBaseService

+ (void)fetchProductDuration:(int)designId
                   finish:(void (^)(int duration, BYError* error))finished;

@end
