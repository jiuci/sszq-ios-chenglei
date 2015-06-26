//
//  BYRegistViewController.m
//  IBY
//
//  Created by panShiyu on 14-9-9.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYRegist1VC.h"

#import "BYRegistService.h"

#import "BYBaseWebVC.h"
#import "BYRegist2VC.h"
#import "BYRegist3VC.h"

#import "BYLoginVC.h"

@interface BYRegist1VC ()

@property (weak, nonatomic) IBOutlet UITextField* phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIImageView* protocolCheckbox;

@property (nonatomic, strong) BYRegistService* registService;

@property (nonatomic, assign) BOOL isProtocolSelected;

@end

@implementation BYRegist1VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"账户注册";

    _registService = [[BYRegistService alloc] init];

    self.isProtocolSelected = YES;
    self.protocolCheckbox.highlighted = self.isProtocolSelected;

    self.autoHideKeyboard = YES;

    
    
    

    //TODO: todo psy 还没有验证码
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.phoneNumTextField becomeFirstResponder];
}
#pragma mark -

- (IBAction)onTapCheckbox:(id)sender
{
    _isProtocolSelected = !_isProtocolSelected;
    self.protocolCheckbox.highlighted = _isProtocolSelected;
}

- (IBAction)onProtocol:(id)sender
{
    BYBaseWebVC* webVC = [[BYBaseWebVC alloc] initWithURL:[NSURL URLWithString:BYURL_SERVICE_PROTOCOL]];
    webVC.navigationItem.title = @"必要服务协议";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)onNextStep:(id)sender
{
    [self.view endEditing:YES];

    if (!_isProtocolSelected) {
        [MBProgressHUD topShowTmpMessage:@"请同意必要服务协议"];
        return;
    }

    if (![self.phoneNumTextField.text isMobilePhoneNumber]) {
        [MBProgressHUD showError:@"手机号格式有误，请重新输入"];
        [self.phoneNumTextField becomeFirstResponder];
        return;
    }

    [self.registService fetchSMSVerifyCodeWithPhone:self.phoneNumTextField.text finish:^(BYFetchVerifyCodeStatus status, BYError* error) {
        if (status == BYFetchCodeFail) {
            alertError(error);
            return;
        }else if (status == BYFetchCodeFail &&!error){
            [MBProgressHUD topShowTmpMessage:@"发送失败，请稍后再试"];
            return;
        }else if (status == BYFetchCodeRegisted){
            //已注册跳转登陆
            __weak BYRegist1VC * bself = self;
            [UIAlertView bk_showAlertViewWithTitle:nil message:@"您的手机号已经被注册，是否去登录？" cancelButtonTitle:@"取消" otherButtonTitles:[NSArray arrayWithObject:@"去登录"] handler:^(UIAlertView* alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1){
                    for (UIViewController * controller in bself.navigationController.viewControllers) {
                        if ([controller.class isSubclassOfClass:[BYLoginVC class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                            return;
                        }
                    }
                    //找不到登陆页没有处理
                }
            }];
            return;
        }
        BYRegist2VC *aimVC = [[BYRegist2VC alloc]init];
        self.registService.phone = self.phoneNumTextField.text;
        aimVC.registService = self.registService;
        aimVC.phone = self.phoneNumTextField.text;
        [self.navigationController pushViewController:aimVC animated:YES];
    }];
        //TODO: 正常这里，需要验证是否开启了验证码部分，并且是否输入验证，验证码是否正确

        //        [_captchaView valueCheckWithSuccessBlock:^{
        //
        //            runOnMainQueue(^{
        //                BYVerifySmsCodeVC *aimVC = [[BYVerifySmsCodeVC alloc]init];
        //                aimVC.phone = self.phoneNumTextField.text;
        //                aimVC.navigationItem.title = @"找回密码";
        //                [self.navigationController pushViewController:aimVC animated:YES];
        //            });
        //
        //        }];

}

@end
