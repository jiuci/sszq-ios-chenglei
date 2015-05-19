//
//  BYBusinessIntroductionService.m
//  IBY
//
//  Created by panshiyu on 14/11/11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYMerchantService.h"
#import "BYMerchant.h"

@implementation BYMerchantService

- (void)loadMerchantInfo:(int)supplierid
                  finish:(void (^)(NSDictionary* data, BYError* error))finished
{
    NSDictionary* params = @{
        @"supplierid" : @(supplierid)
    };
    [BYNetwork get:@"supplier/GetSupplierStore" params:params finish:^(NSDictionary* data, BYError* error) {
//        BYMerchant *merchant = [BYMerchant ]
        if (data) {
            finished(data,nil);
        }else{
            finished(nil,error);
        }
    }];
}
@end
