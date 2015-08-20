//
//  BYOrder.m
//  IBY
//
//  Created by coco on 14-9-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYOrder.h"
#import "BYMerchant.h"
#import "BYAddress.h"
#import "BYOrderProduct.h"
#import "BYPrice.h"

@implementation BYOrder

- (id)initWithData:(NSDictionary*)data
{
    self = [super init];

    if (self) {
        if (data[@"orderList"][@"order_express"]) {
            _express = [data[@"orderList"][@"order_express"] mutableCopy];
        }

        NSString* createTimeString = (NSString*)data[@"orderList"][@"order_base"][@"create_time"];
        createTimeString = [createTimeString substringToIndex:10];
        _createTime = createTimeString;
        _orderPrice = [data[@"orderList"][@"order_price"][@"real_price"] doubleValue];
        _supplierName = data[@"orderList"][@"supplier_store"][@"_store_name"];
        NSMutableArray* array = data[@"orderDetailInfoList"][@"orderContent"];

        if ([array count] > 0) {
            _picUrl = array[0][@"img_url"];
        }

        _orderId = [NSString stringWithFormat:@"%@", data[@"orderDetailInfoList"][@"orderId"]];

        _goodsQuantity = 0;
        for (NSDictionary* dict in array) {
            _goodsQuantity += [dict[@"quantity"] intValue];
        }
        _orderStatus = [data[@"orderList"][@"order_base"][@"order_status"] intValue];
        //_orderId = data[@"orderList"][@"order_base"][@"order_id"];

        if (data[@"order_base"][@"pay_start_time"]) {
            _payStartTime = [NSDate dateWithTimeIntervalSince1970:[data[@"order_base"][@"pay_start_time"] longLongValue]];
        }

        if (data[@"order_base"][@"pay_end_time"]) {
            _payEndTime = [NSDate dateWithTimeIntervalSince1970:[data[@"order_base"][@"pay_end_time"] longLongValue]];
        }
    }
    return self;
}

- (id)initWithDetailData:(NSDictionary*)data
{
    self = [super init];

    if (self) {
        _productionCircle = 0;
        _orderDetailList = data[@"orderDetailList"];
        _orderPrice = [data[@"order"][@"order_price"][@"real_price"] doubleValue];
        _productPrice = [data[@"order"][@"order_price"][@"price"] doubleValue];
        _transferPrice = [data[@"order"][@"order_price"][@"transfer_price"] doubleValue];
        _packagePrice = 0;

        [_orderDetailList bk_each:^(NSDictionary* obj) {
            //解析订单中的每一件商品的信息
            _packagePrice += [obj[@"package_price"] doubleValue];
            _acceptanceId = [obj[@"acceptance_id"] intValue];
            _acceptanceStatus = [obj[@"acceptance_status"] intValue];
            _canReturn = [obj[@"canReturn"] boolValue];
            _createBy = obj[@"create_by"];
            _createTime = obj[@"create_time"];
            _designCategoryId = [obj[@"design_category_id"] intValue];
            _designCategoryName = obj[@"design_category_name"];
            _designId = [obj[@"design_id"] intValue];
            _designName = obj[@"design_name"];
            _detailId = [obj[@"detail_id"] intValue];
            _hasAbnormal = [obj[@"hasAbnormal"] boolValue];
            _orderId = [NSString stringWithFormat:@"%@",obj[@"order_id"]];
            _originalPrice = [obj[@"original_price"] doubleValue];
            _packagePic = obj[@"package_pic"];
            _packagePrice = [obj[@"package_price"] doubleValue];
            _packageType = obj[@"package_type"];
            _sizeName = obj[@"size_name"];
            _supplierId = [obj[@"supplier_id"] intValue];
            if(_productionCircle < [obj[@"durations"] intValue]){
                _productionCircle = [obj[@"durations"] intValue];
            }
        }];

        NSDictionary* orderInfo = data[@"order"];
        _orderInfo = orderInfo;
        //NSDictionary* businessInfo = orderInfo[@"supplier_store"];
        NSDictionary* storeInfo = @{ @"supplierInfo" : orderInfo[@"supplier_info"],
                                     @"supplierStore" : orderInfo[@"supplier_store"] };
        _business = [[BYMerchant alloc] initWithMerchantDict:storeInfo];
        NSDictionary* priceInfo = orderInfo[@"order_price"];
        _price = [[BYPrice alloc] initWithPriceDict:priceInfo];
        NSDictionary* addressInfo = orderInfo[@"order_express"];
        _address = [[BYAddress alloc] initWithAddressDict:addressInfo];
        _express = addressInfo;

        if (orderInfo[@"order_base"][@"pay_start_time"]) {
            _payStartTime = [NSDate dateWithTimeIntervalSince1970:[orderInfo[@"order_base"][@"pay_start_time"] longLongValue] / 1000];
        }

        if (orderInfo[@"order_base"][@"pay_end_time"]) {
            _payEndTime = [NSDate dateWithTimeIntervalSince1970:[orderInfo[@"order_base"][@"pay_end_time"] longLongValue] / 1000];
        }
    }

    return self;
}

- (void)setBusiness:(BYMerchant*)business
{
    _business = business;
}
- (void)setAddress:(BYAddress*)address
{
    _address = address;
}

- (void)setOrderProduct:(BYOrderProduct*)orderProduct
{
    _orderProduct = orderProduct;
}

- (void)setPrice:(BYPrice*)price
{
    _price = price;
}

//确认订单页的商品的数据
- (id)initWithConfirmOrderData:(NSDictionary*)obj
{
    self = [super init];
    if (self) {

        _orderPrice = [obj[@"allPrice"] doubleValue];
        _designName = obj[@"designName"];
        _orderProduct.img_url = obj[@"imgUrl"];
        _orderProduct.img_background_color = obj[@"img_background_color"];
        _orderProduct.image_url_50 = obj[@"img_url_50"];
        _packagePrice = [obj[@"packagePrice"] doubleValue];
        _packageType = obj[@"packageType"];
        _packagePic = obj[@"package_pic"];
        _createBy = obj[@"shopCar"][@"createBy"];
        _createTime = obj[@"shopCar"][@"createTime"];
        _designId = [obj[@"shopCar"][@"designId"] intValue];
        _supplierId = [obj[@"shopCar"][@"supplierId"] intValue];
        _sizeId = [obj[@"shopCar"][@"sizeId"] intValue];
        _sizeName = obj[@"shopCar"][@"sizeName"];
        _num = [obj[@"shopCar"][@"num"] intValue];
        _shopCarId = [obj[@"shopCar"][@"shopCarId"] intValue];
    }
    return self;
}
@end

NSString* OrderStatusDescByType(BYOrderStatus status)
{
    NSArray* desc = @[ @"",
                       @"待付款",
                       @"已付款",
                       @"生产中",
                       @"待收货",
                       @"待评价",
                       @"已取消",
                       @"已成功",
    ];
    if (status < 0 || status > 7) {
        return @"";
    }
    return desc[status];
}
