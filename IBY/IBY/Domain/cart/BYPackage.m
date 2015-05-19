//
//  BYPackage.m
//  IBY
//
//  Created by panshiyu on 14-10-28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYPackage.h"

@implementation BYPackage

- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{
        @"productPackageId" : @"productPackageId",
        @"desc" : @"description",
        @"picName" : @"picName",
        @"isDefault" : @"isDefault",
        @"price" : @"price"
    };
}

@end
