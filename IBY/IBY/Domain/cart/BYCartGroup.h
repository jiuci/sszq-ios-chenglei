//
//  BYCartGroup.h
//  IBY
//
//  Created by panshiyu on 14-10-28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYMerchant;
@class BYCart;

@interface BYCartGroup : NSObject

@property (nonatomic, strong) BYMerchant* merchant;
@property (nonatomic, strong) NSArray* cartlist;
@property (nonatomic, assign) int productionCircle;

@property (nonatomic, assign) float allprice;
@property (nonatomic, assign) BOOL isSelected;

@end
