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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"重置登陆密码";
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
        if (realStr.length > 32) {
            return NO;
        }
        self.btnNext.enabled = realStr&&[realStr length]>0;
        return YES;
    }];
    [self.firstPwdTextField setBk_shouldClearBlock:^BOOL(UITextField* txtField){
        self.btnNext.enabled = NO;
        return YES;
    }];
    self.autoHideKeyboard = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.firstPwdTextField becomeFirstResponder];
    
}
- (IBAction)commitOnclick
{
    [self.view endEditing:YES];
    if (self.firstPwdTextField.text.length<6) {
        [MBProgressHUD topShowTmpMessage:@"密码不能小于6位字符，请重新输入"];
        [self.firstPwdTextField becomeFirstResponder];
        return;
    }
    if (![self.firstPwdTextField.text isValidPassword]) {
        [MBProgressHUD topShowTmpMessage:@"密码需为字母、数字、符号两种以上组合，请重新输入"];
        [self.firstPwdTextField becomeFirstResponder];
        return;
    }
    NSString* user = _passwordService.phone;
    NSString* pwd = self.firstPwdTextField.text;
    [self.passwordService resetPassword:pwd finish:^(BOOL success, BYError* error) {
            if(error){
                alertError(error);
            }else{
                [MBProgressHUD topShowTmpMessage:@"恭喜！密码修改成功，请重新登录"];
                runBlockAfterDelay(2, ^{
                    for (UIViewController * controller in self.navigationController.viewControllers) {
                        if ([controller.class isSubclassOfClass:[BYLoginVC class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                            BYLoginVC * loginVC = (BYLoginVC*)controller;
                            loginVC.userTextField.text = self.passwordService.phone;
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
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.firstPwdTextField setSecureTextEntry:NO];
    }
    else {
        [self.firstPwdTextField setSecureTextEntry:YES];
    }
    [self.view endEditing:YES];
//    [self.firstPwdTextField becomeFirstResponder];
//    self.firstPwdTextField.text = self.firstPwdTextField.text;
}


@end
