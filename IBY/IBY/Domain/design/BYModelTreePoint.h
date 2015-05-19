//
//  BYModelTreePoint.h
//  IBY
//
//  Created by St on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYBaseDomain.h"

@interface BYModelTreePoint : BYBaseDomain

@property (nonatomic, assign) int category_id;
@property (nonatomic, assign) int tree_id;
@property (nonatomic, assign) int layer;
@property (nonatomic, assign) int model_part_id;
@property (nonatomic, assign) int parent_id;
@property (nonatomic, assign) int root_id;

@property (nonatomic, copy) NSString* tree_name;
@property (nonatomic, copy) NSString* model_name;

@property (nonatomic, copy) BYModelTreePoint* parent;
@property (nonatomic, copy) NSMutableArray* childList;
@property (nonatomic, copy) NSMutableArray* modelList;

@property (nonatomic, strong) NSArray* displayChildList;

- (id)initWithData:(NSDictionary*)dict;

@end
