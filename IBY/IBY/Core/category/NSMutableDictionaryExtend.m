//
//  NSMutableDictionaryExtend.m
//  IBY
//
//  Created by panshiyu on 14/11/10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "NSMutableDictionaryExtend.h"

@implementation NSMutableDictionary (helper)

- (void)safeSetValue:(id)value forKey:(NSString*)key
{
    if (key && value) {
        //[super setValue:value forKey:key];
        [self setValue:value forKey:key];
    }
    else {
        BYLog(@"safeSetValue reach nil value or nil key");
    }
}

@end
