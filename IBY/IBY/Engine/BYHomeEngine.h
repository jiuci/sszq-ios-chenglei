//
//  BYHomeEngine.h
//  IBY
//
//  Created by kangjian on 15/8/18.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseEngine.h"
@class BYHomeInfo;
@interface BYHomeEngine : BYBaseEngine
+ (void)loadHomePagefinish:(void (^)(BYHomeInfo * info, BYError* error))finished;
@end
