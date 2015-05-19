//
//  BYPayService.h
//  IBY
//
//  Created by St on 14/11/27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BYPayStatusUnpay = 0,
    BYPayStatusSuccess = 1,
    BYPayStatusFail = 2
} BYPayStatus;

@class BYPayPrepareInfo;
@interface BYPayService : NSObject

//获取预支付相关数据
- (void)fetchPayCodeWithOrderId:(NSString*)orderId finish:(void (^)(BYPayPrepareInfo* result, BYError* error))finished;

//获取支付相关数据
- (void)fetchPayDataWithOrderpaycode:(NSString*)orderpaycode
                          totalprice:(float)totalprice
                             paytype:(int)payType
                                  ip:(NSString*)ip
                            bankType:(int)bankType
                              finish:(void (^)(NSDictionary* data, BYError* error))finished;

//订单状态查询
- (void)getPayStatusWithpaycode:(NSString*)orderpaycode
                         finish:(void (^)(BYPayStatus status, BYError* error))finished;

@end

@interface BYPayPrepareInfo : NSObject

@property (nonatomic, assign) double totalPrice;
@property (nonatomic, copy) NSString* mergeOrderId;
@property (nonatomic, copy) NSString* receiverName;
@property (nonatomic, copy) NSString* receiverPhoneNumber;
@property (nonatomic, copy) NSString* receiverAddress;
@property (nonatomic, copy) NSString* receiverZipcode;
@property (nonatomic, copy) NSString* orderId;
@property (nonatomic, copy) NSString* tokenId;
@property (nonatomic, copy) NSString* callBackUrl;

- (id)initWithData:(NSDictionary*)dict;

@end