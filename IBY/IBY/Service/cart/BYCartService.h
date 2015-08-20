//
//  BYCartService.h
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"
#import "BYCartParams.h"

#import "BYCart.h"
#import "BYCartGroup.h"
#import "BYPackage.h"
#import "BYMerchant.h"

#import "BYCartParams.h"
#import "BYDesign.h"

@interface BYCartService : BYBaseService

+ (instancetype)sharedCartService;

@property (nonatomic, assign) double totalPrice;
@property (nonatomic, strong) NSArray* cartGroupList;
@property (nonatomic, strong) NSArray* packageList;

@property (nonatomic, strong) BYCartParamsAdd* cartParams;
@property (nonatomic, strong) BYDesign* cartDesign;

//查询库存Url
- (void)checkInventoryByDesignIds:(NSString*)productIds productNums:(NSString*)productNums finish:(void (^)(BOOL success, BYError* error))finished;

//改变购物车条目支付状态（pay_status）的url   method:post   params:shopCarIds、uid
- (void)addCartWithShopCarIDs:(NSString*)shopCarIds
                       finish:(void (^)(NSDictionary* data, BYError* error))finished;

- (void)addToCart:(BYCartParamsAdd*)params
           finish:(void (^)(NSDictionary* data,BOOL needRevokeFCode, BYError* error))finished;

- (void)uploadCart:(void (^)(NSDictionary* data, BYError* error))finished;

- (void)fetchCartlistByPageIndex:(int)pageIndex
                        pageSize:(int)pageSize
                          finish:(void (^)(NSArray* cartGrouplist,
                                           BYError* error))finished;

- (void)deleteCartsByIds:(NSArray*)cartIds
                  finish:(void (^)(NSDictionary* data, BYError* error))finished;

- (void)modifyCartNum:(int)cartId
                  num:(int)num
               finish:(void (^)(NSDictionary* data, BYError* error))finished;

- (void)modifyCartsPackage:(int)cartId
                   package:(int)packageId
                    finish:
                        (void (^)(NSDictionary* data, BYError* error))finished;

- (void)CheckLimitSaleInSinglePageWithDesignId:(int)designId num:(int)num finish:(void (^)(NSDictionary* result, BYError* error))finished;

- (void)CheckLimitSaleInCartWithShopCarIds:(NSString*)shopCarIds finish:(void (^)(NSDictionary* result, BYError* error))finished;

- (void)CheckLimitSaleInConfirmOrderfinish:(void (^)(NSDictionary* result, BYError* error))finished;

@end
