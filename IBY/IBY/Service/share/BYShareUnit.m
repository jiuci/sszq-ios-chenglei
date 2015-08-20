//
//  SAKShareUnit.m
//  IBY
//
//  Created by panshiyu on 15/1/20.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYShareUnit.h"

@implementation BYShareUnit

+ (id)shareUnitByMedia:(SAKShareMedia)media
                 title:(NSString*)title
               content:(NSString*)content
             detailURL:(NSString*)detailURL
            thumbImage:(UIImage*)thumbImage
              thumbURL:(NSString*)thumbURL
                  logo:(UIImage*)logoImage
{
    BYShareUnit* unit = [[BYShareUnit alloc] init];
    unit.shareMedia = media;
    unit.title = title;
    unit.content = content;
    unit.detailURLString = detailURL;
    unit.thumbImage = thumbImage;
    unit.thumbURL = thumbURL;
    unit.logoImage = logoImage;
    return unit;
}

@end
