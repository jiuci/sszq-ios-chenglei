//
//  BYDelivery.m
//  IBY
//
//  Created by panshiyu on 14/12/30.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYDelivery.h"

@implementation BYDelivery

@end

NSString* deliveryTimeDescByType(BYDeliveryTime type)
{
    NSString* str = nil;
    switch (type) {
    case BYDeliveryTimeAll:
        str = @"工作日、节假日均可送货";
        break;
    case BYDeliveryTimeWeekendOnly:
        str = @"只双休日、假日送货";
        break;
    case BYDeliveryTimeWorkOnly:
        str = @"只工作日送货";
        break;
    default:
        break;
    }
    return str;
}
