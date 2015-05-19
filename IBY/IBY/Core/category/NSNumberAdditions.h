//
//  NSNumberAdditions.h
//  IBY
//
//  Created by panshiyu on 14-10-28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (price)

- (NSString *)priceString;

// ￥ + priceString
- (NSString *)rmbString;

@end
