//
//  BYPartCategoryRelation.m
//  IBY
//
//  Created by St on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYPartCategoryRelation.h"

@implementation BYPartCategoryRelation

- (NSMutableArray*)modelList
{
    if (!_modelList) {
        _modelList = [NSMutableArray array];
    }
    return _modelList;
}

@end
