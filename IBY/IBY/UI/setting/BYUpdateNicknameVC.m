//
//  BYUpdateNicknameVC.m
//  IBY
//
//  Created by kangjian on 15/8/6.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYUpdateNicknameVC.h"
#import "BYMineCell.h"
#import "BYAutosizeBgButton.h"
#import "BYUserService.h"

@interface BYUpdateNicknameVC ()
{
    UITextField * nicknameTF;
}
@property (nonatomic, strong) BYAutosizeBgButton * btnNext;
@property (strong, nonatomic) UIImageView* inputBg;
@end

@implementation BYUpdateNicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
}
- (void)setupUI
{
    self.title = @"修改昵称";
    
    _inputBg  = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, SCREEN_WIDTH - 24, 40)];
    [self.view addSubview:_inputBg];
    _inputBg.image = [[UIImage imageNamed:@"bg_inputbox"] resizableImage];
    _inputBg.highlightedImage = [[UIImage imageNamed:@"bg_inputbox_on"] resizableImage];
    
    nicknameTF = [[UITextField alloc] initWithFrame:CGRectMake(26, 12, SCREEN_WIDTH - 12 * 2 - 7 - 14, 40)];
    nicknameTF.leftViewMode = UITextFieldViewModeAlways;
    nicknameTF.placeholder = @"请输入昵称";
    nicknameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    nicknameTF.delegate = self;
    nicknameTF.textColor = BYColor333;
    nicknameTF.font = [UIFont systemFontOfSize:14];
    nicknameTF.text = [BYAppCenter sharedAppCenter].user.nickname;
    [self.view addSubview:nicknameTF];
    __weak BYUpdateNicknameVC * wself = self;
    [nicknameTF setBk_didBeginEditingBlock:^(UITextField* txtField) {
        wself.inputBg.highlighted = YES;
    }];
    
    [nicknameTF setBk_didEndEditingBlock:^(UITextField* txtField) {
        wself.inputBg.highlighted = NO;
    }];
    [nicknameTF setBk_shouldClearBlock:^BOOL(UITextField* txtField){
        wself.btnNext.enabled = NO;
        return YES;
    }];
    [nicknameTF setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField* txtField, NSRange range, NSString* str) {
        NSString* realStr = [txtField.text stringByReplacingCharactersInRange:range withString:str];
        if (realStr.length > 20 && txtField.text.length < realStr.length) {
            return NO;
        }
        wself.btnNext.enabled = realStr&&[realStr length]>0;
        return YES;
    }];

    UILabel * tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 12 + 44 +12, SCREEN_WIDTH - 20 * 2, 30)];
    tipsLabel.text = @"最多20个字符，可由中英文、数字、\"_\"、\"-\"组成";
    tipsLabel.font = [UIFont systemFontOfSize:12];
    tipsLabel.textColor = BYColor666;
    tipsLabel.numberOfLines = 0;
    tipsLabel.autoresizesSubviews = YES;
    [self.view addSubview:tipsLabel];
    
    _btnNext = [[BYAutosizeBgButton alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 24, 40)];
    [_btnNext setBackgroundImage:[[UIImage imageNamed:@"btn_red"] resizableImage] forState:UIControlStateNormal];
    [_btnNext setBackgroundImage:[[UIImage imageNamed:@"btn_red"] resizableImage] forState:UIControlStateDisabled];
    [_btnNext setBackgroundImage:[[UIImage imageNamed:@"btn_red_on"] resizableImage] forState:UIControlStateHighlighted];
    _btnNext.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnNext setTitle:@"保存" forState:UIControlStateNormal];
    [_btnNext setTitleColor:BYColorWhite forState:UIControlStateNormal];
    [_btnNext setTitleColor:HEXCOLOR(0xD9B9CD) forState:UIControlStateDisabled];
    [_btnNext addTarget:self action:@selector(onSave) forControlEvents:UIControlEventTouchUpInside];
    _btnNext.top = tipsLabel.bottom + 28;
    [self.view addSubview:_btnNext];
    
    
   
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSave
{
    if ([nicknameTF.text hasPrefix:@" "]||[nicknameTF.text hasSuffix:@" "]) {
        [MBProgressHUD topShowTmpMessage:@"昵称格式有误，请重新输入"];
        [nicknameTF becomeFirstResponder];
        return;
    }
    
    [MBProgressHUD topShow:@"保存中..."];
    BYUserService * userService = [[BYUserService alloc]init];
    [userService updateNicknameByName:nicknameTF.text finish:^(BOOL success ,BYError* error){
        if (success) {
            [MBProgressHUD topShowTmpMessage:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            alertError(error);
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
