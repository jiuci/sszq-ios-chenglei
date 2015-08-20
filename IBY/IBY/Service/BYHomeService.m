//
//  BYHomeService.m
//  IBY
//
//  Created by kangjian on 15/8/18.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYHomeService.h"
#import "BYHomeEngine.h"
@implementation BYHomeService
- (void)loadHomePagefinish:(void (^)(BYHomeInfo * info, BYError* error))finished
{
    [BYHomeEngine loadHomePagefinish:finished];
}
@end
