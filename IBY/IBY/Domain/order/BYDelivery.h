//
//  BYDelivery.h
//  IBY
//
//  Created by panshiyu on 14/12/30.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseDomain.h"

typedef enum {
    BYDeliveryTimeAll = 0,
    BYDeliveryTimeWorkOnly = 1,
    BYDeliveryTimeWeekendOnly = 2,
} BYDeliveryTime;

NSString* deliveryTimeDescByType(BYDeliveryTime type);

@interface BYDelivery : BYBaseDomain

@end
