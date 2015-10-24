//
//  BYHomeInfo.m
//  IBY
//
//  Created by kangjian on 15/8/19.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYHomeInfo.h"
#import "BYHomeNavInfo.h"
#import "BYHomeFloorInfo.h"
@implementation BYHomeInfo
+ (instancetype)homeWithDict:(NSDictionary*)info
{
    BYHomeInfo * homeInfo = [[BYHomeInfo alloc]init];
    homeInfo.adHeight = [info[@"adHeight"] intValue];
    homeInfo.adWidth = [info[@"adWidth"] intValue];
    homeInfo.adImgTitleWidth = [info[@"adImgTitleWidth"] intValue];
    homeInfo.adImgTitleHeight = [info[@"adImgTitleHeight"] intValue];
    NSMutableArray * tempArray = [NSMutableArray array];
//    NSArray * ads = info[@"ads"];
//    for (int i = 0 ; i< ads.count; i++) {
//        BYHomeInfoSimple * simple = [[BYHomeInfoSimple alloc]init];
//        simple.imagePath = ads[i][@"img"];
//        
//        simple.link = ads[i][@"link"];
//        simple.type = [ads[i][@"type"] intValue];
//        simple.categoryID = [ads[i][@"cmsCategoryID"] intValue];
//        if (!simple.isValid) {
//            return nil;
//        }
//        [tempArray addObject:simple];
//    }
//    homeInfo.adArray = [NSArray arrayWithArray:tempArray];
//
    
//    homeInfo.bbsHeight = [info[@"bbsHeight"] intValue];
//    homeInfo.bbsWidth = [info[@"bbsWidth"] intValue];
//    [tempArray removeAllObjects];
    
    NSArray * banners = info[@"banners"];
    for (int i = 0 ; i< banners.count; i++) {
        BYHomeInfoSimple * simple = [[BYHomeInfoSimple alloc]init];
        simple.imagePath = banners[i][@"img"];
        simple.link = banners[i][@"link"];
        simple.type = [banners[i][@"type"] intValue];
        simple.categoryID = [banners[i][@"cmsCategoryID"] intValue];
        if (!simple.isValid) {
            return nil;
        }
        [tempArray addObject:simple];
    }
    homeInfo.bannerArray = [NSArray arrayWithArray:tempArray];
    
    homeInfo.bannerHeight = [info[@"bannerHeight"] intValue];
    homeInfo.bannerWidth = [info[@"bannerWidth"] intValue];
    [tempArray removeAllObjects];
//  张 ads
    NSArray *barNodes = info[@"barNodes"];
    for (int i = 0 ; i< barNodes.count; i++) {
        BYHomeNavInfo *simple = [[BYHomeNavInfo alloc]init];
        simple.name = barNodes[i][@"name"];
        simple.link = barNodes[i][@"imgurl"];
        simple.imgurl = barNodes[i][@"iconimg"];
        if (barNodes[i][@"barNodes"]) {
            NSMutableArray *secTmpArray = [[NSMutableArray alloc]init];
            NSArray *secondsArray = barNodes[i][@"barNodes"];
            for (int j = 0; j < secondsArray.count; j++) {
                BYHomeNavInfo *second = [[BYHomeNavInfo alloc]init];
                second.name = secondsArray[j][@"name"];
                second.link = secondsArray[j][@"imgurl"];
                [secTmpArray addObject:second];
            }
            simple.secondArray = secTmpArray;
            
        }
        [tempArray addObject:simple];
    }
    homeInfo.barNodesArray = [NSArray arrayWithArray:tempArray];
    [tempArray removeAllObjects];
    
    
    NSArray *floorsArray = info[@"adFloorList"];
    for (int i = 0 ; i< floorsArray.count; i++) {
        BYHomeFloorInfo *simple = [[BYHomeFloorInfo alloc]init];
//        simple.title = floorsArray[i][@"title"]; 首页文字标题
//        simple.subtitle = floorsArray[i][@"subtitle"];
        simple.imgtitle = floorsArray[i][@"imgtitle"];
        if (floorsArray[i][@"ads"]) {
            NSMutableArray *secTmpArray = [[NSMutableArray alloc]init];
            NSArray *secondsArray = floorsArray[i][@"ads"];
            for (int j = 0; j < secondsArray.count; j++) {
                BYHomeInfoSimple *simple = [[BYHomeInfoSimple alloc]init];
                simple.imagePath = secondsArray[j][@"img"];
                simple.link = secondsArray[j][@"link"];
                simple.categoryID = [secondsArray[j][@"cmsCategoryID"] intValue];
                [secTmpArray addObject:simple];
            }
            simple.adsArray = secTmpArray;
            
        }
        [tempArray addObject:simple];
    }
    homeInfo.floorArray = [NSArray arrayWithArray:tempArray];
    [tempArray removeAllObjects];

    
    
    
//    NSArray * bbsArray = info[@"bbsAds"];
//    for (int i = 0 ; i< bbsArray.count; i++) {
//        BYHomeInfoSimple * simple = [[BYHomeInfoSimple alloc]init];
//        simple.imagePath = bbsArray[i][@"img"];
//        simple.link = bbsArray[i][@"link"];
//        simple.type = [bbsArray[i][@"type"] intValue];
//        simple.title = bbsArray[i][@"title"];
//        if (!simple.isValid) {
//            return nil;
//        }
//        [tempArray addObject:simple];
//    }
//    homeInfo.bbsArray = [NSArray arrayWithArray:tempArray];
//    
//    homeInfo.bbsTitle = [NSString stringWithFormat:@"%@/",info[@"bbsMainTitle"]];
//    homeInfo.bbsHalfTitle = info[@"bbsHalfTitle"];
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
/*
 -(void)visitDict:(NSDictionary *)dict{
 NSArray *keys=[dict allKeys];
 for (NSString *key in keys) {
 NSString *result=[NSString stringWithFormat:@"key=%@,value=%@",key,[dict objectForKey:key]];
 NSLog(result);
 if([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]){
 [self visitDict:[dict objectForKey:key]];
 }
 }
 }
 */
@end
