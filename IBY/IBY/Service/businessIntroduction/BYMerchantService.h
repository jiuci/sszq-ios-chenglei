//
//  BYBusinessIntroductionService.h
//  IBY
//
//  Created by panshiyu on 14/11/11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYMerchantService : BYBaseService

- (void)loadMerchantInfo:(int)supplierid
                  finish:(void (^)(NSDictionary* data, BYError* error))finished;
@end
