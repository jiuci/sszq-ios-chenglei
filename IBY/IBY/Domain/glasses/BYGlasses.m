//
//  BYGlassesUnit.m
//  IBY
//
//  Created by panshiyu on 15/5/6.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYGlasses.h"

@implementation BYGlasses

+ (NSDictionary*)JSONKeyPathsByPropertyKey
{
    return @{
             @"designId" : @"designId",
             @"imgURL" : @"imgURL",
             @"infoURL" : @"infoURL",
             @"smallImgURL" : @"smallImgURL",
             @"faceWidth" : @"width"
             };
}

@end
