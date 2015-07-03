//
//  BYRegistViewController.m
//  IBY
//
//  Created by panShiyu on 14-9-9.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYRegist1VC.h"
#import "BYAutosizeBgButton.h"

#import "BYRegistService.h"

#import "BYBaseWebVC.h"
#import "BYRegist2VC.h"
#import "BYRegist3VC.h"

#import "BYLoginVC.h"

@interface BYRegist1VC () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIImageView* txtLeftView;
@property (weak, nonatomic) IBOutlet UIImageView* inputBg;
@property (weak, nonatomic) IBOutlet BYAutosizeBgButton* btnNext;

@property (nonatomic, strong) BYRegistService* registService;

@end

@implementation BYRegist1VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"快速注册";

    _registService = [[BYRegistService alloc] init];

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
        self.btnNext.enabled = [realStr isMobilePhoneNumber];
        return YES;
    }];

    self.btnNext.enabled = NO;
    self.autoHideKeyboard = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.phoneNumTextField becomeFirstResponder];
}
#pragma mark -

- (IBAction)onProtocol:(id)sender
{
    BYBaseWebVC* webVC = [[BYBaseWebVC alloc] initWithURL:[NSURL URLWithString:BYURL_SERVICE_PROTOCOL]];
    webVC.useWebTitle = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)onNextStep:(id)sender
{
    [self.view endEditing:YES];

    if (![self.phoneNumTextField.text isMobilePhoneNumber]) {
        [MBProgressHUD showError:@"手机号格式有误，请重新输入"];
        [self.phoneNumTextField becomeFirstResponder];
        return;
    }

    [self.registService fetchSMSVerifyCodeWithPhone:self.phoneNumTextField.text
                                             finish:^(BYFetchVerifyCodeStatus status, BYError* error) {
                                                 if (status == BYFetchCodeFail) {
                                                     alertError(error);
                                                     return;
                                                 }
                                                 else if (status == BYFetchCodeFail && !error) {
                                                     [MBProgressHUD topShowTmpMessage:@"发送失败，请稍后再试"];
                                                     return;
                                                 }
                                                 else if (status == BYFetchCodeRegisted) {
                                                     [self showAlertWhenHasRegisted];
                                                     return;
                                                 }
                                                 BYRegist2VC* aimVC = [[BYRegist2VC alloc] init];
                                                 self.registService.phone = self.phoneNumTextField.text;
                                                 aimVC.registService = self.registService;
                                                 aimVC.phone = self.phoneNumTextField.text;
                                                 [self.navigationController pushViewController:aimVC animated:YES];
                                             }];
}

- (void)showAlertWhenHasRegisted
{
    //已注册跳转登陆
    __weak BYRegist1VC* bself = self;
    [UIAlertView bk_showAlertViewWithTitle:nil
                                   message:@"您的手机号已经被注册，是否去登录？"
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:[NSArray arrayWithObject:@"去登录"]
                                   handler:^(UIAlertView* alertView, NSInteger buttonIndex) {
                                       if (buttonIndex == 1) {
                                           for (UIViewController* controller in bself.navigationController.viewControllers) {
                                               if ([controller.class isSubclassOfClass:[BYLoginVC class]]) {
                                                   [self.navigationController popToViewController:controller animated:YES];
                                                   BYLoginVC* loginVC = (BYLoginVC*)controller;
                                                   loginVC.userTextField.text = self.phoneNumTextField.text;
                                               }
                                           }
                                           //找不到登陆页没有处理
                                       }
                                   }];
}

@end
