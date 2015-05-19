//
//  BYFeedbackVC.m
//  IBY
//
//  Created by panshiyu on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYFeedbackVC.h"
#import "BYFeedbackService.h"
@interface BYFeedbackVC () <UITextViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate> {
    __weak IBOutlet UITextField* phoneTxtfield;
    __weak IBOutlet UITextView* contentTxtView;
    __weak IBOutlet UILabel* contentHoldLabel;

    BYFeedbackService* _feedBackService;
}
@end

@implementation BYFeedbackVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"问题反馈";
    _feedBackService = [[BYFeedbackService alloc] init];

    contentTxtView.textAlignment = NSTextAlignmentLeft;
    contentTxtView.delegate = self;
    phoneTxtfield.delegate = self;

    self.autoHideKeyboard = YES;
}

#pragma mark -

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if (range.location == 0 && textView.editable == NO) {
        contentHoldLabel.text = @"用的不爽，说两句";
    }
    else {
        contentHoldLabel.text = @"";
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView*)textView
{
    if (textView.editable == YES) {
        contentHoldLabel.text = @"";
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView*)textView
{
    if (![textView.text isEqualToString:@""]) {
        contentHoldLabel.text = @"";
    }
    else {
        contentHoldLabel.text = @"用的不爽，说两句";
    }
    return YES;
}

- (IBAction)commitAction:(UIButton*)sender
{
    [self.view endEditing:YES];

    if (contentTxtView.text.length < 1) {
        [MBProgressHUD topShowTmpMessage:@"请输入反馈信息"];
        return;
    }
    
//    if(![phoneTxtfield.text isMobilePhoneNumber]){
//        [MBProgressHUD topShowTmpMessage:@"请输入正确的电话号码"];
//        return;
//    }

    [_feedBackService uploadFeedbackByContent:contentTxtView.text mobile:phoneTxtfield.text finish:^(BOOL success, BYError* error) {
        if (success) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"提交失败"];
        }
    }];
}



@end
