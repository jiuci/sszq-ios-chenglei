//
//  BYEditingData.h
//  IBY
//
//  Created by St on 14-11-4.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYEditingData : NSObject

@property (nonatomic, assign) int Width;
@property (nonatomic, assign) int Height;

@property (nonatomic, strong) NSMutableArray* markArray;

@property (nonatomic, strong) NSMutableArray* imgArrayNormal;
@property (nonatomic, strong) NSMutableArray* imgArrayAbove;
@property (nonatomic, strong) NSMutableArray* maskArrayNormal;
@property (nonatomic, strong) NSMutableArray* maskArrayAbove;

@property (nonatomic, strong) NSMutableDictionary* maskDict;

@property (nonatomic, strong) NSMutableArray* maskArray;

@end