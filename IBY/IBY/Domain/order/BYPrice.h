//
//  BYPrice.h
//  IBY
//
//  Created by coco on 14-9-23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//  订单中的价格模型

#import <Foundation/Foundation.h>
/*
 "order_price": {
 "bank_id": "",
 "create_by": "26",
 "create_time": "2014-09-18 13:37:29",
 "get_point_price": 0,
 "lose_point_price": 0,
 "order_id": 121409183136419,
 "order_pay_code": "121409192926275",
 "paid_price": 1100,
 "paid_time": "2014-09-19 11:24:35",
 "payment_type": 1,
 "price": 1100,
 "real_price": 1100,
 "supplier_id": 1,
 "transfer_price": 0,
 "update_by": "26",
 "update_time": "2014-09-19 11:24:35"
 */
@interface BYPrice : NSObject

/** 支付码：order_pay_code*/
@property (nonatomic, copy) NSString* order_pay_code;
/** 支付价格：paid_price*/
@property (nonatomic, assign) double paid_price;
/** 支付时间：paid_time*/
@property (nonatomic, copy) NSString* paid_time;
/** 支付类型：payment_type*/
@property (nonatomic, copy) NSString* payment_type;
/** 真实价格：real_price*/
@property (nonatomic, assign) double real_price;
//运费
@property (nonatomic, assign) double transferPrice;

- (id)initWithPriceDict:(NSDictionary*)dict;
@end
