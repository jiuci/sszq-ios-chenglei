//
//  BYExpress.m
//  IBY
//
//  Created by panshiyu on 14/11/28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYExpress.h"

@implementation BYExpress

- (id)initWithDictionary:(NSDictionary*)data
{
    self = [super init];
    if (self) {
        self.expressType_id = [data[@"expresstype_id"] intValue];
        self.expresstype_name = data[@"expresstype_name"];
        self.nextWeight = [data[@"nextWeight"] doubleValue];
        self.nextprice = [data[@"nextprice"] doubleValue];
        self.price = [data[@"price"] doubleValue];
        self.supplierId = [data[@"supplierId"] intValue];
        self.weight = [data[@"weight"] doubleValue];
        self.weight = [data[@"weight"] doubleValue];
        self.actualExpressTotalPrice = [data[@"actualExpressTotalPrice"] doubleValue];
    }
    return self;
}
@end
