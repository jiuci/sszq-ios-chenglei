//
//  BYError.m
//  IBY
//
//  Created by panShiyu on 14-9-10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYError.h"

@implementation BYError

- (NSString*)msgWithDefault:(NSString*)des
{
    NSString* str = des;
    if (self && (self.userInfo[@"msg"] || self.userInfo[@"message"])) {
        str = self.userInfo[@"msg"] ? self.userInfo[@"msg"] : self.userInfo[@"message"];
    }
    return str;
}
- (NSString*)netMessage {
    NSString* str = @"";
    if ((self.userInfo[@"msg"] || self.userInfo[@"message"])) {
        str = self.userInfo[@"msg"] ? self.userInfo[@"msg"] : self.userInfo[@"message"];
    }
    return str;
}

@end

BYError* makeCustomError(BYFuError type,NSString* domain,NSString *desc,NSError*originError) {
    BYError *err = [[BYError alloc] init];;
    if (originError) {
        err = [BYError errorWithDomain:originError.domain code:originError.code userInfo:originError.userInfo];
    }
    err.byErrorCode = type;
    err.byDomain = domain;
    err.byErrorMsg = desc;
    return err;
}

BYError* makeNetDecodeError(BYError* err)
{
    return  makeCustomError(BYFuErrorCannotDecode, @"com.biyao.network.decode", @"decode error", err);
}

BYError* makeTransferNetError(NSDictionary* eDict)
{
    return [BYError errorWithDomain:@"com.biyao.network.decode" code:[eDict[@"code"] integerValue] userInfo:eDict];
}

BYError* makeNetError(NSError* e)
{
    return [BYError errorWithDomain:e.domain code:e.code userInfo:e.userInfo];
}

