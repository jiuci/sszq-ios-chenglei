//
//  BYHomeInfo.m
//  IBY
//
//  Created by kangjian on 15/8/19.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYHomeInfo.h"

@implementation BYHomeInfo
+ (instancetype)homeWithDict:(NSDictionary*)info
{
    BYHomeInfo * homeInfo = [[BYHomeInfo alloc]init];
    homeInfo.adHeight = [info[@"adHeight"] intValue];
    homeInfo.adWidth = [info[@"adWidth"] intValue];
    NSMutableArray * tempArray = [NSMutableArray array];
    NSArray * ads = info[@"ads"];
    for (int i = 0 ; i< ads.count; i++) {
        BYHomeInfoSimple * simple = [[BYHomeInfoSimple alloc]init];
        simple.imagePath = ads[i][@"img"];
        
        simple.link = ads[i][@"link"];
        simple.type = [ads[i][@"type"] intValue];
        if (!simple.isValid) {
            return nil;
        }
        [tempArray addObject:simple];
    }
    homeInfo.adArray = [NSArray arrayWithArray:tempArray];
    
    homeInfo.bannerHeight = [info[@"bannerHeight"] intValue];
    homeInfo.bannerWidth = [info[@"bannerWidth"] intValue];
    [tempArray removeAllObjects];
    NSArray * banners = info[@"banners"];
    for (int i = 0 ; i< banners.count; i++) {
        BYHomeInfoSimple * simple = [[BYHomeInfoSimple alloc]init];
        simple.imagePath = banners[i][@"img"];
        simple.link = banners[i][@"link"];
        simple.type = [banners[i][@"type"] intValue];
        if (!simple.isValid) {
            return nil;
        }
        [tempArray addObject:simple];
    }
    homeInfo.bannerArray = [NSArray arrayWithArray:tempArray];
    
    homeInfo.bbsHeight = [info[@"bbsHeight"] intValue];
    homeInfo.bbsWidth = [info[@"bbsWidth"] intValue];
    [tempArray removeAllObjects];
    NSArray * bbsArray = info[@"bbsAds"];
    for (int i = 0 ; i< bbsArray.count; i++) {
        BYHomeInfoSimple * simple = [[BYHomeInfoSimple alloc]init];
        simple.imagePath = bbsArray[i][@"img"];
        simple.link = bbsArray[i][@"link"];
        simple.type = [bbsArray[i][@"type"] intValue];
        simple.title = bbsArray[i][@"title"];
        if (!simple.isValid) {
            return nil;
        }
        [tempArray addObject:simple];
    }
    homeInfo.bbsArray = [NSArray arrayWithArray:tempArray];
    
    homeInfo.bbsTitle = [NSString stringWithFormat:@"%@/",info[@"bbsMainTitle"]];
    homeInfo.bbsHalfTitle = info[@"bbsHalfTitle"];
    homeInfo.data = info;
    [BYHomeInfo saveInfo:info];
    return homeInfo;
}

+(void)saveInfo:(NSDictionary*)info
{
    NSString* kHomeInfo = @"kHomeInfo";
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:kHomeInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(instancetype)loadInfo
{
    NSString* kHomeInfo = @"kHomeInfo";
    NSDictionary* info = [[NSUserDefaults standardUserDefaults] objectForKey:kHomeInfo];
    if (!info) {
        return nil;
    }
    return [BYHomeInfo homeWithDict:info];
}
@end
