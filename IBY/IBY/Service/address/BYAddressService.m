//
//  BYAddressService.m
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYAddressService.h"

#import "BYAddressEngine.h"
@implementation BYAddressService {
    NSMutableDictionary* _map;
}

- (NSArray*)dataForFingerprint:(NSString*)key
{
    if (!_map) {
        _map = [NSMutableDictionary dictionary];
    }
    return _map[key];
}

- (void)setData:(NSArray*)cache forFingerprint:(NSString*)key
{
    if (!_map) {
        _map = [NSMutableDictionary dictionary];
    }
    _map[key] = cache;
}

- (void)fetchAddressList:(void (^)(NSArray*, BYError*))finished
{
    [BYAddressEngine fetchAddressList:finished];

}

- (void)addAddressByAddress:(NSString*)address
                     areaId:(NSString*)areaId
                   receiver:(NSString*)receiver
                      phone:(NSString*)phone
                  isdefault:(int)isdefault
                    zipcode:(NSString*)zipcode
                     finish:(void (^)(NSNumber* addressId, BYError* error))finished
{
    [BYAddressEngine addAddressByAddress:(NSString*)address
                                  areaId:(NSString*)areaId
                                receiver:(NSString*)receiver
                                   phone:(NSString*)phone
                               isdefault:(int)isdefault
                                 zipcode:(NSString*)zipcode
                                  finish:(void (^)(NSNumber* addressId, BYError* error))finished];
}

- (void)updateAddressByAddressId:(int)addressId address:(NSString*)address
                          areaId:(int)areaId
                        receiver:(NSString*)receiver
                           phone:(NSString*)phone
                       isdefault:(int)isdefault
                         zipcode:(NSString*)zipcode
                          finish:(void (^)(BOOL success, BYError*))finished
{
    [BYAddressEngine updateAddressByAddressId:(int)addressId address:(NSString*)address
                                       areaId:(int)areaId
                                     receiver:(NSString*)receiver
                                        phone:(NSString*)phone
                                    isdefault:(int)isdefault
                                      zipcode:(NSString*)zipcode
                                       finish:(void (^)(BOOL success, BYError*))finished];
}

- (void)deleteAddressByAddressId:(int)addressId finish:(void (^)(BOOL success, BYError*error))finished
{
    [BYAddressEngine deleteAddressByAddressId:addressId finish:finished];

}

- (void)fetchProvinceList:(void (^)(NSArray*, BYError*))finished
{
    [BYAddressEngine fetchProvinceList:finished];
}

- (void)fetchCityListByProvinceId:(int)provinceId finish:(void (^)(NSArray*, BYError*))finished
{
    [BYAddressEngine fetchCityListByProvinceId:(int)provinceId finish:(void (^)(NSArray*, BYError*))finished];
    }

- (void)fetchAreaListByCityId:(int)cityId finish:(void (^)(NSArray*, BYError*))finished
{
    [BYAddressEngine fetchAreaListByCityId:(int)cityId finish:(void (^)(NSArray*, BYError*))finished];
    }

//获取配送快递的信息
- (void)fetchExpressTypeWithAreaId:(int)areaId
                        supplierId:(int)supplierId
                          fromBook:(BOOL)fromBook
                            finish:(void (^)(NSArray* expressList, BYError* error))finished
{
    [BYAddressEngine fetchExpressTypeWithAreaId:(int)areaId
                                     supplierId:(int)supplierId
                                       fromBook:(BOOL)fromBook
                                         finish:(void (^)(NSArray* expressList, BYError* error))finished];
   }

@end
