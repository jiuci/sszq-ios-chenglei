//
//  BYMaterial.m
//  IBY
//
//  Created by St on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYMaterial.h"

@implementation BYMaterial

- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{
        @"def_type_id" : @"def_type_id",
        @"material_id" : @"material_id",
        @"component_id" : @"component_id",
        @"name" : @"name",
        @"def_name" : @"def_name",
        @"image_url" : @"image_url",
        @"image_url_120_120" : @"image_url_120_120",
        @"image_url_50_50" : @"image_url_50_50",
        @"mask_image" : @"mask_image",
        @"material_name" : @"material_name",
        @"material_price" : @"material_price",
        @"material_romance_list_url" : @"material_romance_list_url",
        @"material_romance_url" : @"material_romance_url",
        @"material_unit" : @"material_unit",
        @"material_unit_percent" : @"material_unit_percent",
        @"category_id" : @"category_id",
        @"material_texture_id" : @"material_texture_id",
        @"material_source_price" : @"material_source_price",
        @"introduction" : @"intro",
    };
}

@end
