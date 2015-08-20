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


@property(nonatomic,strong)NSDictionary * data;

+ (instancetype)homeWithDict:(NSDictionary*)info;
+ (instancetype)loadInfo;
@end
