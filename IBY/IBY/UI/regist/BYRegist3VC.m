//
//  BYRegist3VC.m
//  IBY
//
//  Created by panshiyu on 15/1/4.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYRegist3VC.h"
#import "BYRegistService.h"
#import "BYLoginVC.h"
#import "BYLoginService.h"
#import "BYAutosizeBgButton.h"

@interface BYRegist3VC ()
@property (weak, nonatomic) IBOutlet UITextField* firstPwdTextField;
@property (weak, nonatomic) IBOutlet UIImageView* bgInput;
@property (weak, nonatomic) IBOutlet UIImageView* iconInputLeftView;
@property (weak, nonatomic) IBOutlet BYAutosizeBgButton* btnNext;
@end

@implementation BYRegist3VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置密码";

    //_registService = [[BYRegistService alloc] init];
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
    self.btnNext.enabled = NO;
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
    NSString* user = _registService.phone;
    NSString* pwd = self.firstPwdTextField.text;
//    NSString* smsCode = self.registService.verifyCode;
    [MBProgressHUD topShow:@"注册中..."];
    [self.registService registByUser:user pwd:pwd finsh:^(BOOL success, BYError* error) {
        [MBProgressHUD topHide];
        if(error){
            alertError(error);
        }else{
            [MBProgressHUD topShowTmpMessage:@"恭喜，注册成功"];
            runBlockAfterDelay(2, ^{
                runOnBackgroundQueue(^{
                    BYLoginService *loginService = [[BYLoginService alloc] init];
                    [loginService loginByUser:user pwd:pwd finish:^(BYUser *user, BYError *error) {
                        //TODO:在后台自动登录，不用处理失败的情况?
                    }];
                });
//                [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome];
                for (UIViewController * controller in self.navigationController.viewControllers) {
                    if ([controller.class isSubclassOfClass:[BYLoginVC class]]) {
                        BYLoginVC * bylogin = (BYLoginVC*) controller;
                        if (bylogin.successBlk) {
//                            [MBProgressHUD topShow:@"登录成功!"];
                            bylogin.successBlk();
                            
                        }else{
//                            [MBProgressHUD showSuccess:@"登录成功!"];
                            
                            
                            [bylogin.navigationController
                             dismissViewControllerAnimated:YES
                             completion:^{
                                 
                             }];
                        }
                        
                        return;
                    }
                }
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
