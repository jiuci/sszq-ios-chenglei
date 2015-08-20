//
//  NSDataExtend.m
//  IBY
//
//  Created by panshiyu on 15/1/29.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "NSDataExtend.h"

@implementation NSData (helper)

- (NSString*)hexString
{
    const unsigned char* dataBuffer = (const unsigned char*)[self bytes];
    if (!dataBuffer)
        return [NSString string];

    NSUInteger dataLength = [self length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];

    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];

    return [NSString stringWithString:hexString];
}

@end
