//
//  BYCart.m
//  IBY
//
//  Created by panshiyu on 14-10-17.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYCart.h"
#import "MJExtension.h"

@implementation BYCart

+ (NSDictionary*)JSONKeyPathsByPropertyKey
{
    return @{
        @"designName" : @"designName",
        @"designName" : @"designName",
        @"imgUrl" : @"imgUrl",
        @"imgUrl50" : @"img_url_50",
        @"price" : @"price",
        @"allPrice" : @"allPrice",
        @"sizeDesc" : @"size",
        @"transferDelayDay" : @"transferDelayDay"
    };
}

- (void)updateSizeList:(NSArray*)sizeArray
{
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* obj in sizeArray) {
        BYSize* size = [BYSize objectWithKeyValues:obj];
        [array addObject:size];
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    for (BYSize* size in array) {
        NSMutableArray* tempArray = [dict objectForKey:size.name];
        if (!tempArray) {
            tempArray = [NSMutableArray arrayWithObject:size];
            [dict setObject:tempArray forKey:size.name];
        }
        else {
            [tempArray addObject:size];
        }
    }
    if (!_sizeDict) {
        _sizeDict = [NSMutableDictionary dictionary];
    }
    _sizeDict = [NSMutableDictionary dictionaryWithDictionary:dict];

    if (!_sizeList) {
        _sizeList = [NSArray array];
    }
    _sizeList = [NSArray arrayWithArray:array];
}

@end

@implementation BYSize

- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{
        @"sizeId" : @"id",
        @"enable" : @"enable",
        @"createBy" : @"create_by",
        @"createTime" : @"create_time",
        @"goodsSize" : @"goods_size",
        @"modelId" : @"model_id",
        @"name" : @"name",
        @"updateby" : @"update_by",
        @"updateTime" : @"update_time",
        @"unit" : @"unit",
    };
}

@end
