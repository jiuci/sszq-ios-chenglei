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

@end
