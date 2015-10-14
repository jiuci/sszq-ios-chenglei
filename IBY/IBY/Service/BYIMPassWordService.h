//
//  BYIMPassWordService.h
//  IBY
//
//  Created by forbertl on 15/10/13.
//  Copyright © 2015年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYIMPassWordService : BYBaseService
- (void)loadpassword:(void (^)(NSString * password, BYError* error))finished;
@end
