//
//  BYIMPassWordService.m
//  IBY
//
//  Created by forbertl on 15/10/13.
//  Copyright © 2015年 com.biyao. All rights reserved.
//

#import "BYIMPassWordService.h"
#import "BYIMPassWordEngine.h"

@implementation BYIMPassWordService
- (void)loadpassword:(void (^)(NSString * password, BYError* error))finished
{
    [BYIMPassWordEngine loadpassword:finished];
}
@end
