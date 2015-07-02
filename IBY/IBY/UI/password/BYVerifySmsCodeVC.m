//
//  BYEVerifycodeodeViewController.m
//  IBY
//
//  Created by coco on 14-9-11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYVerifySmsCodeVC.h"
#import "BYPasswordSettingVC.h"
#import "BYForgetPasswordService.h"
#import "BYAutosizeBgButton.h"

@interface BYVerifySmsCodeVC ()
@property (strong, nonatomic) BYForgetPasswordService* forgetpasswordService;

@property (weak, nonatomic) IBOutlet UILabel* phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField* smsCodeTextField;
@property (weak, nonatomic) IBOutlet BYAutosizeBgButton* resendBtn;
@property (weak, nonatomic) IBOutlet UIImageView* bgInput;
@property (weak, nonatomic) IBOutlet UIImageView* iconInputLeftView;
@property (nonatomic, assign) int countdownTime;
@property (nonatomic, strong) NSTimer* smsCountTimer;

@end

@implementation BYVerifySmsCodeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _titleFromLastPage ? _titleFromLastPage : @"输入验证码";

    _forgetpasswordService = [[BYForgetPasswordService alloc] init];
    _forgetpasswordService.phone = _phone;

    self.phoneNumLabel.text = [_forgetpasswordService.phone chineseMobileFormat];
    self.smsCodeTextField.delegate = self;
    [self.smsCodeTextField setBk_didBeginEditingBlock:^(UITextField* txtField) {
        self.iconInputLeftView.highlighted = YES;
        self.bgInput.highlighted = YES;
    }];
    
    [self.smsCodeTextField setBk_didEndEditingBlock:^(UITextField* txtField) {
        self.iconInputLeftView.highlighted = NO;
        self.bgInput.highlighted = NO;
    }];

    self.autoHideKeyboard = YES;
    
    [self beginTimer];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.smsCodeTextField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (_smsCountTimer) {
        [_smsCountTimer invalidate];
        _smsCountTimer = nil;
    }
}

- (void)beginTimer
{
    _countdownTime = 60;
    self.resendBtn.enabled = NO;

    _smsCountTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(onTimerUpdate)
                                                    userInfo:nil
                                                     repeats:YES];
    [_smsCountTimer fire];
}

- (void)stopTimer
{
    [_smsCountTimer invalidate];
    _smsCountTimer = nil;
    _resendBtn.enabled = YES;
    [self.resendBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
    _countdownTime = 60;
}

- (void)onTimerUpdate
{
    if (_countdownTime < 1) {
        [self stopTimer];
    }
    else {
        _countdownTime--;

        self.resendBtn.enabled = NO;
        NSString* txt = [NSString stringWithFormat:@"%d秒后重发", _countdownTime];
        [self.resendBtn setTitle:txt forState:UIControlStateDisabled];
    }
}

- (IBAction)nextStepOnclick
{
    [self.view endEditing:YES];

    [self.forgetpasswordService checkVerifyCode:self.smsCodeTextField.text phone:self.phoneNumLabel.text finish:^(BOOL success, BYError* error) {
        if(error){
            alertError(error);
            [self.smsCodeTextField becomeFirstResponder];
        }else{
            BYPasswordSettingVC *setPwdVC = [[BYPasswordSettingVC alloc] init];
            setPwdVC.passwordService = self.forgetpasswordService;
            [self.navigationController pushViewController:setPwdVC animated:YES];
        }
    }];
}

- (IBAction)sendCodeAgainClick:(id)sender
{
    [self fetchSMSCode];
}

- (void)fetchSMSCode
{//重发机制不处理其他status
    [self.forgetpasswordService fetchSMSVerifyCodeForResetPasswordWithPhone:self.phone finish:^(BYFetchVerifyCodeStatus status, BYError* error) {
        if (status == BYFetchCodeFail) {
            alertError(error);
            return;
        }else if (status == BYFetchCodeSuccess){
            [self beginTimer];
            return;
        }
        [MBProgressHUD topShowTmpMessage:@"发送失败，请稍后再试"];
    }];
}

@end
