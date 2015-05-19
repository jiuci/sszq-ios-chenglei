//
//  NSDictionaryExtensions.m
//  IBY
//
//  Created by panShiyu on 14/11/15.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "NSDictionaryExtensions.h"

@implementation NSDictionary (helper)

- (NSString*)jsonString
{
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];

    if (!jsonData) {
        BYLog(@"NSDictionary to jsonString error");
        return nil;
    }
    else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
