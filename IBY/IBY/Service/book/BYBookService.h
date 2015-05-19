//
//  BYBookService.h
//  IBY
//
//  Created by panshiyu on 15/3/10.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"
#import "BYAddBookUnit.h"

@interface BYBookService : BYBaseService

- (void)addBook:(BYAddBookUnit*)unit
         finish:(void (^)(NSDictionary* data, NSDate* saleStartTime, BYError* error))finished;

- (void)addNextTurnByOriBookId:(int)oriBookId
                        finish:(void (^)(NSDictionary* data, BYError* error))finished;

- (void)checkoutBookByIds:(NSString*)bookIds
                   finish:(void (^)(NSDictionary* data, BYError* error))finished;

@end

BOOL isBookLimitError(BYError* error);