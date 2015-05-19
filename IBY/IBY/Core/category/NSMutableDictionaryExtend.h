//
//  NSMutableDictionaryExtend.h
//  IBY
//
//  Created by panshiyu on 14/11/10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (helper)

- (void)safeSetValue:(id)value forKey:(NSString*)key;

@end