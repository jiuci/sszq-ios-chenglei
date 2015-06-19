//
//  BYEnterPhoneNumViewController.m
//  IBY
//
//  Created by coco on 14-9-11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYForgetPasswordVC.h"
#import "BYVerifySmsCodeVC.h"

#import "BYPasswordSettingVC.h"
#import "BYReSetPasswordVC.h"

#import "BYRegistService.h"
#import "BYCaptchaView.h"

#import "BYForgetPasswordService.h"

@interface BYForgetPasswordVC ()

@property (weak, nonatomic) IBOutlet UITextField* phoneNumTextField;

@property (nonatomic, strong) BYRegistService* regitService;
@property (strong, nonatomic) BYCaptchaView* captchaView;

@end

@implementation BYForgetPasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"找回密码";

    _captchaView = [BYCaptchaView captchaView];
    _captchaView.top = self.phoneNumTextField.bottom;
    [_captchaView refreshCaptchaImage];
    [self.view addSubview:_captchaView];

    [self.phoneNumTextField becomeFirstResponder];
    _regitService = [[BYRegistService alloc] init];

    self.autoHideKeyboard = YES;
    
    
}

#pragma mark -

/**检查流程
 1，手机格式
 2，验证码是否正确
 3，手机是否已注册
 4，下一步
 */
- (IBAction)onNextStep
{
    [self.view endEditing:YES];
    if (![self.phoneNumTextField.text isMobilePhoneNumber]) {
        [MBProgressHUD showError:@"手机号格式错误"];
        return;
    }
    [_captchaView valueCheckWithSuccessBlock:^{
        
        runOnMainQueue(^{
            [self.regitService checkIfRegisted:self.phoneNumTextField.text finish:^(BOOL result, BYError* error) {
                if (error) {
                    [MBProgressHUD topShowTmpMessage:@"找回密码失败，休息几分钟，再试一次"];
                    return ;
                }
                
                if (!result) {
                    [MBProgressHUD topShowTmpMessage:@"手机号还未注册"];
                    return;
                }
                BYVerifySmsCodeVC *aimVC = [[BYVerifySmsCodeVC alloc]init];
                aimVC.phone = self.phoneNumTextField.text;
                [self.navigationController pushViewController:aimVC animated:YES];
            }];
        });
        
    }];
   
}

@end
