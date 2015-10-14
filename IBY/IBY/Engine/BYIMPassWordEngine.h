//
//  BYIMPassWordEngine.h
//  IBY
//
//  Created by forbertl on 15/10/13.
//  Copyright © 2015年 com.biyao. All rights reserved.
//

#import "BYBaseEngine.h"

@interface BYIMPassWordEngine : BYBaseEngine
+ (void)loadpassword:(void (^)(NSString * password, BYError* error))finished;
@end
