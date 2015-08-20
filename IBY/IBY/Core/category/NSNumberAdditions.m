//
//  NSNumberAdditions.m
//  IBY
//
//  Created by panshiyu on 14-10-28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "NSNumberAdditions.h"

@implementation NSNumber (price)

- (NSString*)priceString
{
    //    static NSNumberFormatter* formatter = nil;
    //    if (!formatter) {
    //        formatter = [[NSNumberFormatter alloc] init];
    //        formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
    //        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    //        formatter.groupingSize = 0;
    //
    //    }
    //    return [formatter stringFromNumber:self];
    //    return [NSString stringWithFormat:@"%.2f", [self doubleValue]];
    return [NSString stringWithFormat:@"%.0f", [self doubleValue]];
}

- (NSString*)rmbString
{
    return [@"￥" append:[self priceString]];
}

@end
