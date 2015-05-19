//
//  BYFCodeService.m
//  IBY
//
//  Created by panshiyu on 15/3/3.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYFCodeService.h"

@implementation BYFCodeService

+ (void)verifyFCode:(NSString*)fcode finish:(void (^)(BOOL success, BOOL needRevokeFCode, BYError* error))finished
{
    NSString* url = @"/fcode/validatefcode";
    //  case 220001:f码不存在
    //	case 220002:时间 不在范围内
    //	case 220003:f码被用过了(例如：已创建订单)
    //	case 220004:购物车重复使用f码
    NSDictionary* params = @{
        @"f_code" : fcode,
        @"uid" : @([BYAppCenter sharedAppCenter].user.userID)
    };
    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if (error) {
            if (isFCodeError(error)) {
                finished(NO,YES,error);
            }else{
                finished(NO,NO,error);
            }
        }else{
            finished(YES,NO,nil);
        }
    }];
}

@end

BOOL isFCodeError(BYError* error)
{
    if (error.userInfo[@"code"]) {
        int errorCode = [error.userInfo[@"code"] intValue];
        if (errorCode == 220001 || errorCode == 220002 || errorCode == 220003 || errorCode == 220004) {
            return YES;
        }
    }
    return NO;
}
