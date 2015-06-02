//
//  BYLoginMenu.h
//  IBY
//
//  Created by panshiyu on 14/12/23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYAutosizeBgButton.h"

@interface BYLoginMenu : UIView

@property (weak, nonatomic) IBOutlet BYAutosizeBgButton* loginBtn;
@property (weak, nonatomic) IBOutlet UIButton* registBtn;
@property (weak, nonatomic) IBOutlet UIButton* forgetPwdBtn;

+ (instancetype)loginMenu;

@end
