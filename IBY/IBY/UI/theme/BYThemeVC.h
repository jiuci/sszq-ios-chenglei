//
//  BYThemeVC.h
//  IBY
//
//  Created by forbertl on 15/9/11.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"
@class BYThemeInfo;
@interface BYThemeVC : BYBaseVC
//+ (instancetype)sharedTheme;
@property (nonatomic, assign)int categoryID;
@property (nonatomic, assign)BOOL testType;
@property (nonatomic)BYThemeInfo * info;
@property(nonatomic, copy)NSString * url;
+ (instancetype)sharedTheme;
+ (instancetype)sharedThemeWithId:(int)categoryID;
+ (instancetype)testThemeWithId:(int)categoryID;
@end
