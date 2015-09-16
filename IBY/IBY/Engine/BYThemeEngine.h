//
//  BYThemeEngine.h
//  IBY
//
//  Created by forbertl on 15/9/11.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseEngine.h"
@class BYThemeInfo;
@interface BYThemeEngine : BYBaseEngine

+ (void)loadThemePage:(int)pageNumber type:(int)type finish:(void (^)(BYThemeInfo * info, BYError* error))finished;
@end
