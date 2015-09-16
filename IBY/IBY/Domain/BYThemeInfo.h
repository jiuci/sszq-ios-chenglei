//
//  BYThemeInfo.h
//  IBY
//
//  Created by forbertl on 15/9/11.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYHomeInfoSimple.h"
#import "BYThemeFloorSimple.h"

@interface BYThemeInfo : NSObject


@property(nonatomic, copy)NSString * title;
@property(nonatomic, strong)BYHomeInfoSimple * headerInfo;
@property(nonatomic, strong)NSMutableArray * floors;
@property(nonatomic, strong)NSMutableArray * products;

+ (instancetype)themeWithDict:(NSDictionary*)info;
@end
