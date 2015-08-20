//
//  BYDesign.m
//  IBY
//
//  Created by coco on 14-9-11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYDesign.h"
#import "MJExtension.h"
#import "BYModel.h"
@implementation BYDesign

- (id)initWithMyDesignDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        _designId = [dict[@"designid"] intValue];
        _categoryId = [dict[@"categoryid"] intValue];
        _imageUrl = dict[@"fixSrc"];
        _designName = dict[@"shareTitle"];
        _createTime = dict[@"createTime"];
    }

    return self;
}

- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{
        @"categoryId" : @"category_id",
        @"categoryName" : @"category_name",
        @"designCategoryId" : @"design_category_id",
        @"customerId" : @"customer_id",
        @"desc" : @"design_descption",
        @"designId" : @"design_id",
        @"designName" : @"design_name",
        @"imageUrl" : @"img_url",
        @"createTime" : @"createTime",
        @"styleId" : @"style_id",
    };
}

+ (NSDictionary*)JSONKeyPathsByPropertyKey
{
    return @{
        @"categoryId" : @"category_id",
        @"categoryName" : @"category_name",
        @"designCategoryId" : @"design_category_id",
        @"customerId" : @"customer_id",
        @"desc" : @"design_descption",
        @"designId" : @"design_id",
        @"designName" : @"design_name",
        @"imageUrl" : @"img_url",
        @"createTime" : @"createTime",
        @"styleId" : @"style_id",
    };
}

- (NSDictionary*)displaySizeMap
{
    if (_sizeList.count > 0) {
        return [_sizeList organizedMapWithKeynameBlock:^NSString * (BYDesignSize * obj) {
            return obj.sizeName;
        }];
    }
    return nil;
}

- (void)updateDetails:(NSDictionary*)dict
{
    _designDetails = dict[@"designDataDTO"][@"design_details"];
    _refDesignList = [BYDesign mtlObjectsWithKeyValueslist:dict[@"designReferences"]];
    _sizeList = [BYDesignSize objectArrayWithKeyValuesArray:dict[@"sizeList"]];
    _supplier_id = [[dict[@"modelInfo"] objectForKey:@"supplier_id"] intValue];
    _modelInfo = [BYModel mtlObjectWithKeyValues:dict[@"modelInfo"]];

    if ([dict[@"cutSmallDesignImage"] isKindOfClass:[NSDictionary class]]) {
        _cutImgUrls = [[dict[@"cutSmallDesignImage"] bk_map:^id(NSDictionary* obj) {
            return obj[@"imageUrl"];
        }] mutableCopy];
    }
}

@end

@implementation BYDesignSize

- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{
        @"sizeId" : @"id",
        @"goods_size" : @"goods_size",
        @"sizeName" : @"name",
    };
}

@end
