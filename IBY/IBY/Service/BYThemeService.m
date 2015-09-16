//
//  BYThemeService.m
//  IBY
//
//  Created by forbertl on 15/9/11.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYThemeService.h"
#import "BYThemeEngine.h"

@implementation BYThemeService
- (void)loadThemePage:(int)pageNumber type:(int)type finish:(void (^)(BYThemeInfo * info, BYError* error))finished
{
    [BYThemeEngine loadThemePage:pageNumber type:type finish:finished];
}
@end
