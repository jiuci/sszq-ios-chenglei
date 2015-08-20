//
//  BYPayService.m
//  IBY
//
//  Created by St on 14/11/27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYPayService.h"

@implementation BYPayService

- (void)fetchPayCodeWithOrderId:(NSString*)orderId finish:(void (^)(BYPayPrepareInfo*, BYError*))finished
{
    NSString* url = @"CustomerOrder/CreatePayCode";
    NSDictionary* params = @{ @"order_id_list" : orderId };

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error || !data){
            finished(nil, error);
            return ;
        }
        BYPayPrepareInfo *payResult = [[BYPayPrepareInfo alloc] initWithData:data];

        finished(payResult,nil);
    }];
}

- (void)fetchPayDataWithOrderpaycode:(NSString*)orderpaycode
                          totalprice:(float)totalprice
                             paytype:(int)payType
                                  ip:(NSString*)ip
                            bankType:(int)bankType
                              finish:(void (^)(NSDictionary* data, BYError* error))finished
{

    NSString* url = @"payment/PerpareParameter";
    NSDictionary* params = @{ @"orderpaycode" : orderpaycode,
                              @"totalprice" : @(totalprice),
                              @"pay_type" : @(payType),
                              @"ip" : ip,
                              @"bank_type" : @(bankType) };

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil, error);
            return ;
        }
        
        finished(data,nil);
    }];
}

- (void)getPayStatusWithpaycode:(NSString*)orderpaycode finish:(void (^)(BYPayStatus, BYError*))finished
{
    NSString* url = @"payment/GetOrderPaymentStatus";
    NSDictionary* params = @{ @"orderpaycode" : orderpaycode };

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(NO, error);
            return ;
        }
        
        BYPayStatus status = [data[@"status"] intValue];
        finished(status,nil);

    }];
}

@end

@implementation BYPayPrepareInfo

- (id)initWithData:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        _totalPrice = [dict[@"totalPrice"] doubleValue];
        _mergeOrderId = dict[@"mergeOrderId"];
        NSDictionary* expressData = dict[@"express"];
        NSString* addressStr = [NSString stringWithFormat:@"%@%@%@%@", expressData[@"province_name"], expressData[@"city_name"], expressData[@"area_name"], expressData[@"address"]];
        _receiverAddress = addressStr;
        _receiverName = expressData[@"receiver"];
        _receiverPhoneNumber = expressData[@"mobile_phone"];
        _receiverZipcode = expressData[@"post_code"];
    }
    return self;
}

@end
