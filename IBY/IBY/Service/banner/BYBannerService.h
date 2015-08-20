//
//  BYBannerService.h
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"
#import "BYError.h"

@interface BYBannerService : BYBaseService

//cms/GetMobileIndexAd
- (void)loadBannerList:(void (^)(NSArray *bannerlist,BYError *error))finished;

@end
