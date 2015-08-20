//
//  BYOrderService.h
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"
#import "BYOrder.h"
#import "BYInvoice.h"
#import "BYDelivery.h"
#import "BYExpress.h"
#import "BYOrderCreateInfo.h"

@interface BYOrderService : BYBaseService <BYListService>

@property (nonatomic, strong) BYInvoice* invoice;
@property (nonatomic, assign) BYDeliveryTime deliveryTime;
@property (nonatomic, strong) BYExpress* express; //当前快递
@property (nonatomic, strong) NSMutableArray* groupList; //商家列表
@property (nonatomic, assign) double totalPrice; //

@property (nonatomic, strong) BYOrderCreateInfo* createInfo;

@property (nonatomic, strong) BYAddress* curAddress;

@property (nonatomic, assign) BOOL fromBook; //来自于预约的请求

@property (nonatomic, assign, readonly) BOOL isPageEnabled;
@property (nonatomic, assign) int limit;
@property (nonatomic, readonly) int pageIndex;
@property (nonatomic, readonly) int total;
@property (nonatomic, assign, readonly) BOOL hasMore;
- (void)resetDataList;

- (void)fetchOrderListByStatus:(BYOrderStatus)status
                        finish:(void (^)(NSArray* orderList, BYError* error))finished;

- (void)fetchOrderDetailByOrderId:(NSString*)orderId
                           finish:(void (^)(BYOrder* order, BYError* error))finished;

- (void)cancelOrderByOrderId:(NSString*)orderId
                      reason:(int)reason
               cancelComment:(NSString*)cancelComment
                      finish:(void (^)(BOOL success, BYError* error))finished;

- (void)getOrderTraceByOrderId:(NSString*)orderId finish:(void (^)(NSDictionary* data, BYError* error))finished;

//创建订单
- (void)createOrder:(void (^)(NSString* orderId, BYError* error))finished;

//进入确认订单页，请求的商品数据
- (void)fetchConfirmOrderInfo:(void (^)(NSArray* groupList, BYError* error))finished;

- (void)fetchProductionCircleByDesignId:(int)designId finish:(void (^)(int circle, BYError* error))finished;

- (void)confirmOrderByOrderId:(NSString*)orderId finish:(void (^)(BOOL success, BYError* error))finished;

@end
