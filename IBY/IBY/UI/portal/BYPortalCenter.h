//
//  BYPortalCenter.h
//  IBY
//
//  Created by panshiyu on 14-10-18.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYSingleton.h"

typedef enum {
    BYPortalHome = 0,
    BYPortalLoginFromMineVC = 1,
    BYPortalpay = 9,
    BYPortalHomeWithGlassesId = 10,
} BYPortal;

@interface BYPortalCenter : NSObject

+ (instancetype)sharedPortalCenter;

- (void)portTo:(BYPortal)portalPage;
- (void)portTo:(BYPortal)portalPage params:(NSDictionary*)params;

@end
