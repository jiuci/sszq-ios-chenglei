//
//  BYLoginViewController.h
//  IBY
//
//  Created by panShiyu on 14-9-9.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYNavVC.h"
#import "BYBaseVC.h"

typedef void (^BYLoginSuccessBlock)();

@interface BYLoginVC : BYBaseVC<UITextFieldDelegate>
@property (nonatomic, copy) BYLoginSuccessBlock successBlk;
@end

//quick creater with successBlk
BYNavVC* makeLoginnav(BYLoginSuccessBlock blk);