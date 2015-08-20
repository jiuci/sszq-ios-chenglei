//
//  BYPrice.m
//  IBY
//
//  Created by coco on 14-9-23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYPrice.h"

@implementation BYPrice
- (id)initWithPriceDict:(NSDictionary*)dict
{
    self = [super init];

    if (self) {

        _order_pay_code = dict[@"order_pay_code"];
        _paid_price = [dict[@"paid_price"] doubleValue];
        _paid_time = dict[@"paid_time"];
        _payment_type = [dict[@"payment_type"] stringValue];
        _real_price = [dict[@"real_price"] doubleValue];
        _transferPrice = [dict[@"transfer_price"] doubleValue];
    }
    return self;
}

@end
