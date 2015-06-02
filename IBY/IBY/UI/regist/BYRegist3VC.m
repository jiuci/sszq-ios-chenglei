//
//  BYRegist3VC.m
//  IBY
//
//  Created by panshiyu on 15/1/4.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYRegist3VC.h"
#import "BYRegistService.h"
#import "BYUserService.h"

@interface BYRegist3VC ()
@property (weak, nonatomic) IBOutlet UITextField* firstPwdTextField;
@property (nonatomic, strong) BYRegistService* registService;
@end

@implementation BYRegist3VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置密码";

    _registService = [[BYRegistService alloc] init];

    [self.firstPwdTextField becomeFirstResponder];
}

- (IBAction)commitOnclick
{
    [self.view endEditing:YES];

    if (![self.firstPwdTextField.text isValidPassword]) {
        [MBProgressHUD topShowTmpMessage:@"密码格式有误"];
        return;
    }

    NSString* user = _passwordService.phone;
    NSString* pwd = self.firstPwdTextField.text;
    NSString* smsCode = _passwordService.smsVerifyCode;

    [self.registService registByUser:user pwd:pwd verycode:smsCode finsh:^(NSDictionary* data, BYError* error) {
        if(error){
            [MBProgressHUD topShowTmpMessage:@"注册失败，休息几分钟，再试一次"];
        }else{
            [MBProgressHUD topShow:@"恭喜您账户注册成功"];
            runBlockAfterDelay(3, ^{
                [MBProgressHUD topHide];
                [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome];
                
                runOnBackgroundQueue(^{
                    BYUserService *loginService = [[BYUserService alloc] init];
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
        [sender setTitle:@"隐藏密码" forState:UIControlStateNormal];
        [self.firstPwdTextField setSecureTextEntry:NO];
    }
    else {
        [sender setTitle:@"显示密码" forState:UIControlStateNormal];
        [self.firstPwdTextField setSecureTextEntry:YES];
    }

    [self.firstPwdTextField becomeFirstResponder];
    self.firstPwdTextField.text = self.firstPwdTextField.text;
}

@end
