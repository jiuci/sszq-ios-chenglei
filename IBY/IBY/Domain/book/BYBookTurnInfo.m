//
//  BYBookTurnInfo.m
//  IBY
//
//  Created by panshiyu on 15/3/11.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBookTurnInfo.h"

@implementation BYBookTurnInfo

- (id)initWithDict:(NSDictionary*)data
{
    self = [super init];
    if (self) {

        _bookedNum = [data[@"bookedNum"] intValue];
        _turnId = [data[@"turnId"] intValue];

        if (data[@"currentServerTime"]) {
            _currentServerTime = [NSDate dateWithTimeIntervalSince1970:[data[@"currentServerTime"] doubleValue] / 1000];
        }

        if (data[@"saleEndtime"]) {
            _saleEndtime = [NSDate dateWithTimeIntervalSince1970:[data[@"saleEndtime"] doubleValue] / 1000];
        }

        if (data[@"saleStartTime"]) {
            _saleStartTime = [NSDate dateWithTimeIntervalSince1970:[data[@"saleStartTime"] doubleValue] / 1000];
        }

        _isNext = NO;
        if (_currentServerTime && _saleStartTime && _saleEndtime) {
            if ([_currentServerTime compare:_saleEndtime] != NSOrderedDescending && [_currentServerTime compare:_saleStartTime] != NSOrderedAscending) {
                _isNext = YES;
            }
        }
    }
    return self;
}

@end
