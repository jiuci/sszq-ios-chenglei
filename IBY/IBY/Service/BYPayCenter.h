//
//  BYPayCenter.h
//  IBY
//
//  Created by panshiyu on 15/1/28.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYPayService.h"

typedef enum {
    BYPayMethodCaifutong = 1,
    BYPayMethodWeixin = 2,
    BYPayMethodZhifubao = 3,
} BYPayMethod;

@interface BYPayCenter : NSObject

@property (nonatomic, assign) BYPayMethod payMethod;
@property (nonatomic, strong) BYPayPrepareInfo* preInfo;

+ (instancetype)payCenter;

- (void)payByPrepareInfo:(BYPayPrepareInfo*)info
                  method:(BYPayMethod)method
                  fromVC:(UIViewController*)fromVC;

- (void)preCheckPayStatus;

@end
