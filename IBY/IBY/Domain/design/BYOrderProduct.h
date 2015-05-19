//
//  BYOrderProduct.h
//  IBY
//
//  Created by coco on 14-9-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYOrderProduct : NSObject
/*
 "121409183136419": [
 {
 "detail_id": 172,
 "hasAcceptanceInProgress": false,
 "size_name": "78",
 "supplier_id": 1,
 }
 ]
 */

/** 创建人：create_by*/
@property (nonatomic, copy) NSString *create_by;
/** 订单号：order_id*/
@property (nonatomic, copy) NSString *order_id;

/** 创建时间：create_time*/
@property (nonatomic, copy) NSString *create_time;

/** 分类ID：design_category_id*/
@property (nonatomic, assign) int *design_category_id;
/** 分类名：design_category_name*/
@property (nonatomic, copy) NSString *design_category_name;
/** 设计id：design_id*/
@property (nonatomic, assign) int *design_id;
/** 设计名：design_name*/
@property (nonatomic, copy) NSString *design_name;

/** 模型id：model_id*/
@property (nonatomic, assign) int *model_id;

/** 包装类型：package_type*/
@property (nonatomic, copy) NSString *package_type;

/** 图片：image_url_218*/
@property (nonatomic, copy) NSString *image_url_218;
/** 图片：image_url_50*/
@property (nonatomic, copy) NSString *image_url_50;
/** 图片：img_background_color*/
@property (nonatomic, copy) NSString *img_background_color;
/** 图片：img_url*/
@property (nonatomic, copy) NSString *img_url;


/** 原始价格*/
@property (nonatomic, assign) int original_price;
/** 价格：price */
@property (nonatomic, assign) int price;


@end
