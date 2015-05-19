//
//  BYOrderCreateInfo.m
//  IBY
//
//  Created by panshiyu on 14/12/30.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYOrderCreateInfo.h"
#import "BYConfirmOrderGroup.h"
#import "BYConfirmOrder.h"
#import "BYMerchant.h"
#import "BYExpress.h"
#import "BYInvoice.h"

@implementation BYOrderCreateInfo

+ (instancetype)defaultOrderCreateInfo
{
    BYOrderCreateInfo* info = [[BYOrderCreateInfo alloc] init];

    info.need_invoice_val = 0;
    info.need_point_val = 0;
    info.lose_point_name = 0;
    info.sourcetype = 0;
    info.invoice_type = @"";
    info.invoice_title_val = @"";
    info.virtuapwd = @"";
    info.sourcetype = 0;

    return info;
}

//@property (nonatomic, assign) int address_id; //地址id
//@property (nonatomic, copy) NSString* express; //快递公司编号（格式：商户id +"|"+ 快递id" ， 多条的话用","分隔）
//@property (nonatomic, copy) NSString* p_s_send_type; //送货时间 （格式：商户id +"|"+  配送时间id" ， 多条的话用","分隔

//@property (nonatomic, copy) NSString* p_express_c; //留言信息 （格式：商户id +"|"+ 留言信息" ， 多条的话用","分隔）
//@property (nonatomic, assign) int need_invoice_val; //是否需要发票   1：需要      0：不需要
//@property (nonatomic, assign) int need_point_val; //是否积分冲抵（默认 0）
//@property (nonatomic, assign) int lose_point_name; //消耗积分数（默认 0
//@property (nonatomic, copy) NSString* invoice_type; //根据”need_invoice_val“来决定 string	发票类型（默认 1）
//@property (nonatomic, copy) NSString* invoice_title_val; //根据”need_invoice_val“来决定	string	发票抬头   （需要base64加密）
//@property (nonatomic, copy) NSString* virtuapwd; //消费密码
//@property (nonatomic, assign) int sourcetype; //未知，  （默认 0）
//@property (nonatomic, copy) NSString* designIds; //所有选中的购物车条目所对应的商品id（用来进行库存操作），多个商品用","分隔
//@property (nonatomic, copy) NSString* num; //与designIds字段中商品对应的商品数量（用来进行库存操作），同样用","分隔

- (void)updateByGrouplist:(NSArray*)grouplist
{

    _shop_car_id = nil;
    _express = nil;
    _p_s_send_type = nil;
    _designIds = nil;
    _num = nil;
    _p_express_c = nil;

    for (BYConfirmOrderGroup* orderGroup in grouplist) {
        //TODO: 如果express信息为空怎么办，应该从源头防止，如果获取不到怎么办
        orderGroup.express = orderGroup.expresslist.firstObject;
        for (BYConfirmOrder* order in orderGroup.cartlist) {
            _shop_car_id = [NSString stringWithFormat:@"%@%@%d|%d", (_shop_car_id ? _shop_car_id : @""), (_shop_car_id ? @"," : @""), order.cartId, order.num];

            _designIds = [NSString stringWithFormat:@"%@%@%d", (_designIds ? _designIds : @""), (_designIds ? @"," : @""), order.designId];
            _num = [NSString stringWithFormat:@"%@%@%d", (_num ? _num : @""), (_num ? @"," : @""), order.num];
        }

        _express = [NSString stringWithFormat:@"%@%@%@|%d", (_express ? _express : @""), (_express ? @"," : @""), orderGroup.merchant.merchantId, orderGroup.express.expressType_id];

        _p_s_send_type = [NSString stringWithFormat:@"%@%@%@|%d", (_p_s_send_type ? _p_s_send_type : @""), (_p_s_send_type ? @"," : @""), orderGroup.merchant.merchantId, orderGroup.deliveryTime];
        _p_express_c = [NSString stringWithFormat:@"%@%@%@|%@", (_p_express_c ? _p_express_c : @""), (_p_express_c ? @"," : @""), orderGroup.merchant.merchantId, (orderGroup.p_express_c ? orderGroup.p_express_c : @"")];
    }

    //    BYLog_Class_Function;
}

- (void)updateByInvoice:(BYInvoice*)invoice
{
    //    @property (nonatomic, assign) int need_invoice_val; //是否需要发票   1：需要      0：不需要
    //    @property (nonatomic, copy) NSString* invoice_type; //根据”need_invoice_val“来决定 string	发票类型（默认 1）
    //    @property (nonatomic, copy) NSString* invoice_title_val; //根据”need_invoice_val“来决定	string	发票抬头
    if (invoice.isNeedInvoice) {
        _need_invoice_val = 1;
    }
    else {
        _need_invoice_val = 0;
    }
    _invoice_type = @"1";
    if (invoice.invoice_title_val) {
        _invoice_title_val = invoice.invoice_title_val;
    }
    else {
        _invoice_title_val = @"";
    }
}

@end
