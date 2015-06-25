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

#import "BYCaptchaView.h"

#import "BYForgetPasswordService.h"

#import "BYRegist1VC.h"

@interface BYForgetPasswordVC ()

@property (weak, nonatomic) IBOutlet UITextField* phoneNumTextField;

@property (nonatomic, strong) BYForgetPasswordService* regitService;
@property (strong, nonatomic) BYCaptchaView* captchaView;

@end

@implementation BYForgetPasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"找回密码";

    _captchaView = [BYCaptchaView captchaView];
    _captchaView.top = self.phoneNumTextField.bottom;
    [self.view addSubview:_captchaView];

    
    _regitService = [[BYForgetPasswordService alloc] init];

    self.autoHideKeyboard = YES;
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.phoneNumTextField becomeFirstResponder];
    [_captchaView refreshCaptchaImage];
}
#pragma mark -

/**检查流程
 1，手机格式
 2，验证码是否正确
 3，发送短信验证码request
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
            [self.regitService fetchSMSVerifyCodeForResetPasswordWithPhone:self.phoneNumTextField.text finish:^(BYFetchVerifyCodeStatus status, BYError* error) {
                if (status == BYFetchCodeFail) {
                    alertError(error);
                    return;
                }else if (status == BYFetchCodeNeedRegist){
                    //未注册跳转注册
                    __weak BYForgetPasswordVC * bself = self;
                    [UIAlertView bk_showAlertViewWithTitle:nil message:@"您的手机号没有注册，是否去注册？" cancelButtonTitle:@"取消" otherButtonTitles:[NSArray arrayWithObject:@"去注册"] handler:^(UIAlertView* alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1){
                            BYRegist1VC* registVc = [[BYRegist1VC alloc] init];
                            [bself.navigationController pushViewController:registVc animated:YES];
                        }
                    }];
                    return;
                }else if (error){
                    [MBProgressHUD topShowTmpMessage:@"发送失败，请稍后再试"];
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
