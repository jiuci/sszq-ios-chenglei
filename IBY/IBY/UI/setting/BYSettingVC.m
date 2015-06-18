//
//  BYSettingVC.m
//  IBY
//
//  Created by St on 14-10-29.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYSettingVC.h"
#import "BYFeedbackVC.h"
#import "BYAboutVC.h"

#import "BYAppService.h"

#import "BYLinearScrollView.h"

#import "BYBaseCell.h"

#import "BYTestVC1.h"

#import <TMCache.h>

@interface BYSettingVC()
//for test
@property (nonatomic,strong)NSMutableString *testCmdList;
@property (nonatomic,strong)NSDate *tapTime;
@property (nonatomic,strong)UIButton *testBtnA;
@property (nonatomic,strong)UIButton *testBtnB;
@end

@interface BYSettingVC () {
    BYAppService* _appService;
    BYBaseCell* _logoutCell;

    BYTitleCell* _cacheCell;
    
}
@property (nonatomic, strong) BYLinearScrollView* bodyView;
@property (nonatomic, strong) UIButton* logoutButton;
@end

@implementation BYSettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";

    _appService = [[BYAppService alloc] init];
    [self setupUI];
    [self setupTestUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[BYAppCenter sharedAppCenter] updateUidAndToken];
    _logoutCell.hidden = ![BYAppCenter sharedAppCenter].isLogin;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _testBtnA.bottom = self.view.height;
    _testBtnB.bottom = self.view.height;
}

- (void)setupUI
{
    _bodyView = makeLinearScrollView(self);
    _bodyView.autoAdjustContentSize = NO;
    _bodyView.minContentSizeHeight = SCREEN_HEIGHT;
    [self.view addSubview:_bodyView];


//    _cacheCell = [self appendCell:@""
//                            title:@"清理缓存"
//                              top:0
//                              des:[NSString stringWithFormat:@"%.1fM", (float)[TMCache sharedCache].diskByteCount / (1024 * 1024)]
//                              sel:@selector(onRemoveCache)];

    [self appendCell:@""
               title:@"问题反馈"
                 top:12
                 des:@""
                 sel:@selector(onFeedback)];

    [self appendCell:@""
               title:@"关于我们"
                 top:0
                 des:@""
                 sel:@selector(onAbout)];

    _logoutCell = [[BYBaseCell alloc] initWithFrame:BYRectMake(12, 0, SCREEN_WIDTH - 24, 44)];
    _logoutCell.normalBg = [[UIImage imageNamed:@"btn_red"] resizableImage];
    _logoutCell.highlightBg = [[UIImage imageNamed:@"btn_red_on"] resizableImage];
    [_logoutCell bk_addEventHandler:^(id sender) {
        [[BYAppCenter sharedAppCenter] logout];
        [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome];
    } forControlEvents:UIControlEventTouchUpInside];

    UILabel* label = [UILabel labelWithFrame:BYRectMake(0, 0, _logoutCell.width, 44) font:Font(16) andTextColor:BYColorWhite];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"退出登录";
    [_logoutCell addSubview:label];

    [self.bodyView by_addSubview:_logoutCell paddingTop:32 paddingBottom:30];
}

- (BYTitleCell*)appendCell:(NSString*)icon title:(NSString*)title top:(CGFloat)top des:(NSString*)des sel:(SEL)selecor
{
    BYTitleCell* cell = [BYTitleCell controlWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, 44) key:title value:des];
    //    BYTitleCell* cell = [BYTitleCell controlWithKey:title value:des];
    //    cell.frame = BYRectMake(0, 0, SCREEN_WIDTH, 44);
    cell.showBottomLine = YES;
    cell.showRightArrow = YES;
    [cell addTarget:self action:selecor forControlEvents:UIControlEventTouchUpInside];
    [self.bodyView by_addSubview:cell paddingTop:top];
    return cell;
}

#pragma mark -


- (void)onRemoveCache
{
    [[TMCache sharedCache] removeAllObjects:^(TMCache* cache) {
        runOnMainQueue(^{
            _cacheCell.valueLabel.text = [NSString stringWithFormat:@"%.1fM", (float)[TMCache sharedCache].diskByteCount / (1024 * 1024)];
            [MBProgressHUD topShowTmpMessage:@"缓存清理完成"];
        });
    }];
}


- (void)onVersion
{
    [_appService checkAppNeedUpdate:^(BYVersionInfo* versionInfo, BYError* error) {
        if (error) {
            if (error.code == BYNetErrorNotExist) {
                [MBProgressHUD topShowTmpMessage:@"已经是最新版本了！"];
            }else{
                [MBProgressHUD topShowTmpMessage:BYMSG_POOR_NETWORK];
            }
            
            return ;
        }
        
        if (versionInfo && versionInfo.hasNewVersion) {
            NSString *title = [NSString stringWithFormat:@"新版本v%@",versionInfo.name];
            UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:title message:versionInfo.info];
            
            [alert bk_addButtonWithTitle:@"去更新" handler:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionInfo.url]];
            }];
            [alert bk_addButtonWithTitle:@"取消" handler:^{
            }];
            
            [alert show];
        }else{
            [MBProgressHUD topShowTmpMessage:@"已经是最新版本了！"];
        }
    }];
}

- (void)onFeedback
{
    BYFeedbackVC* feedBackVC = [[BYFeedbackVC alloc] init];
    [self.navigationController pushViewController:feedBackVC animated:YES];
}

- (void)onAbout
{
    BYAboutVC* aboutUsVC = [[BYAboutVC alloc] init];
    [self.navigationController pushViewController:aboutUsVC animated:YES];
}

- (void)lognOut:(id)sender
{
    [[BYAppCenter sharedAppCenter] logout];
    [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome];
}

#pragma mark -

- (void)setupTestUI {
    _testCmdList = [NSMutableString string];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH/2, 70)];
    btn1.backgroundColor = BYColorClear;
    btn1.bottom = self.view.bottom;
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(onCmdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH/2, 70)];
    btn2.backgroundColor = BYColorClear;
    btn2.bottom = self.view.bottom;
    btn2.tag = 2;
    btn2.right = self.view.width;
    [btn2 addTarget:self action:@selector(onCmdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    _testBtnA = btn1;
    _testBtnB = btn2;
    
}

- (void)onCmdBtnClick:(UIButton*)sender{
    if (!self.tapTime) {
        //首次，需要给初始值
        self.tapTime = [NSDate date];
        [_testCmdList setString:@""];
    }
    
    if ([self.tapTime timeIntervalSinceNow] < -5) {
        //太久了，需要重置combo
        self.tapTime = [NSDate date];
        [_testCmdList setString:@""];
    }
    
    NSString *c = (sender.tag == 1) ? @"a" : @"b";
    [_testCmdList appendString:c];
    
    [self onDetector];
}

- (void)onDetector{
    BYLog(@"-------%@",_testCmdList);
    if ([_testCmdList isEqualToString:@"abaaba"]) {
        [self toTestpage:@"BYTestVC1"];
    }
}

@end
