//
//  BYPartCategoryRelation.h
//  IBY
//
//  Created by St on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYPartCategoryRelation : NSObject

@property (nonatomic, assign) int category_id;
@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString* icon_url;
@property (nonatomic, assign) BOOL is_deleted;
@property (nonatomic, copy) NSString* part_name;
@property (nonatomic, assign) int part_type;
@property (nonatomic, assign) int priority;
@property (nonatomic, strong) NSMutableArray* modelList;

@end
