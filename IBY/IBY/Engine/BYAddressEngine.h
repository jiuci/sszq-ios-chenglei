//
//  BYAddressEngine.h
//  IBY
//
//  Created by kangjian on 15/8/6.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseEngine.h"

@interface BYAddressEngine : BYBaseEngine
+ (void)fetchAddressList:(void (^)(NSArray* addressList, BYError* error))finished;

+ (void)addAddressByAddress:(NSString*)address
                     areaId:(NSString*)areaId
                   receiver:(NSString*)receiver
                      phone:(NSString*)phone
                  isdefault:(int)isdefault
                    zipcode:(NSString*)zipcode
                     finish:(void (^)(NSNumber* addressId, BYError* error))finished;

+ (void)updateAddressByAddressId:(int)addressId address:(NSString*)address
                          areaId:(int)areaId
                        receiver:(NSString*)receiver
                           phone:(NSString*)phone
                       isdefault:(int)isdefault
                         zipcode:(NSString*)zipcode
                          finish:(void (^)(BOOL success, BYError*error))finished;

+ (void)deleteAddressByAddressId:(int)addressId
                          finish:(void (^)(BOOL success, BYError*error))finished;

+ (void)fetchProvinceList:(void (^)(NSArray* provinceList, BYError* error))finished;

+ (void)fetchCityListByProvinceId:(int)provinceId
                           finish:(void (^)(NSArray* cityList, BYError* error))finished;

+ (void)fetchAreaListByCityId:(int)cityId
                       finish:(void (^)(NSArray* areaList, BYError* error))finished;
//获取配送快递的信息
+ (void)fetchExpressTypeWithAreaId:(int)areaId
                        supplierId:(int)supplierId
                          fromBook:(BOOL)fromBook
                            finish:(void (^)(NSArray* expressList, BYError* error))finished;
@end
