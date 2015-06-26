//
//  BYEPasswordViewController.m
//  IBY
//
//  Created by coco on 14-9-11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYPasswordSettingVC.h"
#import "BYLoginService.h"
#import "BYLoginVC.h"

@interface BYPasswordSettingVC ()

@property (weak, nonatomic) IBOutlet UITextField* firstPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField* secondPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton* actionButton;
@end

@implementation BYPasswordSettingVC {
    BOOL _showPassword;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置新密码";
    _showPassword = YES;
    self.actionButton.enabled = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.firstPwdTextField becomeFirstResponder];
    
}
- (IBAction)commitOnclick
{
    [self.view endEditing:YES];

    if (![self.firstPwdTextField.text isValidPassword]) {
        [MBProgressHUD topShowTmpMessage:@"密码格式有误"];
        [self.firstPwdTextField becomeFirstResponder];
        return;
    }
    if (![self.firstPwdTextField.text isEqualToString:self.secondPwdTextField.text]) {
        [MBProgressHUD topShowTmpMessage:@"两次输入不一致"];
        [self.firstPwdTextField becomeFirstResponder];
        return;
    }
    NSString* user = _passwordService.phone;
    NSString* pwd = self.firstPwdTextField.text;
    [self.passwordService resetPassword:pwd finish:^(BOOL success, BYError* error) {
            if(error){
                alertError(error);
            }else{
                [MBProgressHUD topShow:@"恭喜您密码修改成功"];
                runBlockAfterDelay(1, ^{
                    [MBProgressHUD topHide];
                    for (UIViewController * controller in self.navigationController.viewControllers) {
                        if ([controller.class isSubclassOfClass:[BYLoginVC class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                            return;
                        }
                    }
                    runOnMainQueue(^{
                        [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome];
                    });
                    
                    
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
    _showPassword = !_showPassword;
    if (_showPassword) {
        [sender setTitle:@"隐藏密码" forState:UIControlStateNormal];
        [self.firstPwdTextField setSecureTextEntry:NO];
        [self.secondPwdTextField setSecureTextEntry:NO];
    }
    else {
        [sender setTitle:@"显示密码" forState:UIControlStateNormal];
        [self.firstPwdTextField setSecureTextEntry:YES];
        [self.secondPwdTextField setSecureTextEntry:YES];
    }
    //
//    [self.firstPwdTextField becomeFirstResponder];
    self.firstPwdTextField.text = self.firstPwdTextField.text;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger length = range.length+range.location;
    if (length>32) {
        return NO;
    }
    if (length<6) {
        self.actionButton.enabled = NO;
    }else if (self.firstPwdTextField.text.length>5&&self.secondPwdTextField.text.length>5){
        self.actionButton.enabled = YES;
    }
    return YES;
}
@end
