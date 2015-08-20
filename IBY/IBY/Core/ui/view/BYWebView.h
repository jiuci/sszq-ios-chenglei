//
//  BYWebView.h
//  IBY
//
//  Created by panshiyu on 15/3/2.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYCommonWebVC;
@interface BYWebView : UIWebView

@property (nonatomic, weak) BYCommonWebVC* parentVC;
@end

typedef enum {
    BYH5TypeDefault = 0,
    BYH5TypeDesignDetail = 1,
    BYH5TypeLogin = 2,
    BYH5TypeLogout = 3,
    BYH5TypeMessagelist = 4,
    BYH5TypeBookCheckout = 5,
    BYH5TypePreloadDetails = 6,
    BYH5TypeHome = 7,
    BYH5TypeBook = 8,
    BYH5TypeRegist = 9,
    BYH5TypeShare = 10,
    BYH5TypeSetting = 11,
    BYH5TypeGoWeixinAuth = 12,
    BYH5TypeGlassWearing = 13,
} BYH5Type;

@interface BYH5Unit : NSObject

@property (nonatomic, copy) NSString* des;
@property (nonatomic, assign) BYH5Type type;
@property (nonatomic, copy) NSDictionary* h5Params;

+ (instancetype)unitWithH5Info:(NSDictionary*)info;

- (void)runFromVC:(UIViewController*)fromVC;

@end
