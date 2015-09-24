//
//  BYThemeInfo.m
//  IBY
//
//  Created by forbertl on 15/9/11.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYThemeInfo.h"
@interface BYThemeInfo()

@property(nonatomic, copy)NSDictionary * info;
@end
@implementation BYThemeInfo

+ (instancetype)themeWithDict:(NSDictionary*)info
{
//    NSLog(@"%@",info);
    BYThemeInfo * themeinfo = [[BYThemeInfo alloc]init];
    themeinfo.info = info;
    themeinfo.title = info[@"title"];
    themeinfo.layout = info[@"layout"];
    
    BYHomeInfoSimple * header = [[BYHomeInfoSimple alloc]init];
    header.height = [info[@"header"][@"height"] intValue];
    header.width = [info[@"header"][@"width"] intValue];
    
//    NSLog(@"%d,%d",header.height,header.width);
    header.imagePath = info[@"header"][@"img"];
    header.link = info[@"header"][@"link"];
    themeinfo.headerInfo = header;
    
    //floors
    themeinfo.floors = [NSMutableArray array];
    NSArray* floorsData = info[@"floor"];
    for (int i = 0; i<[floorsData count]; i++) {
        BYThemeFloorSimple * simple = [[BYThemeFloorSimple alloc] init];
        simple.height = [floorsData[i][@"height"] intValue];
        simple.width = [floorsData[i][@"width"] intValue];
        simple.column = [floorsData[i][@"column_num"] intValue];
        simple.imageTitle = floorsData[i][@"imgTitle"];
        simple.mainTitle = floorsData[i][@"mainTitle"];
        simple.subTitle = floorsData[i][@"subTitle"];
        simple.simples = [NSMutableArray array];
        NSArray* items = floorsData[i][@"item"];
//        NSLog(@"%@",items);
        for (int j = 0; j<items.count; j++) {
            BYHomeInfoSimple * infosimple = [[BYHomeInfoSimple alloc]init];
            infosimple.height = [items[j][@"height"] intValue];
            infosimple.width = [items[j][@"width"] intValue];
            infosimple.imagePath = items[j][@"img"];
            infosimple.link = items[j][@"link"];
            [simple.simples addObject:infosimple];
        }
        [themeinfo.floors addObject:simple];
    }
    
    //product
    themeinfo.products = [NSMutableArray array];
    NSArray * productDetail = info[@"productDetail"];
    for (int i = 0; i<productDetail.count; i++) {
        BYHomeInfoSimple * simple = [[BYHomeInfoSimple alloc]init];
        simple.height = [productDetail[i][@"height"] intValue];
        simple.width = [productDetail[i][@"width"] intValue];
        simple.imagePath = productDetail[i][@"img"];
        simple.link = productDetail[i][@"link"];
        [themeinfo.products addObject:simple];
    }
    return themeinfo;
}

-(BOOL)isSameTo:(BYThemeInfo*)another
{
    return [_info isEqual:another.info];
}

@end
