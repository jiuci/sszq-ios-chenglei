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
#import "BYAutosizeBgButton.h"

@interface BYRegist3VC ()
@property (weak, nonatomic) IBOutlet UITextField* firstPwdTextField;
@property (weak, nonatomic) IBOutlet UIImageView* bgInput;
@property (weak, nonatomic) IBOutlet UIImageView* iconInputLeftView;
@property (weak, nonatomic) IBOutlet BYAutosizeBgButton* btnNext;
@end

@implementation BYRegist3VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置密码";

    //_registService = [[BYRegistService alloc] init];
    [self.firstPwdTextField setBk_didBeginEditingBlock:^(UITextField* txtField) {
        self.iconInputLeftView.highlighted = YES;
        self.bgInput.highlighted = YES;
    }];
    
    [self.firstPwdTextField setBk_didEndEditingBlock:^(UITextField* txtField) {
        self.iconInputLeftView.highlighted = NO;
        self.bgInput.highlighted = NO;
    }];
    [self.firstPwdTextField setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField* txtField, NSRange range, NSString* str) {
        NSString* realStr = [txtField.text stringByReplacingCharactersInRange:range withString:str];
        self.btnNext.enabled = realStr&&[realStr length]>0;
        return YES;
    }];
    self.btnNext.enabled = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.firstPwdTextField becomeFirstResponder];
}
- (IBAction)commitOnclick
{
    [self.view endEditing:YES];
    if (self.firstPwdTextField.text.length<6) {
        [MBProgressHUD topShowTmpMessage:@"密码不能小于6位字符，请重新输入"];
        [self.firstPwdTextField becomeFirstResponder];
        return;
    }
    if (![self.firstPwdTextField.text isValidPassword]) {
        [MBProgressHUD topShowTmpMessage:@"密码需为字母，数字，符号两种以上组合，请重新输入"];
        [self.firstPwdTextField becomeFirstResponder];
        return;
    }

    NSString* user = _registService.phone;
    NSString* pwd = self.firstPwdTextField.text;
//    NSString* smsCode = self.registService.verifyCode;
    [self.registService registByUser:user pwd:pwd finsh:^(BOOL success, BYError* error) {
        if(error){
            alertError(error);
        }else{
            [MBProgressHUD topShow:@"恭喜，注册成功"];
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
        [self.firstPwdTextField setSecureTextEntry:NO];
    }
    else {
        [self.firstPwdTextField setSecureTextEntry:YES];
    }

    [self.firstPwdTextField becomeFirstResponder];
    self.firstPwdTextField.text = self.firstPwdTextField.text;
}

@end
