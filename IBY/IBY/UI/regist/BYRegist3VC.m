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

@interface BYRegist3VC ()
@property (weak, nonatomic) IBOutlet UITextField* firstPwdTextField;
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

    NSString* user = _registService.phone;
    NSString* pwd = self.firstPwdTextField.text;
    NSString* smsCode = self.registService.verifyCode;
    [self.registService registByUser:user pwd:pwd verycode:smsCode finsh:^(BOOL success, BYError* error) {
        if(error){
            [MBProgressHUD topShowTmpMessage:error.byErrorMsg];
        }else{
            [MBProgressHUD topShow:@"恭喜您账户注册成功"];
            runBlockAfterDelay(1, ^{
                [MBProgressHUD topHide];
                [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome];
//                for (UIViewController * controller in self.navigationController.viewControllers) {
//                    if ([controller.class isSubclassOfClass:[BYLoginVC class]]) {
//                        [self.navigationController popToViewController:controller animated:YES];
//                        return;
//                    }
//                }
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
