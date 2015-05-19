//
//  BYMerchant.h
//  IBY
//
//  Created by coco on 14-9-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//  商家模型

#import <Foundation/Foundation.h>

@interface BYMerchant : NSObject

@property (nonatomic, copy) NSString* merchantId; //商家的id
@property (nonatomic, copy) NSString* merchantName; //商家的名字
@property (nonatomic, copy) NSString* merchantTel; //商家的服务电话
@property (nonatomic, copy) NSString* serviceTime; //服务时间
@property (nonatomic, strong) NSNumber* productionTime; //生产周期
@property (nonatomic, strong) NSNumber* qualityGrade; //质量分数
@property (nonatomic, strong) NSNumber* serviceGrade; //服务分数
@property (nonatomic, strong) NSNumber* productGrade; //商品的匹配度
@property (nonatomic, copy) NSString* logoUrl;

- (id)initWithMerchantDict:(NSDictionary*)dict;

- (id)initWithMerchantInProductDetailBy:(NSDictionary*)dict;

//确认订单的商家数据
- (id)initConfirmOrderMerchantDict:(NSDictionary*)dict;

@end
