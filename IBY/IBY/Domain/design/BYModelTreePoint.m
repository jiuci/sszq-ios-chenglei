//
//  BYModelTreePoint.m
//  IBY
//
//  Created by St on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYModelTreePoint.h"

@implementation BYModelTreePoint

- (id)initWithData:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        _tree_id = [dict[@"id"] intValue];
        _layer = [dict[@"layer"] intValue];
        _model_part_id = [dict[@"model_part_id"] intValue];
        _parent_id = [dict[@"parent_id"] intValue];
        _root_id = [dict[@"root_id"] intValue];
        _tree_name = dict[@"tree_name"];
        _model_name = dict[@"model_name"];
    }
    return self;
}

- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{
        @"tree_id" : @"id",
        @"layer" : @"layer",
        @"model_part_id" : @"model_part_id",
        @"parent_id" : @"parent_id",
        @"root_id" : @"root_id",
        @"tree_name" : @"tree_name",
        @"model_name" : @"model_name",
    };
}

+ (NSDictionary*)JSONKeyPathsByPropertyKey
{
    return @{
        @"tree_id" : @"id",
        @"layer" : @"layer",
        @"model_part_id" : @"model_part_id",
        @"parent_id" : @"parent_id",
        @"root_id" : @"root_id",
        @"tree_name" : @"tree_name",
        @"model_name" : @"model_name",
    };
}

- (NSMutableArray*)modelList
{
    if (!_modelList) {
        _modelList = [NSMutableArray array];
    }
    return _modelList;
}

- (NSMutableArray*)childList
{
    if (!_childList) {
        _childList = [NSMutableArray array];
    }
    return _childList;
}

- (NSArray*)displayChildList
{
    NSArray* list = [self.childList sortedArrayUsingComparator:^NSComparisonResult(BYModelTreePoint* obj1, BYModelTreePoint* obj2) {
        if (obj1.tree_id < obj2.tree_id) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
    return list;
}

@end
