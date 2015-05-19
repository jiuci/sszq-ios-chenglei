//
//  BYBusinessIntroduction.m
//  IBY
//
//  Created by panshiyu on 14/11/11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBusinessIntroduction.h"

@implementation BYBusinessIntroduction
- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{
             @"store_name" : @"_store_name",
             @"servicesTel" : @"_ServicesTel",
             @"oem_info" : @"_OEM_info",
             @"storeDesc" : @"_StoreDesc",
             @"logo_url":@"_logo_url",
             @"store_logo_url":@"_store_logo_url"
             };
}

@end
