//
//  NSDateExtend.h
//  IBY
//
//  Created by panshiyu on 15/1/12.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SECONDS_PER_DAY (60 * 60 * 24)

typedef enum {
    BYDateFormatMMddHHmm,
    BYDateFormatyyyyMMddHHmm,
    BYDateFormatyyyyMMdd
} BYDateFormat;

@interface NSDate (helper)

//根据dateForamt将当前NSDate对象转换成NSString表示形式的时间。
- (NSString*)dateStringWithFormat:(BYDateFormat)dateFormat;

//根据formatString 的格式返回对应的date字符串
- (NSString*)dateStringWithFormatString:(NSString*)formatString;

@end
