//
//  BYBannerService.m
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBannerService.h"
#import "MJExtension.h"
#import "BYBanner.h"

@implementation BYBannerService

- (void)loadBannerList:(void (^)(NSArray* bannerlist, BYError* error))finished
{
    NSString* url = @"/cms/GetMobileIndexAd";
    [BYNetwork get:url params:nil isCacheValid:NO finish:^(NSDictionary* data, BYError* error) {
        NSArray *dicList = data[@"floor"];
        NSMutableArray *modelList = [NSMutableArray arrayWithCapacity:dicList.count];
        
        [dicList bk_each:^(NSDictionary *dict) {
            BYBanner *banner = [[BYBanner alloc] init];
            banner = [BYBanner objectWithKeyValues:dict];
            if (banner) {
               [modelList addObject:banner];
            }
        }];
        
        finished(modelList,nil);
    }];
}

@end
