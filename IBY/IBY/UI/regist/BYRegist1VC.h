//
//  BYRegistViewController.h
//  IBY
//
//  Created by panShiyu on 14-9-9.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BYRegisterSuccessBlock)();
@interface BYRegist1VC : BYBaseVC
@property (nonatomic, copy) BYRegisterSuccessBlock successBlk;
@end
