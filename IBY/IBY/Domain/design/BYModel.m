//
//  BYModel.m
//  IBY
//
//  Created by St on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYModel.h"

@implementation BYModel

- (NSArray*)displayComponentList
{
    return nil;
}

- (NSMutableArray*)componentList
{
    if (!_componentList) {
        _componentList = [[NSMutableArray alloc] init];
    }
    return _componentList;
}

- (void)updateModel:(NSDictionary*)data
{
    _category_tree_id = [data[@"category_tree_id"] intValue];
    _model_id = [data[@"model_id"] intValue];
    _model_part_id = [data[@"model_part_id"] intValue];
    _model_style = [data[@"model_style"] intValue];
    _model_name = data[@"model_name"];
}

+ (NSDictionary*)JSONKeyPathsByPropertyKey
{
    return @{
        @"model_price" : @"model_price",
        @"category_tree_id" : @"category_tree_id",
        @"model_id" : @"model_id",
        @"model_part_id" : @"model_part_id",
        @"model_style" : @"model_style",
        @"model_name" : @"model_name",
        @"model_image_url" : @"model_image_url",
        @"descriptionUrl" : @"descriptionUrl",
        @"model_category_id" : @"model_category_id"
    };
}

//@"model_image_url" : @"model_image_url",

@end
