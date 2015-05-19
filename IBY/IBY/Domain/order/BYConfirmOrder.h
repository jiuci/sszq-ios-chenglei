//
//  BYConfirmOrder.h
//  IBY
//
//  Created by panshiyu on 14/11/28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYPackage;
@class BYConfirmOrderGroup;
@class BYExpress;
@interface BYConfirmOrder : NSObject

@property (nonatomic, copy) NSString* designName;
@property (nonatomic, copy) NSString* imgUrl;
@property (nonatomic, copy) NSString* imgUrl50;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) int transferDelayDay;

@property (nonatomic, assign) int designId;
@property (nonatomic, assign) int modelId;
@property (nonatomic, assign) int num;
@property (nonatomic, assign) int cartId;
@property (nonatomic, assign) BOOL useFCode;

//package
@property (nonatomic, strong) BYPackage* package;
//size
@property (nonatomic, assign) int sizeId;
@property (nonatomic, copy) NSString* sizeDesc;

#pragma mark -
@property (nonatomic, weak) BYConfirmOrderGroup* parentGroup;
@property (nonatomic, strong) BYExpress* express; //快递

@end
