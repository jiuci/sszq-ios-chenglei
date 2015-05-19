//
//  BYAddressService.m
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYAddressService.h"
#import "BYAddress.h"
#import "BYExpress.h"
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
    NSString* url = @"user/address/show";

    [BYNetwork get:url params:nil finish:^(NSDictionary* data, BYError* error) {
        if(error || !data[@"list"]){
            finished(nil,error);
            return ;
        }
        
        NSArray *addressList = data[@"list"];
        NSMutableArray *resultlist = [NSMutableArray arrayWithCapacity:addressList.count];
        [addressList bk_each:^(NSDictionary *obj) {
            BYAddress *address = [[BYAddress alloc]initWithAddressDict:obj];
            if(address){
                [resultlist addObject:address];
            }
        }];
        
        finished([resultlist copy], nil);

    }];
}

- (void)addAddressByAddress:(NSString*)address
                     areaId:(NSString*)areaId
                   receiver:(NSString*)receiver
                      phone:(NSString*)phone
                  isdefault:(int)isdefault
                    zipcode:(NSString*)zipcode
                     finish:(void (^)(NSNumber* addressId, BYError* error))finished
{
    NSString* url = @"user/address/add";
    NSDictionary* param = @{ @"address" : address,
                             @"areaId" : areaId,
                             @"receiver" : receiver,
                             @"phone" : phone,
                             @"isdefault" : @(isdefault),
                             @"zipcode" : zipcode
    };
    [BYNetwork post:url params:param finish:^(NSDictionary* data, BYError* error) {
        if(error || !data[@"addressid"]){
            finished(nil,error);
            return ;
        }
        
        int addressId = [data[@"addressid"] intValue];
        finished(@(addressId),nil);

    }];
}

- (void)updateAddressByAddressId:(int)addressId address:(NSString*)address
                          areaId:(int)areaId
                        receiver:(NSString*)receiver
                           phone:(NSString*)phone
                       isdefault:(int)isdefault
                         zipcode:(NSString*)zipcode
                          finish:(void (^)(BYError*))finished
{
    NSString* url = @"user/address/update";
    NSDictionary* param = @{ @"addressId" : @(addressId),
                             @"address" : address,
                             @"areaId" : @(areaId),
                             @"receiver" : receiver,
                             @"phone" : phone,
                             @"isdefault" : @(isdefault),
                             @"zipcode" : zipcode
    };

    [BYNetwork post:url params:param finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(error);
            return ;
        }

        finished(nil);
    }];
}

- (void)deleteAddressByAddressId:(int)addressId finish:(void (^)(BYError*))finished
{

    NSString* url = @"user/address/delete";
    NSDictionary* param = @{ @"addressId" : @(addressId) };

    [BYNetwork post:url params:param finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(error);
            return ;
        }
        
        finished(nil);
    }];
}

- (void)fetchProvinceList:(void (^)(NSArray*, BYError*))finished
{
    NSString* url = @"user/address/getprovinces";

    [BYNetwork get:url params:nil isCacheValid:YES finish:^(NSDictionary* data, BYError* error) {
        if(error || !data[@"list"]){
            finished(nil,error);
            return ;
        }
        
        NSArray *provinceArray = data[@"list"];
        NSMutableArray *resultlist = [NSMutableArray arrayWithCapacity:provinceArray.count];
        [provinceArray bk_each:^(NSDictionary *obj) {
            BYProvince *province = [[BYProvince alloc]initWithProvinceDict:obj];
            if(province){
                [resultlist addObject:province];
            }
        }];
        
        finished([resultlist copy],nil);

    }];
}

- (void)fetchCityListByProvinceId:(int)provinceId finish:(void (^)(NSArray*, BYError*))finished
{

    NSString* url = @"user/address/getcitys";
    NSDictionary* param = @{ @"provinceid" : @(provinceId) };

    [BYNetwork post:url params:param isCacheValid:YES finish:^(NSDictionary* data, BYError* error) {
        if(error || !data[@"citylist"]){
            finished(nil,error);
            return ;
        }
        
        NSArray *cityArray = data[@"citylist"];
        NSMutableArray *resultlist = [NSMutableArray arrayWithCapacity:cityArray.count];
        [cityArray bk_each:^(NSDictionary *obj) {
            BYCity *city = [[BYCity alloc]initWithCityDict:obj];
            if(city){
                [resultlist addObject:city];
            }
        }];
        
        finished([resultlist copy],nil);
    }];
}

- (void)fetchAreaListByCityId:(int)cityId finish:(void (^)(NSArray*, BYError*))finished
{
    NSString* url = @"user/address/getareas";
    NSDictionary* param = @{ @"cityid" : @(cityId) };

    [BYNetwork post:url params:param isCacheValid:YES finish:^(NSDictionary* data, BYError* error) {
        if(error || !data[@"arealist"]){
            finished(nil,error);
            return ;
        }
        
        NSArray *areaArray = data[@"arealist"];
        NSMutableArray *resultlist = [NSMutableArray arrayWithCapacity:areaArray.count];
        [areaArray bk_each:^(NSDictionary *obj) {
            BYArea *area = [[BYArea alloc]initWithAreaDict:obj];
            if(area){
                [resultlist addObject:area];
            }
        }];
        
        finished([resultlist copy],nil);
    }];
}

//获取配送快递的信息
- (void)fetchExpressTypeWithAreaId:(int)areaId
                        supplierId:(int)supplierId
                          fromBook:(BOOL)fromBook
                            finish:(void (^)(NSArray* expressList, BYError* error))finished
{
    NSString* url = @"supplier/express/list";
    NSMutableDictionary* params = [@{
        @"areaid" : @(areaId),
        @"supplierid" : @(supplierId)
    }mutableCopy];
    
    if (!fromBook) {
        params[@"from"] = @"shopcar";
    }

    [BYNetwork get:url params:params finish:^(NSDictionary* data, BYError* error) {
       
        if (error || !data[@"expresstype"]) {
            finished(nil,error);
            return ;
        }
//        NSData *data1 = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
//        [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    
//        NSString *expressStr = data[@"expresstype"];
//        expressStr = [expressStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        NSArray *expressType = [(NSArray *)expressStr mutableCopy];
//        
//        BYLog(@"%@",expressType);
//        
//        [expressType bk_each:^(NSDictionary *obj) {
//            express = [[BYExpress alloc] initWithDictionary:obj];
//        }];
        
        NSArray *expressArr = data[@"expresstype"];
        NSMutableArray *expressMutableArr = [NSMutableArray array];
        [expressArr bk_each:^(id obj) {
            BYExpress *express = [[BYExpress alloc] initWithDictionary:obj];
            [expressMutableArr addObject:express];
            
        }];
        finished(expressMutableArr,nil);
    }];
}

@end
