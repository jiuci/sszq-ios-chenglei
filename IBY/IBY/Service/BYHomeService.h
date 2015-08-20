//
//  BYHomeService.h
//  IBY
//
//  Created by kangjian on 15/8/18.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"
#import "BYHomeInfo.h"
@interface BYHomeService : BYBaseService
- (void)loadHomePagefinish:(void (^)(BYHomeInfo * info, BYError* error))finished;
@end
