//
//  NSArrayExtensions.h
//  IBY
//
//  Created by panShiyu on 14/11/15.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (helper)

- (NSString*)jsonString;

/**把一个
 list[ a , b, c, d, e, f]
 按照blk重新整理成
 list[
   [a, b,f],
    [c,d],
 ]
 其中blk是重新整理的规则
 */

- (NSDictionary*)organizedMapWithKeynameBlock:(NSString* (^)(id obj))nameBlock;

@end