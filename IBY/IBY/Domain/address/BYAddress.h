//
//  BYAddress.h
//  IBY
//
//  Created by coco on 14-9-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//  地址模型

#import <Foundation/Foundation.h>
@class BYProvince;
@class BYCity;
@class BYArea;

@interface BYAddress : NSObject

@property (nonatomic, copy) NSString* address;
@property (nonatomic, assign) int addressId;

@property (nonatomic, strong) BYProvince* province;
@property (nonatomic, strong) BYCity* city;
@property (nonatomic, strong) BYArea* area;

@property (nonatomic, copy) NSString* receiver;
@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* zipcode;
@property (nonatomic, assign) int isdefault;

@property (nonatomic, assign) int areaId;
@property (nonatomic, copy) NSString* areaName;

@property (nonatomic, assign) int cityId;
@property (nonatomic, copy) NSString* cityName;

@property (nonatomic, assign) int provinceId;
@property (nonatomic, copy) NSString* provinceName;

@property (nonatomic, assign) NSString* expressComment;

- (id)initWithAddressDict:(NSDictionary*)dict; //提供给 地址管理的接口

- (BYAddress*)mirrorAddress;
- (void)reProcessData;

/** 发票名称：invoice_title*/
@property (nonatomic, copy) NSString* invoice_title;
/** 发票类型：invoice_type*/
@property (nonatomic, assign) int invoice_type;
/** need_invoice*/
@property (nonatomic, assign) int need_invoice;

@end

@interface BYArea : NSObject

@property (nonatomic, copy) NSString* areaId;
@property (nonatomic, copy) NSString* areaName;
@property (nonatomic, copy) NSString* fatherId;

- (id)initWithAreaDict:(NSDictionary*)dict;
- (id)initWithAreaId:(NSString*)areaId areaName:(NSString*)areaName fatherId:(NSString*)fatherId;

@end

@interface BYCity : NSObject

@property (nonatomic, copy) NSString* cityId;
@property (nonatomic, copy) NSString* cityName;
@property (nonatomic, copy) NSString* fatherId;

- (id)initWithCityDict:(NSDictionary*)dict;
- (id)initWithCityId:(NSString*)cityId cityName:(NSString*)cityName fatherId:(NSString*)fatherId;

@end

@interface BYProvince : NSObject

@property (nonatomic, copy) NSString* provinceId;
@property (nonatomic, copy) NSString* provinceName;
@property (nonatomic, copy) NSString* fatherId;

- (id)initWithProvinceDict:(NSDictionary*)dict;
- (id)initWithProvinceId:(NSString*)provinceId provinceName:(NSString*)provinceName fatherId:(NSString*)fatherId;

@end
