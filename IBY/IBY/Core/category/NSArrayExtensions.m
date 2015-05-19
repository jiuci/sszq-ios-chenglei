//
//  NSArrayExtensions.m
//  IBY
//
//  Created by panShiyu on 14/11/15.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "NSArrayExtensions.h"

@implementation NSArray (helper)

- (NSString*)jsonString
{
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];

    if (!jsonData) {
        BYLog(@"NSDictionary to jsonString error");
        return nil;
    }
    else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSDictionary*)organizedMapWithKeynameBlock:(NSString* (^)(id obj))nameBlock
{
    NSMutableDictionary* map = [NSMutableDictionary dictionary];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        NSString *key = nameBlock(obj);
        if (key) {
            NSMutableArray *values = map[key];
            if (!values) {
                values = [NSMutableArray array];
            }
            [values addObject:obj];
            map[key] = values;
        }

    }];
    return [NSDictionary dictionaryWithDictionary:map];
}

@end
