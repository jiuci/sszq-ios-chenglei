//
//  BYAddress.m
//  IBY
//
//  Created by coco on 14-9-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYAddress.h"

@implementation BYAddress

- (BYAddress*)mirrorAddress
{
    BYAddress* address = [[BYAddress alloc] init];
    address.address = self.address;
    address.addressId = self.addressId;
    address.areaId = self.areaId;
    address.areaName = self.areaName;
    address.cityId = self.cityId;
    address.cityName = self.cityName;
    address.provinceId = self.provinceId;
    address.provinceName = self.provinceName;
    address.phone = self.phone;
    address.receiver = self.receiver;
    address.zipcode = self.zipcode;
    address.isdefault = self.isdefault;
    address.expressComment = self.expressComment;

    address.province = [[BYProvince alloc] initWithProvinceId:IntToString(_provinceId) provinceName:_provinceName fatherId:nil];
    address.city = [[BYCity alloc] initWithCityId:IntToString(_cityId) cityName:_cityName fatherId:nil];
    ;
    address.area = [[BYArea alloc] initWithAreaId:IntToString(_areaId) areaName:_areaName fatherId:nil];

    return address;
}

- (void)reProcessData
{
    _cityId = [_city.cityId intValue];
    _cityName = _city.cityName;

    _provinceId = [_province.provinceId intValue];
    _provinceName = _province.provinceName;

    _areaId = [_area.areaId intValue];
    _areaName = _area.areaName;
}

- (id)initWithAddressDict:(NSDictionary*)dict
{
    self = [super init];

    if (self) {
        _addressId = [dict[@"addressId"] intValue];
        _address = dict[@"address"];
        //_addressId = [dict[@"addressId"] intValue];   //订单中没这个字段  注释
        _areaId = [dict[@"areaId"] intValue];
        _areaName = dict[@"area_name"];
        _cityId = [dict[@"city_id"] intValue];
        _cityName = dict[@"city_name"];
        _provinceId = [dict[@"province_id"] intValue];
        _provinceName = dict[@"province_name"];
        _phone = dict[@"phone"];
        _receiver = dict[@"receiver"];
        _zipcode = dict[@"zipcode"];
        _isdefault = [dict[@"isdefaul"] intValue];
        _province = [[BYProvince alloc] initWithProvinceId:dict[@"province_id"] provinceName:dict[@"province_name"] fatherId:nil];
        _city = [[BYCity alloc] initWithCityId:dict[@"city_id"] cityName:dict[@"city_name"] fatherId:nil];
        _area = [[BYArea alloc] initWithAreaId:dict[@"areaId"] areaName:dict[@"area_name"] fatherId:nil];
        if (dict[@"express_comment"]) {
            _expressComment = dict[@"express_comment"];
        }
    }
    return self;
}

@end

@implementation BYArea

- (id)initWithAreaDict:(NSDictionary*)dict
{
    self = [super init];

    if (self) {
        _areaId = dict[@"addr_id"];
        _areaName = dict[@"addr_name"];
        _fatherId = dict[@"father_id"];
    }
    return self;
}

- (id)initWithAreaId:(NSString*)areaId areaName:(NSString*)areaName fatherId:(NSString*)fatherId
{
    self = [super init];

    if (self) {
        _areaId = areaId;
        _areaName = areaName;
        _fatherId = fatherId;
    }
    return self;
}

@end

@implementation BYCity

- (id)initWithCityDict:(NSDictionary*)dict
{
    self = [super init];

    if (self) {
        _cityId = dict[@"addr_id"];
        _cityName = dict[@"addr_name"];
        _fatherId = dict[@"father_id"];
    }

    return self;
}

- (id)initWithCityId:(NSString*)cityId cityName:(NSString*)cityName fatherId:(NSString*)fatherId
{
    self = [super init];

    if (self) {
        _cityId = cityId;
        _cityName = cityName;
        _fatherId = fatherId;
    }

    return self;
}

@end

@implementation BYProvince

- (id)initWithProvinceDict:(NSDictionary*)dict
{
    self = [super init];

    if (self) {
        _provinceId = dict[@"addr_id"];
        _provinceName = dict[@"addr_name"];
        _fatherId = dict[@"father_id"];
    }

    return self;
}

- (id)initWithProvinceId:(NSString*)provinceId provinceName:(NSString*)provinceName fatherId:(NSString*)fatherId
{
    self = [super init];

    if (self) {
        _provinceId = provinceId;
        _provinceName = provinceName;
        _fatherId = fatherId;
    }

    return self;
}

@end