//
//  BYComponent.m
//  IBY
//
//  Created by St on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYComponent.h"
#import "BYMaterial.h"

@implementation BYComponent

- (NSMutableArray*)materialList
{
    if (!_materialList) {
        _materialList = [NSMutableArray array];
    }
    return _materialList;
}

- (NSArray*)displayMaterialList
{
    NSMutableDictionary* storeDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < _materialList.count; i++) {
        BYMaterial* material = _materialList[i];
        NSMutableArray* storeArray = storeDict[material.name];
        if (!storeArray) {
            storeArray = [NSMutableArray array];
            [storeArray addObject:material];
            [storeDict setObject:storeArray forKey:material.name];
        }
        else {
            [storeArray addObject:material];
            [storeDict setObject:storeArray forKey:material.name];
        }
    }
    return [[storeDict allValues] copy];
}

- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{
        @"component_id" : @"component_id",
        @"component_order" : @"component_order",
        @"component_type" : @"component_type",
        @"component_status" : @"component_status",
        @"model_id" : @"model_id",
        @"component_name" : @"component_name",
        @"customname" : @"customname"
    };
}

@end
