//
//  BYOrder.h
//  IBY
//
//  Created by coco on 14-9-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.

// 完整订单的模型

#import <Foundation/Foundation.h>
@class BYAddress, BYMerchant, BYOrderProduct, BYPrice;

//7种订单状态
typedef NS_ENUM(NSInteger, BYOrderStatus) {
    STATUS_All = 0,
    STATUS_UNPAY = 1, //未付款
    STATUS_PAIED = 2, //已付款
    STATUS_PRODUCING = 3, //生产中
    STATUS_DILIVER = 4, //已发货
    STATUS_UNCOMMENT = 5, //交易成功，未评价
    STATUS_CANCEL = 6, //已取消  交易关闭
    STATUS_COMPLETE = 7 //已成功; 交易完成已评价
};

NSString* OrderStatusDescByType(BYOrderStatus status);

typedef NS_ENUM(NSInteger, DeliverTime) {

    TIME_UNKNOW = -1,
    TIME_ALL = 0,
    TIME_WORK_ONLY = 1, //只工作日
    TIME_WEEKEND_ONLY = 2, //只周末、节假日
};

//4种配送时间
@interface BYOrder : NSObject
@property (nonatomic, copy) NSString* orderId;
@property (nonatomic, copy) NSString* createBy;
@property (nonatomic, copy) NSString* createTime;
@property (nonatomic, assign) int orderStatus;
@property (nonatomic, copy) NSString* supplierName;
@property (nonatomic, copy) NSString* picUrl;
@property (nonatomic, assign) int goodsQuantity;
@property (nonatomic, assign) int supplierId;

@property (nonatomic, assign) double productPrice;
@property (nonatomic, assign) double transferPrice;
@property (nonatomic, assign) double orderPrice;
@property (nonatomic, assign) double packagePrice; //包装价格

@property (nonatomic, assign) int acceptanceId;
@property (nonatomic, assign) int acceptanceStatus;
@property (nonatomic, assign) BOOL canReturn;

@property (nonatomic, assign) int designCategoryId; //商品类型
@property (nonatomic, copy) NSString* designCategoryName; //商品类型名
@property (nonatomic, assign) int designId; //商品id
@property (nonatomic, copy) NSString* designName; //商品名字
@property (nonatomic, assign) int detailId; //详情id
@property (nonatomic, assign) BOOL hasAbnormal; //是否异常
@property (nonatomic, assign) double originalPrice; //商品裸价
@property (nonatomic, copy) NSString* packagePic; //包装图

@property (nonatomic, copy) NSString* packageType; //包装名字
@property (nonatomic, copy) NSString* sizeName; //尺码名称
@property (nonatomic, assign) int sizeId; //尺码的ID
@property (nonatomic, assign) int num; //商品的数量
@property (nonatomic, assign) int shopCarId; //商品在购物车中的id
@property (nonatomic, assign) int productionCircle;

@property (nonatomic, strong) NSDate* payStartTime;
@property (nonatomic, strong) NSDate* payEndTime;

@property (nonatomic, strong) NSArray* orderDetailList;
@property (nonatomic, strong) NSDictionary* orderInfo;
@property (nonatomic, strong) NSDictionary* express;
/** 商品模型*/
@property (nonatomic, strong) BYOrderProduct* orderProduct;

/** 地址模型*/
@property (nonatomic, strong) BYAddress* address;

/** 商家模型*/
@property (nonatomic, strong) BYMerchant* business;
/** 价格模型*/
@property (nonatomic, strong) BYPrice* price;

- (id)initWithData:(NSDictionary*)data;

- (id)initWithDetailData:(NSDictionary*)data;

////确认订单的数据
//- (id)initWithConfirmOrderData:(NSDictionary *)data;
@end
