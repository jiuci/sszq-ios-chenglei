//
//  BYEPasswordViewController.h
//  IBY
//
//  Created by coco on 14-9-11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYForgetPasswordService.h"

@interface BYPasswordSettingVC : BYBaseVC<UITextFieldDelegate>
@property (strong, nonatomic) BYForgetPasswordService* passwordService;

@end
