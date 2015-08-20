//
//  BYProductDurationService.m
//  IBY
//
//  Created by panshiyu on 14/12/30.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYProductDurationService.h"

@implementation BYProductDurationService

+ (void)fetchProductDuration:(int)designId
                      finish:(void (^)(int duration, BYError* error))finished {
    NSString* url = @"productstyle/getDuration4Product";
    NSDictionary* params = @{
                             @"design_id" : @(designId),
                             };
    [BYNetwork get:url params:params isCacheValid:YES finish:^(NSDictionary *data, BYError *error) {
        if (error) {
            finished(0,error);
        }else{
            finished([data[@"durations"] intValue],nil);
        }
    }];
}

@end
