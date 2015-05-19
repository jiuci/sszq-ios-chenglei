//
//  BYMaterial.h
//  IBY
//
//  Created by St on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYMaterial : NSObject

@property (nonatomic, assign) int def_type_id;
@property (nonatomic, assign) int material_id;
@property (nonatomic, assign) int component_id;
@property (nonatomic, assign) int category_id;
@property (nonatomic, assign) int material_texture_id;

@property (nonatomic, copy) NSString* introduction; //材料介绍
@property (nonatomic, copy) NSString* name; //材质类型名称,用于材质的分组
@property (nonatomic, copy) NSString* def_name; //是什么材质
@property (nonatomic, copy) NSString* image_url;
@property (nonatomic, copy) NSString* image_url_120_120;
@property (nonatomic, copy) NSString* image_url_50_50;
@property (nonatomic, copy) NSString* mask_image;
@property (nonatomic, copy) NSString* material_name;
@property (nonatomic, assign) float material_price;
@property (nonatomic, copy) NSString* material_romance_list_url;
@property (nonatomic, copy) NSString* material_romance_url;

@property (nonatomic, assign) int material_source_price;
@property (nonatomic, copy) NSString* material_unit; //尺寸单位
@property (nonatomic, assign) float material_unit_percent; //材料使用率？ 损耗率？

@end
