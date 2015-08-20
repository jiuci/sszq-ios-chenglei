//
//  BYBanner.h
//  IBY
//
//  Created by coco on 14-9-11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BYBannerTypeDetail = 2,
    BYBannerTypeMWeb = 1,

} BYBannerType;

@interface BYBanner : NSObject

@property (nonatomic, copy) NSString* adTitle;
@property (nonatomic, copy) NSString* imgUrl;
@property (nonatomic, strong) NSNumber* priority;
@property (nonatomic, copy) NSString* linkUrl;
@property (nonatomic, assign) BYBannerType type; //1 murl ,2 designId

@property (nonatomic, strong) NSDictionary* params;
@end
