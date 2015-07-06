//
//  BYEnterPhoneNumViewController.m
//  IBY
//
//  Created by coco on 14-9-11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYForgetPasswordVC.h"
#import "BYVerifySmsCodeVC.h"
#import "BYAutosizeBgButton.h"

#import "BYPasswordSettingVC.h"
#import "BYReSetPasswordVC.h"

#import "BYCaptchaView.h"

#import "BYForgetPasswordService.h"

#import "BYRegist1VC.h"

@interface BYForgetPasswordVC ()

@property (weak, nonatomic) IBOutlet UITextField* phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIImageView* txtLeftView;
@property (weak, nonatomic) IBOutlet UIImageView* inputBg;

@property (nonatomic, strong) BYForgetPasswordService* regitService;
@property (strong, nonatomic) BYCaptchaView* captchaView;
@property (weak, nonatomic) IBOutlet BYAutosizeBgButton* btnNext;

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
    [self.phoneNumTextField setBk_didBeginEditingBlock:^(UITextField* txtField) {
        self.txtLeftView.highlighted = YES;
        self.inputBg.highlighted = YES;
    }];
    
    [self.phoneNumTextField setBk_didEndEditingBlock:^(UITextField* txtField) {
        self.txtLeftView.highlighted = NO;
        self.inputBg.highlighted = NO;
    }];
    self.phoneNumTextField.delegate = self;
    [self.phoneNumTextField setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField* txtField, NSRange range, NSString* str) {
        NSString* realStr = [txtField.text stringByReplacingCharactersInRange:range withString:str];
        self.btnNext.enabled = realStr&&[realStr length]>0;
        return YES;
    }];
    self.btnNext.enabled = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_captchaView refreshCaptchaImage];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.phoneNumTextField becomeFirstResponder];
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
        [MBProgressHUD showError:@"请输入11位手机号码"];
        [self.phoneNumTextField becomeFirstResponder];
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
                    [UIAlertView bk_showAlertViewWithTitle:nil message:@"您输入的手机号未注册，是否直接去注册？" cancelButtonTitle:@"取消" otherButtonTitles:[NSArray arrayWithObject:@"确定"] handler:^(UIAlertView* alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1){
                            BYRegist1VC* registVc = [[BYRegist1VC alloc] init];
                            
                            [bself.navigationController pushViewController:registVc animated:YES];
                            registVc.phoneNumTextField.text = self.phoneNumTextField.text;
                        }
                    }];
                    return;
                }else if (error){
                    alertError(error);
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
