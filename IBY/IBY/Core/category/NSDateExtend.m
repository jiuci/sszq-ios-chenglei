//
//  NSDateExtend.m
//  IBY
//
//  Created by panshiyu on 15/1/12.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "NSDateExtend.h"

@implementation NSDate (helper)

- (NSString*)dateStringWithFormat:(BYDateFormat)dateFormat
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    switch (dateFormat) {
    case BYDateFormatyyyyMMddHHmm:
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        break;
    case BYDateFormatyyyyMMdd:
        [formatter setDateFormat:@"yyyy.MM.dd"];
        break;
    default:
        [formatter setDateFormat:@"MM-dd HH:mm"];
        break;
    }
    return [formatter stringFromDate:self];
}

- (NSString*)dateStringWithFormatString:(NSString*)formatString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatString;
    formatter.timeZone = [NSTimeZone defaultTimeZone];
    return [formatter stringFromDate:self];
}

@end