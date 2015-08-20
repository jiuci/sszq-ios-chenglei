//
//  BYBaseDomain.m
//  IBY
//
//  Created by pan Shiyu on 14-8-26.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseDomain.h"

@implementation BYBaseDomain

+ (NSDictionary*)JSONKeyPathsByPropertyKey
{
    return nil;
}

+ (instancetype)mtlObjectWithKeyValues:(NSDictionary*)keyValues
{
    NSError* error;
    id object = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:keyValues error:&error];
    if (error) {
        BYLog(@"convert class %@ error ,msg - %@", [[self class] description], [error description]);
    }
    return object;
}

+ (NSArray*)mtlObjectsWithKeyValueslist:(NSArray*)keyValueslist
{
    NSError* error;
    NSArray* list = [MTLJSONAdapter modelsOfClass:[self class] fromJSONArray:keyValueslist error:&error];
    if (error) {
        BYLog(@"convert class list %@ error ,msg - %@", [[self class] description], [error description]);
    }
    return list;
}

- (NSDictionary*)mtlJsonDict
{
    return [MTLJSONAdapter JSONDictionaryFromModel:self];
}

@end
