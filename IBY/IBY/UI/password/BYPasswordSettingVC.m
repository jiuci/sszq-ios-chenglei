//
//  BYEPasswordViewController.m
//  IBY
//
//  Created by coco on 14-9-11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYPasswordSettingVC.h"
#import "BYLoginService.h"
#import "BYLoginVC.h"
#import "BYAutosizeBgButton.h"

@interface BYPasswordSettingVC ()

@property (weak, nonatomic) IBOutlet UITextField* firstPwdTextField;
@property (weak, nonatomic) IBOutlet UIImageView* bgInput;
@property (weak, nonatomic) IBOutlet UIImageView* iconInputLeftView;
@property (weak, nonatomic) IBOutlet BYAutosizeBgButton* btnNext;
@end

@implementation BYPasswordSettingVC {
    BOOL _showPassword;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置新密码";
    _showPassword = YES;
    self.btnNext.enabled = NO;
    [self.firstPwdTextField setBk_didBeginEditingBlock:^(UITextField* txtField) {
        self.iconInputLeftView.highlighted = YES;
        self.bgInput.highlighted = YES;
    }];
    
    [self.firstPwdTextField setBk_didEndEditingBlock:^(UITextField* txtField) {
        self.iconInputLeftView.highlighted = NO;
        self.bgInput.highlighted = NO;
    }];
    [self.firstPwdTextField setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField* txtField, NSRange range, NSString* str) {
        NSString* realStr = [txtField.text stringByReplacingCharactersInRange:range withString:str];
        self.btnNext.enabled = realStr&&[realStr length]>0;
        return YES;
    }];
    self.btnNext.enabled = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.firstPwdTextField becomeFirstResponder];
    
}
- (IBAction)commitOnclick
{
    [self.view endEditing:YES];

    if (![self.firstPwdTextField.text isValidPassword]) {
        [MBProgressHUD topShowTmpMessage:@"密码需为字母，数字，符号两种以上组合，请重新输入"];
        [self.firstPwdTextField becomeFirstResponder];
        return;
    }
    NSString* user = _passwordService.phone;
    NSString* pwd = self.firstPwdTextField.text;
    [self.passwordService resetPassword:pwd finish:^(BOOL success, BYError* error) {
            if(error){
                alertError(error);
            }else{
                [MBProgressHUD topShow:@"恭喜！密码修改成功，请重新登录"];
                runBlockAfterDelay(1, ^{
                    [MBProgressHUD topHide];
                    for (UIViewController * controller in self.navigationController.viewControllers) {
                        if ([controller.class isSubclassOfClass:[BYLoginVC class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                            return;
                        }
                    }
                    runOnMainQueue(^{
                        [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome];
                    });
                    
                    
                    runOnBackgroundQueue(^{
                        BYLoginService *loginService = [[BYLoginService alloc] init];
                        [loginService loginByUser:user pwd:pwd finish:^(BYUser *user, BYError *error) {
                            //TODO:在后台自动登录，不用处理失败的情况?
                        }];
                    });
                    
                });
                
            }
    }];
}

- (IBAction)refreshClick:(UIButton*)sender
{
    _showPassword = !_showPassword;
    if (_showPassword) {
        [sender setTitle:@"隐藏密码" forState:UIControlStateNormal];
        [self.firstPwdTextField setSecureTextEntry:NO];
    }
    else {
        [sender setTitle:@"显示密码" forState:UIControlStateNormal];
        [self.firstPwdTextField setSecureTextEntry:YES];
    }
    //
//    [self.firstPwdTextField becomeFirstResponder];
    self.firstPwdTextField.text = self.firstPwdTextField.text;
}


@end
