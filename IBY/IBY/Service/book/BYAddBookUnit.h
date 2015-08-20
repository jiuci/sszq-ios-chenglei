//
//  BYAddBookUnit.h
//  IBY
//
//  Created by panshiyu on 15/3/11.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYAddBookUnit : NSObject

@property (nonatomic, assign) int designId;
@property (nonatomic, assign) int isNext; //本轮为0，下轮为1
@property (nonatomic, assign) int turnId;

@property (nonatomic, assign) int supplierId;
@property (nonatomic, assign) int num;
@property (nonatomic, copy) NSString* sizeName; //同size

@property (nonatomic, copy) NSString* customDesignInfo;

- (BOOL)isValid;

@end
