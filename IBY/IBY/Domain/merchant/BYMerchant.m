//
//  BYMerchant.m
//  IBY
//
//  Created by coco on 14-9-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYMerchant.h"

@implementation BYMerchant

- (id)initWithMerchantDict:(NSDictionary*)dict //订单详情里使用的 方法
{
    self = [super init];
    if (self) {
        //  @{ @"supplierInfo" : orderInfo[@"supplier_info"],
        //     @"supplierStore" : orderInfo[@"supplier_store"] };
        _merchantId = [dict[@"supplierStore"][@"_id"] stringValue];
        _merchantName = dict[@"supplierStore"][@"_store_name"];
        _merchantTel = dict[@"supplierInfo"][@"service_tel"];
        _serviceTime = dict[@"supplierInfo"][@"service_time"];
        _productGrade = dict[@"supplierStore"][@"productGrade"];
        _qualityGrade = dict[@"supplierStore"][@"qualityGrade"];
        _serviceGrade = dict[@"supplierStore"][@"serviceGrade"];
        _logoUrl = dict[@"supplierStore"][@"_logo_url"];
    }
    return self;
}

- (id)initWithMerchantInProductDetailBy:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        _merchantId = [dict[@"_id"] stringValue];
        _merchantName = dict[@"_store_name"];
        _merchantTel = dict[@"_ServicesTel"];
        _serviceTime = dict[@"_service_time"];
        _productGrade = dict[@"productGrade"];
        _qualityGrade = dict[@"qualityGrade"];
        _serviceGrade = dict[@"serviceGrade"];
        _logoUrl = dict[@"_logo_url"];
    }
    return self;
}

//确认订单的商家数据
- (id)initConfirmOrderMerchantDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {

        _merchantName = dict[@"supplierUserName"];
        _merchantId = dict[@"shopCar"][@"supplierId"];
    }
    return self;
}
@end
