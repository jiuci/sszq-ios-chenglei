//
//  BYCart.h
//  IBY
//
//  Created by panshiyu on 14-10-17.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYBaseDomain.h"

@class BYPackage;
@class BYCartGroup;

@interface BYCart : BYBaseDomain
@property (nonatomic, copy) NSString* designName;
@property (nonatomic, copy) NSString* imgUrl;
@property (nonatomic, copy) NSString* imgUrl50;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double allPrice;
@property (nonatomic, assign) int transferDelayDay;

@property (nonatomic, assign) int designId;
@property (nonatomic, assign) int modelId;
@property (nonatomic, assign) int num;
@property (nonatomic, assign) int cartId;
@property (nonatomic, assign) int durations;
@property (nonatomic, assign) BOOL useFCode;

//package
@property (nonatomic, strong) BYPackage* package;
@property (nonatomic, copy) NSArray* packageList;

//size
@property (nonatomic, assign) int sizeId;
@property (nonatomic, copy) NSString* sizeInfo;
@property (nonatomic, copy) NSString* sizeDesc;
@property (nonatomic, copy) NSArray* sizeList;
@property (nonatomic, strong) NSMutableDictionary* sizeDict;

#pragma mark -
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) BYCartGroup* parentGroup;

- (void)updateSizeList:(NSArray*)sizeArray;

@end

@interface BYSize : NSObject

@property (nonatomic, assign) int sizeId;
@property (nonatomic, assign) int enable;

@property (nonatomic, copy) NSString* createBy;
@property (nonatomic, copy) NSString* createTime;
@property (nonatomic, copy) NSString* goodsSize;
@property (nonatomic, assign) int modelId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* updateby;
@property (nonatomic, copy) NSString* updateTime;
@property (nonatomic, copy) NSString* unit;

@end
