//
//  BYBaseDomain.h
//  IBY
//
//  Created by pan Shiyu on 14-8-26.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "Mantle.h"
@interface BYBaseDomain : MTLModel <MTLJSONSerializing>

+ (instancetype)mtlObjectWithKeyValues:(NSDictionary*)keyValues;
+ (NSArray*)mtlObjectsWithKeyValueslist:(NSArray*)keyValueslist;

- (NSDictionary*)mtlJsonDict;

@end
