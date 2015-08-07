//
//  BYUserProfileVC.m
//  IBY
//
//  Created by kangjian on 15/8/5.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYUserProfileVC.h"
#import "BYMineCell.h"
#import "BYImageView.h"
#import "BYUserService.h"
#import "BYUpdateNicknameVC.h"
//#import "BYGenderSelectView.h"
@interface BYUserProfileVC ()
{
    UILabel * nickname;
    UILabel * gender;
}
@property (nonatomic, strong)BYGenderSelectView * genderSelecter;
@end

@implementation BYUserProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI
{
    nickname.text = [BYAppCenter sharedAppCenter].user.nickname;
    switch ([BYAppCenter sharedAppCenter].user.gender) {
        case 0:
            gender.text = @"男";
            break;
        case -1:
            gender.text = @"保密";
            break;
        case 1:
            gender.text = @"女";
            break;
            
        default:
            break;
    }
    
}

- (void)setupUI
{
    BYMineCell* avatarCell = [BYMineCell cellWithTitle:@"头像" icon:nil target:self sel:nil];
    avatarCell.height = 68;
    avatarCell.top = 12;
    avatarCell.showRightArrow = NO;
    avatarCell.titleLabel.textColor = BYColor666;
    avatarCell.titleLabel.centerY = 68 / 2;
    
    BYImageView * avatar = [[BYImageView alloc]initWithFrame:CGRectMake(0, 0, 51, 51)];
    [avatarCell addSubview:avatar];
    [avatar setImageWithUrl:[BYAppCenter sharedAppCenter].user.avatar placeholderName:@"icon_user_default"];
    [avatar.layer setCornerRadius:avatar.width / 2];
    CALayer* imageLayer = avatar.layer;
    [imageLayer setMasksToBounds:YES];

    avatar.centerY = 68 / 2;
    avatar.right = avatarCell.width - 12;
    avatar.layer.cornerRadius = avatar.width / 2;
    avatar.layer.masksToBounds = YES;
    avatar.layer.borderWidth = 1;
    avatar.layer.borderColor = [HEXCOLOR(0xeeeeee) CGColor];
    avatar.backgroundColor = [UIColor redColor];
    [self.view addSubview:avatarCell];
    
    BYMineCell* nicknameCell = [BYMineCell cellWithTitle:@"昵称" icon:nil target:self sel:@selector(onNickname)];
    nicknameCell.top = 12 + 68;
    nicknameCell.showRightArrow = YES;
    nickname = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * .8, 44)];
    nickname.textAlignment = NSTextAlignmentRight;
    nickname.font = [UIFont systemFontOfSize:14];
    nickname.textColor = BYColor333;
    nickname.text = [BYAppCenter sharedAppCenter].user.nickname;
    [nicknameCell addSubview:nickname];
    nickname.right = nicknameCell.width - 12 - 16 - 8;
    [self.view addSubview:nicknameCell];
    
    BYMineCell* genderCell = [BYMineCell cellWithTitle:@"性别" icon:nil target:self sel:@selector(onGender)];
    genderCell.top = 12 + 68 + 44;
    genderCell.showRightArrow = YES;
    gender = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * .8, 44)];
    gender.textAlignment = NSTextAlignmentRight;
    gender.font = [UIFont systemFontOfSize:14];
    gender.textColor = BYColor333;
    switch ([BYAppCenter sharedAppCenter].user.gender) {
        case 0:
            gender.text = @"男";
            break;
        case -1:
            gender.text = @"保密";
            break;
        case 1:
            gender.text = @"女";
            break;
            
        default:
            break;
    }
    [genderCell addSubview:gender];
    gender.right = genderCell.width - 12 - 16 - 8;
    [self.view addSubview:genderCell];
    
    _genderSelecter = [BYGenderSelectView createPopoverView];
    self.genderSelecter.delegate = self;
}


- (void)onNickname
{
    BYUpdateNicknameVC * updateNickname = [[BYUpdateNicknameVC alloc]init];
    [self.navigationController pushViewController:updateNickname animated:YES];
}

- (void)onGender
{
    [_genderSelecter showInView:self.view];
}

- (void)didSelect:(UIButton *)sender
{
    [MBProgressHUD topShow:@"修改中..."];
    BYUserService * userService = [[BYUserService alloc]init];
    [userService updateGender:sender.titleLabel.text finish:^(BOOL success,BYError * error){
        if (success) {
            [MBProgressHUD topShowTmpMessage:@"性别修改成功"];
            gender.text = sender.titleLabel.text;
            [_genderSelecter hide];
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
