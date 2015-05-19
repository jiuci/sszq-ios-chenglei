//
//  BYPaySuccessVC.h
//  IBY
//
//  Created by St on 14/12/1.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"
@class BYPayPrepareInfo;

@interface BYPaySuccessVC : BYBaseVC

- (id)initWithResult:(BYPayPrepareInfo*)payResult;

- (void)updatePayresult;

@end
