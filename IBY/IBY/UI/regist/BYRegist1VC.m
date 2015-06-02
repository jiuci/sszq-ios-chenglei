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

@interface BYRegist1VC ()

@property (weak, nonatomic) IBOutlet UITextField* phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIImageView* protocolCheckbox;

@property (nonatomic, strong) BYRegistService* service;

@property (nonatomic, assign) BOOL isProtocolSelected;

@end

@implementation BYRegist1VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"账户注册";

    _service = [[BYRegistService alloc] init];

    self.isProtocolSelected = YES;
    self.protocolCheckbox.highlighted = self.isProtocolSelected;

    self.autoHideKeyboard = YES;

    [self.phoneNumTextField becomeFirstResponder];
    
    

    //TODO: todo psy 还没有验证码
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
        return;
    }

    [self.service checkIfRegisted:self.phoneNumTextField.text finish:^(BOOL isRegisted, BYError* error) {
        if (error) {
            [MBProgressHUD topShowTmpMessage:@"注册，休息几分钟，再试一次"];
            return ;
        }
        
        if (isRegisted) {
            [UIAlertView bk_showAlertViewWithTitle:nil message:@"该手机号已注册，请直接登录" cancelButtonTitle:@"取消" otherButtonTitles:[NSArray arrayWithObjects:@"直接登录", nil] handler:^(UIAlertView* alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1){
                    [[BYPortalCenter sharedPortalCenter] portTo:BYPortalLoginFromMineVC];
                }
            }];
            return;
        }
        
        BYRegist2VC *aimVC = [[BYRegist2VC alloc]init];
        aimVC.phone = self.phoneNumTextField.text;
//        aimVC.navigationItem.title = @"找回密码";
        [self.navigationController pushViewController:aimVC animated:YES];

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

    }];
}

@end
