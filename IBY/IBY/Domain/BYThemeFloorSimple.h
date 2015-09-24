//
//  BYThemeFloorSimple.h
//  IBY
//
//  Created by forbertl on 15/9/14.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYHomeInfoSimple.h"
@interface BYThemeFloorSimple : NSObject
@property(nonatomic , strong)NSMutableArray * simples;
@property(nonatomic , copy)NSString * mainTitle;
@property(nonatomic , copy)NSString * subTitle;
@property(nonatomic , copy)NSString * imageTitle;
@property(nonatomic)int column;
@property(nonatomic)int height;
@property(nonatomic)int width;

@end
