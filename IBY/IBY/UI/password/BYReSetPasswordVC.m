//
//  BYReSetPasswordVC.m
//  IBY
//
//  Created by panshiyu on 14/11/7.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYReSetPasswordVC.h"
#import "BYPasswordService.h"
@interface BYReSetPasswordVC () <UIGestureRecognizerDelegate>

@end

@implementation BYReSetPasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";

    _newlyPwdTextField.delegate = self;
    _confirmPwdTextField.delegate = self;

    self.autoHideKeyboard = YES;
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
    if ([_oldPwdTextField.text isValidPassword] && [_newlyPwdTextField.text isValidPassword] && [_confirmPwdTextField.text isValidPassword]) {
        if (![_newlyPwdTextField.text isEqualToString:_confirmPwdTextField.text]) {
            [MBProgressHUD topShowTmpMessage:@"确认密码与设置的密码不一致"];
            return;
        }
        else {
            BYPasswordService* pwdService = [[BYPasswordService alloc] init];
            [pwdService resetPassword:_newlyPwdTextField.text finish:^(NSDictionary* data, BYError* error) {
                if (!error &&data) {
                    [MBProgressHUD topShowTmpMessage:@"密码修改成功"];
                }else{
                    alertError(error);
                }
            }];
        }
    }
    else {
        [MBProgressHUD showError:@"新/旧密码格式错误"];
    }
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
