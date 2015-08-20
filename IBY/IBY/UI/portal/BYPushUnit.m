//
//  BYPushUnit.m
//  IBY
//
//  Created by panshiyu on 15/2/12.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYPushUnit.h"

@implementation BYPushUnit

+ (instancetype)unitWithRemoteInfo:(NSDictionary*)info
{
    if (info[@"aps"] && info[@"pushId"]) {
        return [[self alloc] initWithRemoteInfo:info];
    }
    return nil;
}

- (id)initWithRemoteInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        _message = info[@"aps"][@"alert"];
        _pushId = info[@"pushId"];
        _type = [info[@"type"] intValue];
        _pushParams = [info[@"url"] parseURLParams];
    }
    return self;
}

- (NSDictionary*)mapFromQuery:(NSString*)query
{
    if (query.length < 1) {
        return [NSDictionary dictionary];
    }
    NSArray* pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    for (NSString* pair in pairs) {
        NSArray* kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString* val = [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:kv[0]];
        }
    }
    return params;
}

@end
