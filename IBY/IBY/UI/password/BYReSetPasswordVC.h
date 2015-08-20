//
//  BYReSetPasswordVC.h
//  IBY
//
//  Created by panshiyu on 14/11/7.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"

@interface BYReSetPasswordVC : BYBaseVC<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *newlyPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UIImageView *oldPwdBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *newlyPwdBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *confirmPwdBgImageView;
- (IBAction)commitAction:(UIButton *)sender;


@end
