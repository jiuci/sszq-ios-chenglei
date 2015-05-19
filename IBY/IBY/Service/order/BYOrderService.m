//
//  BYOrderService.m
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//
#import "BYOrderService.h"
#import "MJExtension.h"
#import "BYOrder.h"
#import "BYOrderProduct.h"
#import "BYAddress.h"
#import "BYPrice.h"
#import "BYMerchant.h"

#import "BYConfirmOrderGroup.h"
#import "BYConfirmOrder.h"
#import "BYPackage.h"

@implementation BYOrderService

- (void)fetchProductionCircleByDesignId:(int)designId finish:(void (^)(int, BYError*))finished
{
    NSString* url = @"productstyle/getDuration4Product";
    NSDictionary* param = @{ @"design_id" : @((long)designId) };

    [BYNetwork get:url params:param finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(-1,error);
            return ;
        }
        int durations = [data[@"durations"] intValue];
        finished(durations,error);
    }];
}

- (void)confirmOrderByOrderId:(NSString*)orderId finish:(void (^)(BOOL, BYError*))finished
{
    NSString* url = @"CustomerOrder/ConfirmReceipt";
    NSDictionary* params = @{ @"orderId" : orderId };

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(FALSE,error);
            return ;
        }
        finished(TRUE,nil);
    }];
}

- (void)getOrderTraceByOrderId:(NSString*)orderId finish:(void (^)(NSDictionary*, BYError*))finished
{
    NSString* url = @"order/getordertrace";
    NSDictionary* params = @{ @"orderId" : orderId
    };

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error || !data){
            finished(nil,error);
            return ;
        }
        
        finished(data,nil);
    }];
}

- (void)fetchOrderDetailByOrderId:(NSString*)orderId finish:(void (^)(BYOrder*, BYError*))finished
{
    NSString* url = @"CustomerOrder/GetMyOrderDetail";
    NSDictionary* param = @{
        @"orderId" : orderId
    };

    [BYNetwork post:url params:param finish:^(NSDictionary* data, BYError* error) {
        //if(error || !data[@"orderDetailList"] || !data[@"order"]){
        if (error) {
            finished(nil,error);
            return ;
        }
       // BYOrder *order = [BYOrder objectWithKeyValues:data];
        BYOrder *order = [[BYOrder alloc] initWithDetailData:data];
        finished(order,nil);

    }];
}
//取消订单
- (void)cancelOrderByOrderId:(NSString*)orderId
                      reason:(int)reason
               cancelComment:(NSString*)cancelComment
                      finish:(void (^)(BOOL success, BYError* error))finished
{
    NSString* url = @"CustomerOrder/CancelOrder";
    NSDictionary* params = @{
        @"orderId" : orderId,
        @"reason" : @(reason),
        @"cancelComment" : cancelComment
    };
    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if (error) {
            finished(NO,error);
            return ;
        }
        finished(YES,nil);
    }];
}

- (void)createOrder:(void (^)(NSString* orderId, BYError* error))finished
{
    NSString* url = @"/order/submit";

    NSMutableDictionary* params;
    BOOL isCrash = NO;
    @try {
        params = [@{
            @"shopCarIds" : self.createInfo.shop_car_id,
            @"express" : self.createInfo.express,
            @"addressId" : @(self.curAddress.addressId),
            @"sendType" : self.createInfo.p_s_send_type,
            @"express_c" : self.createInfo.p_express_c,
            @"needInvoice" : @(self.createInfo.need_invoice_val),

            @"needPoint" : @(self.createInfo.need_point_val),
            @"losePointName" : @(self.createInfo.lose_point_name),
            @"discountCode" : @"",
            @"virtualPwd" : self.createInfo.virtuapwd,
            @"sourceType" : @(self.createInfo.sourcetype)
        } mutableCopy];

        NSString* from = _fromBook ? @"book" : @"shopcar";
        params[@"from"] = from;
        params[@"bookIds"] = self.createInfo.shop_car_id;

        if (self.createInfo.need_invoice_val == 1) {
            params[@"invoiceType"] = self.createInfo.invoice_type;
            if ([self.createInfo.invoice_type isEqualToString:@"1"]) {
                params[@"invoiceTitle"] = self.createInfo.invoice_title_val;
            }
        }
    }
    @catch (NSException* exception)
    {
        isCrash = YES;
    }
    @finally
    {
        if (isCrash) {
            [MBProgressHUD topShowTmpMessage:@"创建订单失败"];
            return;
        }
    }

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if (error) {
            finished(nil,error);
            return ;
        }
        finished(data[@"orderid"],nil);
    }];
}

//进入确认订单页，请求的商品数据
- (void)fetchConfirmOrderInfo:(void (^)(NSArray* groupList, BYError* error))finished
{
    self.createInfo = [BYOrderCreateInfo defaultOrderCreateInfo];

    NSString* url = @"/shopCar/GotoOrder";
    NSString* from = _fromBook ? @"book" : @"shopcar";
    [BYNetwork post:url params:@{ @"from" : from } finish:^(NSDictionary* data, BYError* error) {
    
        if (error) {
            finished(nil,error);
            return ;
        }
        
        //创建 空的发票
        _invoice = [[BYInvoice alloc] init];
        
        self.totalPrice = 0;
        
        self.groupList = [NSMutableArray array];
        NSDictionary *map = data[@"list"];
        [map bk_each:^(id key, id obj) {//obj是每个店铺对应的一系列订单的详细信息
            BYConfirmOrderGroup *group = [[BYConfirmOrderGroup alloc] init];
            group.supplierId = [key intValue];
            NSMutableArray *orderList = [NSMutableArray array];
            
            group.allprice = 0;
            group.allCount = 0;
            //临时记录了 这个订单中生产周期最长的时间
            __block int productionTime = 0;
            [obj bk_each:^(id obj) {//具体一件商品的信息
             
                BYMerchant *merchant = [[BYMerchant alloc] initConfirmOrderMerchantDict:obj];
                group.merchant = merchant;
                
                if(productionTime < [obj[@"shopCar"][@"durations"] intValue]){
                    productionTime = [obj[@"shopCar"][@"durations"] intValue];
                }
                
                BYConfirmOrder *order = [[BYConfirmOrder alloc] init];
                order.imgUrl = obj[@"imgUrl"];
                order.imgUrl50 = obj[@"img_url_50"];
                order.designName = obj[@"designName"];
                order.price = [obj[@"price"]doubleValue];
                order.transferDelayDay = [obj[@"transferDelayDay"]intValue];
                
                
                BYPackage *package = [[BYPackage alloc] init];
                package.price = [obj[@"packagePrice"]doubleValue];
                package.packageType = obj[@"packageType"];
                package.desc = obj[@"package_description"];
                package.picName = obj[@"package_pic"];
                package.productPackageId = [obj[@"shopCar"][@"packageId"]intValue];
                order.package = package;
                
                order.designId = [obj[@"shopCar"][@"designId"]intValue];
                order.cartId = [obj[@"shopCar"][@"shopCarId"]intValue];
                order.sizeDesc = obj[@"shopCar"][@"sizeName"];
                order.sizeId = [obj[@"shopCar"][@"sizeId"]intValue];
                order.num = [obj[@"shopCar"][@"num"]intValue];
                order.useFCode = [obj[@"shopCar"][@"use_f_code"] boolValue];
                [orderList addObject:order];
                
                group.allprice += order.price * order.num;
                group.allCount += order.num;
            }];
            group.merchant.productionTime = @(productionTime);
            group.cartlist = orderList;
            
            self.totalPrice += group.allprice;
            
            [self.groupList addObject:group];
            
        }];
        
        finished(self.groupList,nil);
    }];
}

- (double)totalPrice
{
    __block double allPrice = 0;
    [self.groupList bk_each:^(BYConfirmOrderGroup* obj) {
        BYExpress *curExpress = obj.expresslist.firstObject;
        allPrice += curExpress.actualExpressTotalPrice + obj.allprice;
    }];

    return allPrice;
}

#pragma mark -

- (void)resetDataList
{
    _isPageEnabled = YES;
    _limit = 10;
    _pageIndex = 1;
    _total = 0;
    _hasMore = YES;
}

- (void)fetchOrderListByStatus:(BYOrderStatus)status
                        finish:(void (^)(NSArray* orderList, BYError* error))finished
{
    NSString* url = @"CustomerOrder/GetMyOrderList";
    NSDictionary* param = @{ @"pageIndex" : @(_pageIndex),
                             @"pageSize" : @(_limit),
                             @"orderStatus" : @(status)
    };

    if (status == STATUS_All) {
        param = @{ @"pageIndex" : @(_pageIndex),
                   @"pageSize" : @(_limit)
        };
    }

    [BYNetwork post:url params:param finish:^(NSDictionary* data, BYError* error) {
        if(error || !data[@"orderList"]){
            finished(nil,error);
            return ;
        }
        NSDictionary *map = data[@"orderDetailInfoList"];
        
        NSMutableArray *orderDetailInfoList = [NSMutableArray array];
        
        if (map) {
            [map bk_each:^(id key, id obj) {
                NSDictionary *detailDic = @{@"orderId": key,
                                            @"orderContent":obj};
                [orderDetailInfoList addObject:detailDic];
            }];
        }
        
        NSArray *arraylist = data[@"orderList"];
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:arraylist.count];
        NSMutableArray *resultlist = [NSMutableArray arrayWithCapacity:arraylist.count];
        for (NSDictionary *dict in arraylist){
            NSString *str1 = [NSString stringWithFormat:@"%@",dict[@"order_base"][@"order_id"]];
            for(int i = 0 ; i < orderDetailInfoList.count ;i++){
                NSDictionary *orderData =  orderDetailInfoList[i];
                NSString *str2 = [NSString stringWithFormat:@"%@",orderData[@"orderId"]];
                if([str1 isEqualToString:str2]){
                    NSDictionary *dic = @{@"orderDetailInfoList": orderDetailInfoList[i],
                                          @"orderList": dict};
                    [list addObject:dic];
                }
            }
        }
        
        [list bk_each:^(NSDictionary *obj) {
            BYOrder *order = [[BYOrder alloc]initWithData:obj];
            if(order){
                [resultlist addObject:order];
            }
        }];
        
        if (resultlist.count == 0) {
            _hasMore = NO;
        }else if(resultlist.count == _limit){
            _hasMore = YES;
            _pageIndex ++;
        }else{
            _pageIndex ++;
            _hasMore = NO;
        }
        
        finished([resultlist copy],nil);

    }];
}

@end
