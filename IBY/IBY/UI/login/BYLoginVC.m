//
//  BYLoginViewController.m
//  IBY
//
//  Created by panShiyu on 14-9-9.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYLoginVC.h"

#import "BYLoginService.h"
#import "BYRegist1VC.h"
#import "BYForgetPasswordVC.h"
#import "BYAutosizeBgButton.h"
#import "BYCaptchaView.h"
#import "BYRegistService.h"
#import "BYAppDelegate.h"
#import <TPKeyboardAvoidingScrollView.h>

#import "WXApi.h"

@interface BYLoginVC () <UITextFieldDelegate,WXApiDelegate>

@property (assign, nonatomic)
    int countForLoginTimes; //用于标识输入了几次手机号和密码


@property (strong, nonatomic) UITextField* pwdTextField;
@property (strong, nonatomic) BYAutosizeBgButton* loginButton;
@property (strong, nonatomic) BYAutosizeBgButton* registButton;
@property (strong, nonatomic) UIButton* forgetPasswordButton;
@property (strong, nonatomic) UIButton* hidePassword;
@property (strong, nonatomic) UIImageView* userBox;
@property (strong, nonatomic) UIImageView* pwdBox;

@property (nonatomic, strong) BYCaptchaView* captchaView;

@property (nonatomic, strong) BYLoginService* loginService;

@property (nonatomic, weak) UIScrollView* bodyView;
@end

@implementation BYLoginVC

#pragma mark - viewDidLoad
+ (instancetype)sharedLoginVC
{
    static BYLoginVC* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    _loginService = [[BYLoginService alloc] init];
    [self setupUI];
    self.view.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    self.autoHideKeyboard = YES;

    _bodyView = (UIScrollView*)self.view;
    __weak UIScrollView* blockbody = _bodyView;
    //    self.pwdTextField.bk_shouldReturnBlock = ^(UITextField* textField) {
    //        [bself onLogin];
    //        return YES;
    //    };

    self.pwdTextField.bk_shouldBeginEditingBlock = ^(UITextField* textField) {
        [blockbody TPKeyboardAvoiding_scrollToActiveTextField];
        return YES;
    };

    self.userTextField.bk_shouldBeginEditingBlock = ^(UITextField* textField) {
        [blockbody TPKeyboardAvoiding_scrollToActiveTextField];
        return YES;
    };
    _countForLoginTimes = 0;
    
}
- (void)loadView
{
    UIScrollView* scroll = [[UIScrollView alloc] init ];//WithFrame:[UIScreen mainScreen].bounds];
    scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scroll.directionalLockEnabled = YES;
    self.view = scroll;
}
- (void)setupUI
{
    // nav
    self.title = @"登录";
    self.navigationItem.leftBarButtonItem =
        [UIBarButtonItem backBarItem:^(id sender) {
            if (_cancelBlk) {
                _cancelBlk();
            }
            [self setEditing:NO];
            [self.navigationController dismissViewControllerAnimated:YES
                                                          completion:nil];
        }];
    self.view.height = SCREEN_HEIGHT - self.navigationController.navigationBar.height -20;
    //logo
    UIImageView* biyaoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 22, 144, 90)];
    [self.view addSubview:biyaoImageView];
    biyaoImageView.image = [UIImage imageNamed:@"icon_login_logo"];
    biyaoImageView.centerX = SCREEN_WIDTH / 2;

    //input background
    UIImageView* inputBackground = [[UIImageView alloc] initWithFrame:CGRectMake(38, 22 + 90, SCREEN_WIDTH - 38 * 2, 81)];
    [self.view addSubview:inputBackground];
    inputBackground.centerX = SCREEN_WIDTH / 2;
    UIImage* backgroundImage = [UIImage imageNamed:@"bg_inputbox_default.9"];
    inputBackground.image = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 24 - 5, 24 - 5)];
    UIImageView* inputline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, inputBackground.width - 16, 1)];
    inputline.image = [UIImage imageNamed:@"line_login_bbb.9"];
    [inputBackground addSubview:inputline];
    inputline.centerX = inputBackground.size.width / 2;
    inputline.centerY = inputBackground.size.height / 2;

    //box
    _userBox = [[UIImageView alloc] initWithFrame:CGRectMake(38, 22 + 90, SCREEN_WIDTH - 38 * 2, 41)];
    _userBox.centerX = SCREEN_WIDTH / 2;
    [self.view addSubview:_userBox];
    _userBox.hidden = YES;
    _userBox.image = [[UIImage imageNamed:@"bg_inputbox_login_above.9"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 24 - 5, 24 - 5)];
    _pwdBox = [[UIImageView alloc] initWithFrame:CGRectMake(38, 22 + 90 + 40, SCREEN_WIDTH - 38 * 2, 41)];
    _pwdBox.centerX = SCREEN_WIDTH / 2;
    [self.view addSubview:_pwdBox];
    _pwdBox.hidden = YES;
    _pwdBox.image = [[UIImage imageNamed:@"bg_inputbox_login_below.9"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 24 - 5, 24 - 5)];

    UIImageView* showline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 29)];
    [self.view addSubview:showline];
    showline.image = [UIImage imageNamed:@"line_login_bbb.9"];
    showline.centerX = inputBackground.right - 40;
    showline.centerY = inputBackground.bottom - 20;

    // user&pwd
    _userTextField = [[UITextField alloc] initWithFrame:CGRectMake(inputBackground.left, inputBackground.top, SCREEN_WIDTH - 38 * 2 - 7, 40)];
    _userTextField.leftViewMode = UITextFieldViewModeAlways;
    _userTextField.placeholder = @"请输入账号/手机号";
    UIImageView* accountImgView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_username_default"]];
    accountImgView.contentMode = UIViewContentModeCenter;
    accountImgView.frame = CGRectMake(12, 12, 40, 16);
    _userTextField.leftView = accountImgView;
    _userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userTextField.delegate = self;
    [self.view addSubview:_userTextField];

    
    _pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(inputBackground.left, inputBackground.bottom - 40, SCREEN_WIDTH - 38 * 2 - 40 - 7, 40)];
    _pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    _pwdTextField.placeholder = @"请输入6-32位密码";
    UIImageView* passwordImgView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password_default"]];
    passwordImgView.contentMode = UIViewContentModeCenter;
    passwordImgView.frame = CGRectMake(12, 12, 40, 16);
    [self.view addSubview:_pwdTextField];
    [_pwdTextField setSecureTextEntry:YES];
    _pwdTextField.leftView = passwordImgView;
    _pwdTextField.delegate = self;
    _pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    _hidePassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_hidePassword];
    _hidePassword.frame = CGRectMake(0, 0, 16, 16);
    _hidePassword.right = inputBackground.right - 12;
    _hidePassword.centerY = _pwdTextField.centerY;
    [_hidePassword addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventTouchUpInside];
    [_hidePassword setBackgroundImage:[UIImage imageNamed:@"icon_eye_password_hide"] forState:UIControlStateNormal];
    [_hidePassword setBackgroundImage:[UIImage imageNamed:@"icon_eye_password_show"] forState:UIControlStateSelected];

    //login
    _loginButton = [BYAutosizeBgButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(inputBackground.left, inputBackground.bottom + 24, inputBackground.size.width, 40);
    [_loginButton addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setBackgroundImage:[[UIImage imageNamed:@"bg_btn_main_default.9"]resizableImage] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[[UIImage imageNamed:@"bg_btn_main_default.9"]resizableImage] forState:UIControlStateDisabled];
    [_loginButton setBackgroundImage:[[UIImage imageNamed:@"bg_btn_main_press.9"]resizableImage] forState:UIControlStateHighlighted];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [_loginButton setTitleColor:HEXCOLOR(0xd9b9cd) forState:UIControlStateDisabled];
    [self.view addSubview:_loginButton];
    _loginButton.enabled = NO;

    //regist
    _registButton = [BYAutosizeBgButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_registButton];
    _registButton.frame = CGRectMake(inputBackground.left, _loginButton.bottom + 12, inputBackground.size.width, 40);
    _registButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_registButton addTarget:self action:@selector(onRegist) forControlEvents:UIControlEventTouchUpInside];
    [_registButton setBackgroundImage:[[UIImage imageNamed:@"bg_btn_minor_default.9"] resizableImage] forState:UIControlStateNormal];
    [_registButton setBackgroundImage:[[UIImage imageNamed:@"bg_btn_minor_press.9"] resizableImage] forState:UIControlStateHighlighted];
    [_registButton setTitle:@"还没有账号？快速注册" forState:UIControlStateNormal];
    [_registButton setTitleColor:HEXCOLOR(0xb768a5) forState:UIControlStateNormal];

    //forgetpassword
    _forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_forgetPasswordButton];
    _forgetPasswordButton.frame = CGRectMake(0, 0, (SCREEN_WIDTH / 3), 24);
    _forgetPasswordButton.top = _registButton.bottom + 12;
    _forgetPasswordButton.right = _registButton.right;
    _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_forgetPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [_forgetPasswordButton setTitleColor:HEXCOLOR(0x523366) forState:UIControlStateNormal];
    CGSize strSize = [@"忘记密码？" sizeWithFont:_forgetPasswordButton.titleLabel.font maxSize:_forgetPasswordButton.frame.size];
    _forgetPasswordButton.titleEdgeInsets = UIEdgeInsetsMake(0, _forgetPasswordButton.size.width - strSize.width, 0, 0);
    _forgetPasswordButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_forgetPasswordButton addTarget:self action:@selector(onForgotPassword) forControlEvents:UIControlEventTouchUpInside];

    // captchaView
    _captchaView = [BYCaptchaView captchaView];
    _captchaView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    _captchaView.top = self.pwdTextField.bottom;
    [self.view addSubview:_captchaView];
    _captchaView.hidden = YES;
    
    
    //thirdparty login
    BOOL showQQ = [_loginService canUseQQlogin];
    BOOL showWX = [_loginService canUseWXlogin];
//    showWX = false;
//    showQQ = false;
    if (showQQ | showWX) {
        UIView * thirdLine = [[UIView alloc]initWithFrame:CGRectMake(38+10, 0, SCREEN_WIDTH - 38*2 -20, 1)];
        thirdLine.backgroundColor = HEXCOLOR(0x666666);
        [self.view addSubview:thirdLine];
        
        UILabel * thirdPartyLoginlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 80)];
        thirdPartyLoginlabel.text = @"使用第三方登录";
        thirdPartyLoginlabel.font = [UIFont systemFontOfSize:12];
        [thirdPartyLoginlabel sizeToFit];
        thirdPartyLoginlabel.bottom = self.view.height - 20 - 36 - 16;
        thirdPartyLoginlabel.width = thirdPartyLoginlabel.width + 14;
        thirdPartyLoginlabel.centerX = SCREEN_WIDTH/2;
        thirdPartyLoginlabel.backgroundColor = self.view.backgroundColor;
        thirdPartyLoginlabel.textColor = HEXCOLOR(0x666666);
        
        thirdPartyLoginlabel.textAlignment = NSTextAlignmentCenter;
        thirdLine.centerY = thirdPartyLoginlabel.centerY;
        [self.view addSubview:thirdPartyLoginlabel];
        BYAutosizeBgButton * WXbutton;
        BYAutosizeBgButton * QQbutton;
        if (showWX) {
            WXbutton = [BYAutosizeBgButton buttonWithType:UIButtonTypeCustom];
            [WXbutton setBackgroundImage:[[UIImage imageNamed:@"icon_btn_login_wechat_default"] resizableImage] forState:UIControlStateNormal];
            [WXbutton setBackgroundImage:[[UIImage imageNamed:@"icon_btn_login_wechat_highlight"] resizableImage] forState:UIControlStateHighlighted];
            WXbutton.frame = CGRectMake(38, thirdPartyLoginlabel.bottom + 16, (SCREEN_WIDTH - 38 - 38 - 14)/2 , 36);
            [WXbutton setTitle:@"微信登录" forState:UIControlStateNormal];
            [WXbutton setImage:[UIImage imageNamed:@"icon_logo_wechat"] forState:UIControlStateNormal];
            [WXbutton setImage:[UIImage imageNamed:@"icon_logo_wechat"] forState:UIControlStateHighlighted];
            WXbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
            WXbutton.titleLabel.font = [UIFont systemFontOfSize:14];
            [WXbutton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
            [self.view addSubview:WXbutton];
            [WXbutton addTarget:self action:@selector(WXlogin) forControlEvents:UIControlEventTouchUpInside];
        }
        if (showQQ) {
            QQbutton = [BYAutosizeBgButton buttonWithType:UIButtonTypeCustom];
            [QQbutton setBackgroundImage:[[UIImage imageNamed:@"icon_btn_login_qq_default"] resizableImage] forState:UIControlStateNormal];
            [QQbutton setBackgroundImage:[[UIImage imageNamed:@"icon_btn_login_qq_highlight"] resizableImage] forState:UIControlStateHighlighted];
            QQbutton.frame = CGRectMake(38, thirdPartyLoginlabel.bottom + 16, (SCREEN_WIDTH - 38 - 38 - 14)/2 , 36);
            QQbutton.right = SCREEN_WIDTH - 38;
            [QQbutton setTitle:@"QQ登录" forState:UIControlStateNormal];
            [QQbutton setImage:[UIImage imageNamed:@"icon_logo_qq"] forState:UIControlStateNormal];
            [QQbutton setImage:[UIImage imageNamed:@"icon_logo_qq"] forState:UIControlStateHighlighted];
            QQbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 0);
            QQbutton.titleLabel.font = [UIFont systemFontOfSize:14];
            [QQbutton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
            [self.view addSubview:QQbutton];
            [QQbutton addTarget:self action:@selector(QQlogin) forControlEvents:UIControlEventTouchUpInside];
        }
        if (!showWX) {
            WXbutton.hidden = YES;
            QQbutton.width = SCREEN_WIDTH - 38 - 38;
            QQbutton.centerX = SCREEN_WIDTH/2;
        }
        if (!showQQ) {
            QQbutton.hidden = YES;
            WXbutton.width = SCREEN_WIDTH - 38 - 38;
            WXbutton.centerX = SCREEN_WIDTH/2;
        }
    }
    
   
    
    
}
- (void)updateUI
{
    if (_countForLoginTimes >= 3) {
        if (self.captchaView.hidden) {
            runOnMainQueue(^{
                CGFloat height = self.captchaView.size.height;
                [UIView animateWithDuration:0.3
                    animations:^{
                        _loginButton.top += height;
                        _registButton.top += height;
                        _forgetPasswordButton.top += height;
                    }
                    completion:^(BOOL finished) {
                        self.captchaView.hidden = NO;
                        [self.captchaView refreshCaptchaImage];
                    }];
            });
        }
        else {
            [self.captchaView refreshCaptchaImage];
        }
    }
    else {
        _captchaView.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _pwdTextField.text = @"";
    if (_captchaView.hidden == NO) {
        [_captchaView refreshCaptchaImage];
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

//    if (self.userTextField.text.length < 6) {
//        [MBProgressHUD topShowTmpMessage:@"账号格式有误，请重新输入"];
//        return;
//    }

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
    

    [MBProgressHUD topShow:@"登录中..."];

    [self.loginService
        loginByUser:self.userTextField.text
                pwd:self.pwdTextField.text
             finish:^(BYUser* user, BYError* error) {
                 [MBProgressHUD topHide];
                 if (user && !error) {
//                     NSLog(@"%@",user);
                     [MBProgressHUD showSuccess:@"登录成功!"];
                     [self.navigationController
                         dismissViewControllerAnimated:YES
                                            completion:^{
                                                if (_successBlk) {
                                                    _successBlk();
                                                }
                                            }];
                 }
                 else if (user && error && error.code == 208103) { //用户未注册
                     __weak BYLoginVC* bself = self;
                     [UIAlertView
                         bk_showAlertViewWithTitle:
                             nil message:@"您输入的手机号未注册，是否直接去注册？"
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles:[NSArray
                                                       arrayWithObject:@"确定"]
                                           handler:^(UIAlertView* alertView,
                                                       NSInteger buttonIndex) {
                                               if (buttonIndex == 1) {
                                                   if ([self.userTextField.text isMobilePhoneNumber]) {
                                                       [bself onRegist];
                                                   }
                                               }else{
                                                   if (!_captchaView.hidden) {
                                                       [_captchaView refreshCaptchaImage];
                                                   }
                                               }
                                               
                                           }];
                 }
                 else {
                     alertError(error);
                     self.countForLoginTimes++;
                     [self updateUI];
                 }
             }];
}

- (void)onRegist
{
    BYRegist1VC* registVc = [[BYRegist1VC alloc] init];
    [self.navigationController pushViewController:registVc animated:YES];
    if ([self.userTextField.text isMobilePhoneNumber]) {
        registVc.phone = self.userTextField.text;
    }
}

- (void)onForgotPassword
{
    BYForgetPasswordVC* phoneNumVc = [[BYForgetPasswordVC alloc] init];
    [self.navigationController pushViewController:phoneNumVc animated:YES];
}
- (void)refreshClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.pwdTextField setSecureTextEntry:NO];
    }
    else {
        [self.pwdTextField setSecureTextEntry:YES];
    }
    [self.view endEditing:YES];
    //[self.pwdTextField becomeFirstResponder];
    //self.pwdTextField.text = self.pwdTextField.text;
}
#pragma mark - 第三方登录
- (void)WXlogin
{
    [self.loginService WXlogin];
}

- (void)QQlogin
{
    [self.loginService QQlogin];
}
#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField*)textField
//{
//    NSLog(@"return");
//    if (textField == self.userTextField) {
//        if (textField.text.length <= 6) {
//            [MBProgressHUD topShowTmpMessage:@"账号格式有误，请重新输入"];
//            [self.userTextField becomeFirstResponder];
//            return NO;
//        }
//        else {
//            [self.pwdTextField becomeFirstResponder];
//        }
//    }
//    else {
//        if (textField.text.length >= 6) {
//            [self onLogin];
//        }
//        else {
//            [MBProgressHUD topShowTmpMessage:@"密码长度有误"];
//            return NO;
//        }
//    }
//    return YES;
//}
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField == self.userTextField) {
        UIImageView* leftview = (UIImageView*)_userTextField.leftView;
        leftview.image = [UIImage imageNamed:@"icon_username_selected"];
        _userBox.hidden = NO;
    }
    else if (textField == self.pwdTextField) {
        UIImageView* leftview = (UIImageView*)_pwdTextField.leftView;
        leftview.image = [UIImage imageNamed:@"icon_password_selected"];
        _pwdBox.hidden = NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if (textField == self.userTextField) {
        UIImageView* userleftview = (UIImageView*)_userTextField.leftView;
        userleftview.image = [UIImage imageNamed:@"icon_username_default"];
        _userBox.hidden = YES;
    }
    else if (textField == self.pwdTextField) {
        UIImageView* pwdleftview = (UIImageView*)_pwdTextField.leftView;
        pwdleftview.image = [UIImage imageNamed:@"icon_password_default"];
        _pwdBox.hidden = YES;
    }
}
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSMutableString* changedStr = [NSMutableString stringWithString:textField.text];
    [changedStr replaceCharactersInRange:range withString:string];
    NSUInteger length = changedStr.length;
    if (length > 32) {
        return NO;
    }
    if (length < 1) {
        _loginButton.enabled = NO;
        
    }
    else if (length >= 1) {
        if ((textField == _userTextField && _pwdTextField.text.length >= 1) | (textField == _pwdTextField && _userTextField.text.length >= 1)) {
            _loginButton.enabled = YES;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _loginButton.enabled = NO;
    return YES;
}
@end

BYNavVC* makeLoginnav(BYLoginSuccessBlock blk,BYLoginCancelBlock cblk)
{
    BYLoginVC* vc = [BYLoginVC sharedLoginVC];
    vc.successBlk = blk;
    vc.cancelBlk = cblk;
    BYNavVC* nav = [BYNavVC nav:vc title:@"登录"];

    return nav;
}
