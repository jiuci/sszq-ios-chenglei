//
//  BYOrderCreateInfo.h
//  IBY
//
//  Created by panshiyu on 14/12/30.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYInvoice;
@interface BYOrderCreateInfo : NSObject

@property (nonatomic, copy) NSString* shop_car_id; //购物车id，只支持从购物车创建订单（格式：shopcartID +”|“+ 对应的数量" ， 多条的话用","分隔）
@property (nonatomic, assign) int address_id; //地址id
@property (nonatomic, copy) NSString* express; //快递公司编号（格式：商户id +"|"+ 快递id" ， 多条的话用","分隔）
@property (nonatomic, copy) NSString* p_s_send_type; //送货时间 （格式：商户id +"|"+  配送时间id" ， 多条的话用","分隔
@property (nonatomic, copy) NSString* p_express_c; //留言信息 （格式：商户id +"|"+ 留言信息" ， 多条的话用","分隔）
@property (nonatomic, assign) int need_invoice_val; //是否需要发票   1：需要      0：不需要
@property (nonatomic, assign) int need_point_val; //是否积分冲抵（默认 0）
@property (nonatomic, assign) int lose_point_name; //消耗积分数（默认 0
@property (nonatomic, copy) NSString* invoice_type; //根据”need_invoice_val“来决定 string	发票类型（默认 1）
@property (nonatomic, copy) NSString* invoice_title_val; //根据”need_invoice_val“来决定	string	发票抬头   （需要base64加密）
@property (nonatomic, copy) NSString* virtuapwd; //消费密码
@property (nonatomic, assign) int sourcetype; //未知，  （默认 0）
@property (nonatomic, copy) NSString* designIds; //所有选中的购物车条目所对应的商品id（用来进行库存操作），多个商品用","分隔
@property (nonatomic, copy) NSString* num; //与designIds字段中商品对应的商品数量（用来进行库存操作），同样用","分隔

+ (instancetype)defaultOrderCreateInfo;

- (void)updateByGrouplist:(NSArray*)grouplist;

- (void)updateByInvoice:(BYInvoice*)invoice;

@end
