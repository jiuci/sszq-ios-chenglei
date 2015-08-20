//
//  BYPackage.h
//  IBY
//
//  Created by panshiyu on 14-10-28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYPackage : NSObject

@property (nonatomic, assign) int productPackageId;
@property (nonatomic, copy) NSString* desc;
@property (nonatomic, copy) NSString* picName;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) double price;
@property (nonatomic, copy) NSString* packageType; //包装的类型
@end
