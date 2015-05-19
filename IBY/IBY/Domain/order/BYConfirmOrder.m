//
//  BYConfirmOrder.m
//  IBY
//
//  Created by panshiyu on 14/11/28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYConfirmOrder.h"

@implementation BYConfirmOrder

- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{
             @"designName" : @"designName",
             @"imgUrl" : @"imgUrl",
             @"imgUrl50" : @"img_url_50",
             @"price" : @"price",
             @"sizeDesc" : @"size",
             @"transferDelayDay" : @"transferDelayDay",
             };
}
@end
