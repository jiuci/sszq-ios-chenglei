//
//  BYConfirmOrderGroup.h
//  IBY
//
//  Created by panshiyu on 14/11/28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYExpress;
@class BYMerchant;
#import "BYDelivery.h"
@interface BYConfirmOrderGroup : NSObject

@property (nonatomic, strong) BYMerchant* merchant;
@property (nonatomic, strong) NSArray* cartlist;
@property (nonatomic, assign) int supplierId;

@property (nonatomic, assign) double allprice;
@property (nonatomic, assign) int allCount;

//---//TODO: psy
@property (nonatomic, strong) BYExpress* express;
@property (nonatomic, assign) BYDeliveryTime deliveryTime; //默认是all
@property (nonatomic, copy) NSString* p_express_c; //商家留言
@property (nonatomic, strong) NSArray* expresslist;
@end
