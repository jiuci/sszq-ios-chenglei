//
//  BYRegistViewController.h
//  IBY
//
//  Created by panShiyu on 14-9-9.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYRegistService.h"

typedef void (^BYRegisterSuccessBlock)();
@interface BYRegist1VC : BYBaseVC

@property (weak, nonatomic) IBOutlet UITextField* phoneNumTextField;
@property (nonatomic, strong) BYRegistService* registService;
@property (nonatomic, strong) NSString* phone;
@end
