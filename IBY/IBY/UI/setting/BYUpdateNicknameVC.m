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
    
    BYMineCell* cell = [BYMineCell cellWithTitle:@"昵称" icon:nil target:self sel:nil];
    cell.frame = BYRectMake(0, 12, SCREEN_WIDTH, 44);
    cell.titleLabel.textColor = BYColor666;
    cell.showBottomLine = YES;
    cell.showRightArrow = NO;
    nicknameTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 0, cell.width - 75, cell.height)];
    nicknameTF.delegate = self;
    [cell addSubview:nicknameTF];
    nicknameTF.textColor = BYColor333;
    nicknameTF.font = [UIFont systemFontOfSize:14];
    nicknameTF.text = [BYAppCenter sharedAppCenter].user.nickname;
    nicknameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
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
    
    
    [cell addTarget:self action:@selector(Onfocus) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:cell];
    __weak BYUpdateNicknameVC * wself = self;
    [nicknameTF setBk_shouldClearBlock:^BOOL(UITextField* txtField){
        wself.btnNext.enabled = NO;
        return YES;
    }];
    [nicknameTF setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField* txtField, NSRange range, NSString* str) {
        NSString* realStr = [txtField.text stringByReplacingCharactersInRange:range withString:str];
        if (realStr.length > 20) {
            return NO;
        }
        wself.btnNext.enabled = realStr&&[realStr length]>0;
        return YES;
    }];
    

}

- (void)Onfocus
{
    [nicknameTF resignFirstResponder];
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
