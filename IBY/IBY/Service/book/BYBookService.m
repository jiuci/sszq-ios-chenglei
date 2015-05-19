//
//  BYBookService.m
//  IBY
//
//  Created by panshiyu on 15/3/10.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBookService.h"

@implementation BYBookService

- (void)addBook:(BYAddBookUnit*)unit
         finish:(void (^)(NSDictionary* data, NSDate* saleStartTime, BYError* error))finished
{
    NSString* url = @"/book/add";
    NSDictionary* paramsDict = @{
        @"designId" : @(unit.designId),
        @"isNext" : @(unit.isNext),
        @"turnId" : @(unit.turnId),
        @"sizeName" : unit.sizeName,
        @"supplierId" : @(unit.supplierId),
        @"num" : @(unit.num),
        @"customerDesignInfo" : unit.customDesignInfo,
    };
    [BYNetwork post:url
             params:paramsDict
             finish:^(NSDictionary* data, BYError* error) {
                 if (error) {
                     finished(nil,nil,error);
                     /**
                      saleStartTime  本预约轮次开售时间
                      currentServerTime  服务器当前时间
                      */
                 } else {
                     NSDate *time = nil;
                     if (data[@"saleStartTime"]) {
                         time = [NSDate dateWithTimeIntervalSince1970:[data[@"saleStartTime"] doubleValue] / 1000];
                     }
                     finished(data, time,nil);
                 }
             }];
}

- (void)addNextTurnByOriBookId:(int)oriBookId
                        finish:(void (^)(NSDictionary* data, BYError* error))finished
{
    NSString* url = @"/book/addNext";
    NSDictionary* paramsDict = @{
        @"originalBookId" : @(oriBookId)
    };
    [BYNetwork post:url
             params:paramsDict
             finish:^(NSDictionary* data, BYError* error) {
                 if (error) {
                     finished(nil,error);
                     /**
                      saleStartTime  本预约轮次开售时间
                      currentServerTime  服务器当前时间
                      */
                 } else {
                     finished(data, nil);
                 }
             }];
}

- (void)checkoutBookByIds:(NSString*)bookIds
                   finish:(void (^)(NSDictionary* data, BYError* error))finished
{
    NSString* url = @"/book/checkout";
    NSDictionary* paramsDict = @{
        @"productBookIds" : bookIds
    };
    [BYNetwork post:url
             params:paramsDict
             finish:^(NSDictionary* data, BYError* error) {
                 if (error) {
                     finished(nil,error);
                 } else {
                     finished(data, nil);
                 }
             }];
}

@end

BOOL isBookLimitError(BYError* error)
{
    if (error.userInfo[@"code"]) {
        int errorCode = [error.userInfo[@"code"] intValue];
        if (errorCode == 250006) {
            return YES;
        }
    }
    return NO;
}
