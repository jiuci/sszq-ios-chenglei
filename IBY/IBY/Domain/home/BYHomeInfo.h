//
//  BYHomeInfo.h
//  IBY
//
//  Created by kangjian on 15/8/19.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYHomeInfoSimple.h"
@interface BYHomeInfo : NSObject




@property(nonatomic, assign)int adHeight;
@property(nonatomic, assign)int adWidth;
@property(nonatomic, strong)NSArray * adArray;

@property(nonatomic, assign)int bannerHeight;
@property(nonatomic, assign)int bannerWidth;
@property(nonatomic, strong)NSArray * bannerArray;

@property(nonatomic, assign)int bbsHeight;
@property(nonatomic, assign)int bbsWidth;
@property(nonatomic, strong)NSArray * bbsArray;
@property(nonatomic, strong)NSString * bbsTitle;
@property(nonatomic, strong)NSString * bbsHalfTitle;
//新
@property(nonatomic, strong)NSString * bbsMainTitle;
@property(nonatomic, assign)int adImgTitleWidth;
@property(nonatomic, assign)int adImgTitleHeight;


@property(nonatomic, strong)NSArray * floorArray;

//新轮播图banners中的信息
//@property(nonatomic, assign)int type;
//@property(nonatomic, assign)int sortNum;
//@property(nonatomic, strong)NSString * link;
//@property(nonatomic, strong)NSString * img;
//@property(nonatomic, assign)int cmsCategoryID;
//广告位信息

//导航节点信息 barNodes
@property(nonatomic, strong)NSArray * barNodesArray;









@property(nonatomic,strong)NSDictionary * data;

+ (instancetype)homeWithDict:(NSDictionary*)info;
+ (instancetype)loadInfo;
@end
