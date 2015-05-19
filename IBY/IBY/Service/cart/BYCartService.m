//
//  BYCartService.m
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYCartService.h"
#import "BYDesign.h"
#import "BYFCodeService.h"
#import "MJExtension.h"

@interface BYCartService ()
@property (nonatomic, strong) NSDictionary* packageDict;

@end

@implementation BYCartService

+ (instancetype)sharedCartService
{
    static BYCartService* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)CheckLimitSaleInSinglePageWithDesignId:(int)designId num:(int)num finish:(void (^)(NSDictionary*, BYError*))finished
{
    NSString* url = @"limitsale/validateAddShopcar";
    NSDictionary* params = @{ @"designId" : @(designId),
                              @"buyNum" : @(num) };

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        finished(data, nil);
    }];
}

- (void)CheckLimitSaleInCartWithShopCarIds:(NSString*)shopCarIds finish:(void (^)(NSDictionary*, BYError*))finished
{
    NSString* url = @"limitsale/validatePrepareGotoOrder";
    NSDictionary* params = @{ @"shopCarIds" : shopCarIds };

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        finished(data, nil);
    }];
}

- (void)CheckLimitSaleInConfirmOrderfinish:(void (^)(NSDictionary*, BYError*))finished
{
    NSString* url = @"limitsale/validateConfirmOrder";

    [BYNetwork get:url params:nil finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        finished(data, nil);
    }];
}

- (void)checkInventoryByDesignIds:(NSString*)productIds productNums:(NSString*)productNums finish:(void (^)(BOOL, BYError*))finished
{
    NSString* url = @"inventory/CheckInventoryByDesignId";

    NSDictionary* params = @{ @"designIds" : productIds,
                              @"num" : productNums };
    [BYNetwork get:url params:params finish:^(NSDictionary* data, BYError* error) {
        
        if(error){
            finished(FALSE,error);
            return ;
        }
        NSArray *cannotBuyItems = data[@"cannotBuyItems"];
        if(cannotBuyItems.count == 0){
            finished(TRUE,nil);
            return;
        }else{
            finished(FALSE,error);
            return;
        }
    }];
}

- (void)addToCart:(BYCartParamsAdd*)params
           finish:(void (^)(NSDictionary* data, BOOL needRevokeFCode, BYError* error))finished
{
    NSString* url = @"/shopCar/add";
    NSMutableDictionary* paramsDict = [@{
        @"designId" : @(params.designId),
        @"sizeName" : params.sizeName,
        @"supplierId" : @(params.supplierId),
        @"modelId" : @(params.modelId),
        @"num" : @(params.num),
        @"payStatus" : @(params.payStatus),
        @"CustomerDesignInfo" : params.customDesignInfo,
    } mutableCopy];
    if (params.fCode) {
        paramsDict[@"f_code"] = params.fCode;
    }
    [BYNetwork post:url
             params:paramsDict
             finish:^(NSDictionary* data, BYError* error) {
               if (error) {
                   if (isFCodeError(error)) {
                       finished(nil,YES,error);
                   }else{
                       finished(nil,NO,error);
                   }
               } else {
                 finished(data,NO, nil);
               }
             }];
}

- (void)uploadCart:(void (^)(NSDictionary* data, BYError* error))finished
{
    if (![BYAppCenter sharedAppCenter].isLogin) {
        BYLog(@"未登录时不可做数据同步");
        return;
    }

    NSString* url = @"/shopCar/updateCustomerId";
    NSDictionary* params = @{
        @"uid" : @([BYAppCenter sharedAppCenter].user.userID)
    };
    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if (error) {
            finished(nil,error);
        }else{
            finished(data,nil);
        }
    }];
}

//改变购物车条目支付状态（pay_status）的url   method:post   params:shopCarIds、uid
- (void)addCartWithShopCarIDs:(NSString*)shopCarIds
                       finish:(void (^)(NSDictionary* data, BYError* error))finished
{
    NSString* url = @"/shopCar/checkout";
    NSDictionary* params = @{
        @"shopCarIds" : shopCarIds
    };
    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
       
        if (error) {
            finished(nil,error);
        }else{
            finished(data,nil);
        }
    }];
}

- (void)fetchCartlistByPageIndex:(int)pageIndex
                        pageSize:(int)pageSize
                          finish:(void (^)(NSArray* cartGrouplist,
                                           BYError* error))finished
{
    NSString* url = @"/shopCar/GetShopCarInfo2";
    NSDictionary* paramsDict = @{
        @"pageIndex" : @(pageIndex),
        @"pageSize" : @(pageSize)
    };
    [BYNetwork get:url
            params:paramsDict
            finish:^(NSDictionary* data, BYError* error) {
               if (error) {
                   finished(nil, error);
                   return ;
               } else {
                   //总价钱
                   self.totalPrice = [data[@"totalPrice"] doubleValue];
                   //包裹列表
                   self.packageList = [BYPackage objectArrayWithKeyValuesArray:data[@"packageList"]];
                   
                   NSMutableDictionary *bPackageDict = [NSMutableDictionary dictionaryWithCapacity:self.packageList.count];
                   [self.packageList bk_each:^(BYPackage *obj) {
                       [bPackageDict setObject:obj forKey:[@(obj.productPackageId) stringValue]];
                   }];
                   self.packageDict = [NSDictionary dictionaryWithDictionary:bPackageDict];
                   
                   NSDictionary *cartsData = data[@"dic"];
                   NSDictionary *sizeData = data[@"sizelist"];
                   NSMutableArray *bGrouplist = [NSMutableArray arrayWithCapacity:cartsData.count];
                   
                   [cartsData bk_each:^(NSString *key, NSArray *cartslistData) {
                       BYCartGroup *bGroup = [[BYCartGroup alloc] init];
                       bGroup.productionCircle = 0;
                       
                       if (cartslistData.count > 0) {
                           NSDictionary *dict0 = cartslistData[0];
                           BYMerchant *bMerchant = [[BYMerchant alloc] init];
                           bMerchant.merchantId = key;
                           bMerchant.merchantName = dict0[@"supplierUserName"];
                           bGroup.merchant = bMerchant;
                       }
                       
                       NSMutableArray *bCarlist = [NSMutableArray arrayWithCapacity:cartslistData.count];
                       [cartslistData bk_each:^(NSDictionary *obj) {
                           BYCart *cart = [BYCart objectWithKeyValues:obj];
                           int durations = [obj[@"shopCar"][@"durations"] intValue];
                           if(durations > bGroup.productionCircle){
                               bGroup.productionCircle = durations;
                           }
                           cart.packageList = self.packageList;
                           
                           int packageId = -1;
                           if (obj[@"shopCar"]) {
                               cart.designId = [obj[@"shopCar"][@"designId"] intValue];
                               cart.modelId = [obj[@"shopCar"][@"modelId"] intValue];
                               cart.num = [obj[@"shopCar"][@"num"] intValue];
                               cart.sizeId = [obj[@"shopCar"][@"sizeId"] intValue];
                               cart.cartId = [obj[@"shopCar"][@"shopCarId"] intValue];
                               cart.sizeInfo =obj[@"shopCar"][@"sizeName"] ;
                               cart.useFCode = [obj[@"shopCar"][@"use_f_code"] boolValue] ;
                               packageId = [obj[@"shopCar"][@"packageId"] intValue];
                           }
                           
                           [sizeData bk_each:^(NSString* key, NSArray* sizeArray) {
                               if([IntToString(cart.designId) isEqualToString:key]){
                                   [cart updateSizeList:sizeArray];
                               }
                           }];
                           
                           if (packageId != -1) {
                               BYPackage *curPackage = [self.packageDict valueForKey:[@(packageId) stringValue]];
                               if (curPackage) {
                                   cart.package = curPackage;
                               }
                           }
                           
                           if (cart && cart.package && obj[@"shopCar"]) {
                               cart.parentGroup = bGroup;
                               [bCarlist addObject:cart];
                           }
                       }];
                       bGroup.cartlist = [NSArray arrayWithArray:bCarlist];
                       
                       if (bGroup && bGroup.merchant && bGroup.cartlist) {
                           [bGrouplist addObject:bGroup];
                       }
                       
                   }];
                   self.cartGroupList = [NSArray arrayWithArray:bGrouplist];
                   finished(self.cartGroupList,nil);
               }

            }];
}

- (void)deleteCartsByIds:(NSArray*)cartIds
                  finish:(void (^)(NSDictionary* data,
                                   BYError* error))finished
{
    // NSCAssert(!cartIds || cartIds.count < 1, @"缺少删除的cartId信息");

    NSString* url = @"/shopCar/DeleteGoods";
    NSDictionary* paramsDict = @{
        @"shopCarIds" : [cartIds componentsJoinedByString:@","]
    };
    [BYNetwork post:url
             params:paramsDict
             finish:^(NSDictionary* data, BYError* error) {
               if (error) {
                 finished(nil, error);
               } else {
                 finished(data, nil);
               }
             }];
}
//更新购物车中指定商品的数量
- (void)modifyCartNum:(int)cartId
                  num:(int)num
               finish:(void (^)(NSDictionary* data, BYError* error))finished
{
    NSString* url = @"/shopCar/ModifyGoodsNum";
    NSDictionary* paramsDict = @{
        @"shopCarId" : @(cartId),
        @"num" : @(num),
    };
    [BYNetwork post:url
             params:paramsDict
             finish:^(NSDictionary* data, BYError* error) {
               if (error) {
                 finished(nil, error);
               } else {
                 finished(data, nil);
               }
             }];
}

- (void)modifyCartsPackage:(int)cartId
                   package:(int)packageId
                    finish:(void (^)(NSDictionary* data,
                                     BYError* error))finished
{
    NSString* url = @"/shopCar/ModifyPackage";
    NSDictionary* paramsDict = @{
        @"shopCarId" : @(cartId),
        @"packageId" : @(packageId),
    };
    [BYNetwork post:url
             params:paramsDict
             finish:^(NSDictionary* data, BYError* error) {
               if (error) {
                 finished(nil, error);
               } else {
                 finished(data, nil);
               }
             }];
}

@end
