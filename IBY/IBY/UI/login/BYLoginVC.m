//
//  BYLoginViewController.m
//  IBY
//
//  Created by panShiyu on 14-9-9.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYLoginVC.h"

#import "BYUserService.h"
#import "BYRegist1VC.h"
#import "BYForgetPasswordVC.h"

#import "BYLoginMenu.h"
#import "BYCaptchaView.h"

#import <TPKeyboardAvoidingScrollView.h>

@interface BYLoginVC () <UITextFieldDelegate>

@property (assign, nonatomic) int countForLoginTimes; //用于标识输入了几次手机号和密码

@property (weak, nonatomic) IBOutlet UITextField* userTextField;
@property (weak, nonatomic) IBOutlet UITextField* pwdTextField;

@property (nonatomic, strong) BYLoginMenu* loginMenu;
@property (nonatomic, strong) BYCaptchaView* captchaView;

@property (nonatomic, strong) BYUserService* loginService;

@property (nonatomic, weak) UIScrollView* bodyView;
@end

@implementation BYLoginVC

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    _bodyView = (UIScrollView*)self.view;

    _loginService = [[BYUserService alloc] init];
    [self setupUI];

    self.autoHideKeyboard = YES;

    self.pwdTextField.bk_shouldReturnBlock = ^(UITextField* textField) {
        [self onLogin];
        return YES;
    };

    self.pwdTextField.bk_shouldBeginEditingBlock = ^(UITextField* textField) {
        [self.bodyView TPKeyboardAvoiding_scrollToActiveTextField];
        return YES;
    };

    self.userTextField.bk_shouldBeginEditingBlock = ^(UITextField* textField) {
        [self.bodyView TPKeyboardAvoiding_scrollToActiveTextField];
        return YES;
    };
}
- (void)setupUI
{

    //nav
    self.title = @"账户登录";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backBarItem:^(id sender) {
        [self setEditing:NO];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];

    //user&pwd
    _userTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* accountImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login"]];
    accountImgView.contentMode = UIViewContentModeScaleAspectFit;
    accountImgView.frame = CGRectMake(16, 16, 32, 18);
    _userTextField.leftView = accountImgView;

    _pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* passwordImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password"]];
    passwordImgView.contentMode = UIViewContentModeScaleAspectFit;
    passwordImgView.frame = CGRectMake(16, 16, 32, 18);
    _pwdTextField.leftView = passwordImgView;

    //captchaView
    _captchaView = [BYCaptchaView captchaView];
    _captchaView.top = self.pwdTextField.bottom;
    _captchaView.hidden = YES;
    [self.view addSubview:_captchaView];

    //loginMenu
    _loginMenu = [BYLoginMenu loginMenu];
    _loginMenu.top = self.pwdTextField.bottom;
    [_loginMenu.loginBtn addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
    [_loginMenu.registBtn addTarget:self action:@selector(onRegist) forControlEvents:UIControlEventTouchUpInside];
    [_loginMenu.forgetPwdBtn addTarget:self action:@selector(onForgotPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginMenu];
}

- (void)updateUI
{
    if (_countForLoginTimes > 3) {
        if (self.captchaView.hidden) {
            runOnMainQueue(^{
                [UIView animateWithDuration:0.3 animations:^{
                    self.captchaView.hidden = NO;
                    self.loginMenu.top = self.captchaView.bottom;
                } completion:^(BOOL finished) {
                    [self.captchaView refreshCaptchaImage];
                }];
            });
        }
    }
    else {
        _loginMenu.top = _pwdTextField.bottom;
        _captchaView.hidden = YES;
    }
}

#pragma mark - 按钮处理

- (void)onLogin
{
    [self.view endEditing:YES];

    if (self.userTextField.text.length < 1 || self.pwdTextField.text.length < 1) {
        [MBProgressHUD showSuccess:@"请输入用户名和密码"];
        return;
    }

    if (![self.userTextField.text isMobilePhoneNumber]) {
        [MBProgressHUD topShowTmpMessage:@"手机号格式有误，请重新输入"];
        return;
    }

    if (!_captchaView.hidden) {
        [_captchaView valueCheckWithSuccessBlock:^{
            [self didLogin];
        }];
    }
    else {
        [self didLogin];
    }
}

- (void)didLogin
{

    self.countForLoginTimes++;

    [MBProgressHUD topShow:@"登录中..."];

    [self.loginService loginByUser:self.userTextField.text pwd:self.pwdTextField.text finish:^(BYUser* user, BYError* error) {
        [MBProgressHUD topHide];
        if (user && !error) {
            [MBProgressHUD showSuccess:@"登录成功!"];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                if (_successBlk) {
                    _successBlk();
                }
            }];
            
        }else {
            alertError(error);
            [self updateUI];
        }
    }];
}

- (void)onRegist
{
    BYRegist1VC* registVc = [[BYRegist1VC alloc] init];
    [self.navigationController pushViewController:registVc animated:YES];
}

- (void)onForgotPassword
{
    BYForgetPasswordVC* phoneNumVc = [[BYForgetPasswordVC alloc] init];
    [self.navigationController pushViewController:phoneNumVc animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField == self.userTextField) {
        //验证手机号输入是否符合规则

        NSString* phoneNum = textField.text;
        BOOL isMobileNumber = [phoneNum isMobilePhoneNumber];

        if (!isMobileNumber) {
            [MBProgressHUD topShowTmpMessage:@"手机号格式有误，请重新输入"];
            return NO;
        }
        else {
            [self.pwdTextField becomeFirstResponder];
        }
    }
    else {
        [self onLogin];
    }
    return YES;
}

@end

BYNavVC* makeLoginnav(BYLoginSuccessBlock blk)
{
    BYLoginVC* vc = [[BYLoginVC alloc] init];
    vc.successBlk = blk;

    BYNavVC* nav = [BYNavVC nav:vc title:@"登录"];

    return nav;
}
