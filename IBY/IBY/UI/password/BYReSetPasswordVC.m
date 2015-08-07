//
//  BYReSetPasswordVC.m
//  IBY
//
//  Created by panshiyu on 14/11/7.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYReSetPasswordVC.h"
#import "BYForgetPasswordService.h"
#import "BYAutosizeBgButton.h"
@interface BYReSetPasswordVC () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet BYAutosizeBgButton* btnNext;
@end

@implementation BYReSetPasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";

    _newlyPwdTextField.delegate = self;
    _confirmPwdTextField.delegate = self;
    _oldPwdTextField.delegate = self;
    
    [self setupTextfield:_newlyPwdTextField withBg:_newlyPwdBgImageView icon:nil nextBtn:_btnNext];
    [self setupTextfield:_confirmPwdTextField withBg:_confirmPwdBgImageView icon:nil nextBtn:_btnNext];
    [self setupTextfield:_oldPwdTextField withBg:_oldPwdBgImageView icon:nil nextBtn:_btnNext];

    _btnNext.enabled = NO;
    self.autoHideKeyboard = YES;
}
- (BOOL)shouldEnableBtn:(UITextField *)textfield
{
    BOOL hasInput1 = _oldPwdTextField.text && _oldPwdTextField.text.length > 0
    |textfield == _oldPwdTextField;
    BOOL hasInput2 = _newlyPwdTextField.text && _newlyPwdTextField.text.length > 0
    |textfield == _newlyPwdTextField;
    BOOL hasInput3 = _confirmPwdTextField.text && _confirmPwdTextField.text.length > 0
    |textfield == _confirmPwdTextField;
    return hasInput1 && hasInput2 && hasInput3;
}
- (void)setupTextfield:(UITextField*)textField withBg:(UIImageView*)bgView icon:(UIImageView*)icon nextBtn:(UIButton*)button
{
    [textField setBk_didBeginEditingBlock:^(UITextField* txtField) {
        icon.highlighted = YES;
        bgView.highlighted = YES;
    }];
    
    [textField setBk_didEndEditingBlock:^(UITextField* txtField) {
        icon.highlighted = NO;
        bgView.highlighted = NO;
    }];
    [textField setBk_shouldClearBlock:^BOOL(UITextField* txtField){
        button.enabled = NO;
        return YES;
    }];
    [textField setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField* txtField, NSRange range, NSString* str) {
        NSString* realStr = [txtField.text stringByReplacingCharactersInRange:range withString:str];
        if (realStr.length > 32) {
            return NO;
        }
        button.enabled = realStr&&[realStr length]>0 && [self shouldEnableBtn:txtField];
        return YES;
    }];
}

- (IBAction)commitAction:(UIButton*)sender
{
    if (_oldPwdTextField.text.length != 0 && _newlyPwdTextField.text.length != 0 && _confirmPwdTextField.text.length != 0) {
        [self resetPasswordFun];
    }
    else {
        [MBProgressHUD showError:@"请输入密码"];
    }
}

//重设密码
- (void)resetPasswordFun
{
    if (![_newlyPwdTextField.text isEqualToString:_confirmPwdTextField.text]) {
        [MBProgressHUD topShowTmpMessage:@"确认密码与设置的密码不一致"];
        return;
    }
    if (self.newlyPwdTextField.text.length<6) {
        [MBProgressHUD topShowTmpMessage:@"密码不能小于6位字符"];
        [self.newlyPwdTextField becomeFirstResponder];
        return;
    }
    if (![self.newlyPwdTextField.text isValidPassword]) {
        [MBProgressHUD topShowTmpMessage:@"密码格式错误，请重新输入"];
        [self.newlyPwdTextField becomeFirstResponder];
        return;
    }
    BYForgetPasswordService * pwdService = [[BYForgetPasswordService alloc] init];

    pwdService.phone = [BYAppCenter sharedAppCenter].user.phoneNum;
    __weak BYReSetPasswordVC * wself = self;
    [pwdService resetPassword:_newlyPwdTextField.text oldPassword:_oldPwdTextField.text finish:^(BOOL success, BYError* error) {
        if (success) {
            [MBProgressHUD topShowTmpMessage:@"密码修改成功"];
            [wself.navigationController popViewControllerAnimated:YES];
        }else{
            alertError(error);
        }
    }];
}

#pragma mark -textFieldDelegate
//点击键盘的return按钮时调用方法
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField == _oldPwdTextField) {
        [_newlyPwdTextField becomeFirstResponder]; //field2响应事件
    }
    else if (textField == _newlyPwdTextField) {
        [_confirmPwdTextField becomeFirstResponder];
    }
    else if (textField == _confirmPwdTextField) {
        [self.view endEditing:YES]; //取消编辑状态
        [textField resignFirstResponder];
    }
    return YES;
}

@end
