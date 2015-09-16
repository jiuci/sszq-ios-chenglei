//
//  BYThemeVC.m
//  IBY
//
//  Created by forbertl on 15/9/11.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYThemeVC.h"
#import "BYThemeService.h"
#import "BYThemeInfo.h"
#import "BYImageView.h"
#import "BYPoolNetworkView.h"
#import "MJRefresh.h"

@interface BYThemeVC ()<UIScrollViewDelegate>
@property (nonatomic, strong)BYThemeService * service;
@property (nonatomic, strong)UIScrollView * scroll;
@property (nonatomic, strong)UIButton * gototop;
@end

@implementation BYThemeVC

+ (instancetype)sharedTheme
{
    static BYThemeVC* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)sharedThemeWithId:(int)categoryID
{
    BYThemeVC* instance = [BYThemeVC sharedTheme];
    instance.categoryID = categoryID;
    [instance refresh];
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self refresh];
    // Do any additional setup after loading the view.
}

- (void)setupUI
{
    _service = [[BYThemeService alloc]init];
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 44 -20)];
    [self.view addSubview:_scroll];
    _scroll.delegate = self;
    _scroll.backgroundColor = [UIColor whiteColor];
    
    _gototop = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_gototop];
    [_gototop addTarget:self action:@selector(onGototop) forControlEvents:UIControlEventTouchUpInside];
    _gototop.frame = CGRectMake(SCREEN_WIDTH - 12 - 44, SCREEN_HEIGHT - 46 - 20 - 28 - 44, 44, 44);
//    _gototop.backgroundColor = [UIColor blackColor];
    [_gototop setBackgroundImage:[UIImage imageNamed:@"icon_theme_gototop"] forState:UIControlStateNormal];
    _gototop.hidden = YES;
    _gototop.alpha = 0;
}

- (void)updateUI
{
    float offset = 0;
    self.title = _info.title;
    for (UIView * view in _scroll.subviews) {
        [view removeFromSuperview];
    }
    BYHomeInfoSimple * simple = _info.headerInfo;
    BYImageView * header = [[BYImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH/ (float)simple.width*simple.height)];
    
    header.jumpURL = simple.link;
    header.image = [UIImage imageNamed:@"bg_placeholder"];
    [header setImageWithUrl:simple.imagePath placeholderName:@"bg_placeholder"];
    [header addTapAction:@selector(onImagetap:) target:header];
    
    [_scroll addSubview:header];
    offset += header.height ;
    //floor
    for (int i = 0; i < _info.floors.count; i++) {
        BYThemeFloorSimple * floor = _info.floors[i];
        
        if (floor.mainTitle) {
            UILabel * mainTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
            mainTitleLabel.text = floor.mainTitle;
            mainTitleLabel.font = Font(16);
            mainTitleLabel.textColor = BYColor333;
            mainTitleLabel.textAlignment = NSTextAlignmentCenter;
            mainTitleLabel.top = offset + 12;
            mainTitleLabel.backgroundColor = [UIColor clearColor];
            [_scroll addSubview:mainTitleLabel];
            offset += 12 + mainTitleLabel.height + 10;
        }
        
        if (floor.subTitle) {
            UILabel * subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 14)];
            subTitleLabel.text = floor.subTitle;
            subTitleLabel.font = Font(14);
            subTitleLabel.textColor = BYColor666;
            subTitleLabel.textAlignment = NSTextAlignmentCenter;
            subTitleLabel.top = offset;
            subTitleLabel.backgroundColor = [UIColor clearColor];
            [_scroll addSubview:subTitleLabel];
            offset += 12 + subTitleLabel.height;
        }
        
        if (floor.width && floor.height) {
            BYImageView * imageTitle = [[BYImageView alloc]initWithFrame:CGRectMake(0, offset, SCREEN_WIDTH ,SCREEN_WIDTH / (float)floor.width*floor.height)];
            offset += imageTitle.height;
            [imageTitle setImageWithUrl:floor.imageTitle placeholderName:@"bg_placeholder"];
            [_scroll addSubview:imageTitle];
        }
        
        offset += .5;
        
        for (int j = 0; j < floor.simples.count; j++) {
            BYHomeInfoSimple * simple = floor.simples[j];
            BYImageView * header = [[BYImageView alloc]initWithFrame:CGRectMake(j%2*SCREEN_WIDTH/2,j/2 * SCREEN_WIDTH / 2 / (float)simple.width*simple.height + offset, SCREEN_WIDTH / 2 ,SCREEN_WIDTH / 2 / (float)simple.width*simple.height)];
            
            header.jumpURL = simple.link;
            header.image = [UIImage imageNamed:@"bg_placeholder"];
            [header setImageWithUrl:simple.imagePath placeholderName:@"bg_placeholder"];
            [header addTapAction:@selector(onImagetap:) target:header];
            offset += j%2 * header.height;
            [_scroll addSubview:header];
            
            if (j%2) {
                UIView * centerLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - .5, header.top, 1, header.height)];
                [_scroll addSubview:centerLine];
                centerLine.backgroundColor = BYColor999;
                
                UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0 , header.bottom - .5, SCREEN_WIDTH, 1)];
                [_scroll addSubview:bottomLine];
                bottomLine.backgroundColor = BYColor999;
                
                UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0 , header.top - .5, SCREEN_WIDTH, 1)];
                [_scroll addSubview:topLine];
                topLine.backgroundColor = BYColor999;
            }
//            if (j == 1) {
//                UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0 , header.top - .5, SCREEN_WIDTH, 1)];
//                [_scroll addSubview:topLine];
//                topLine.backgroundColor = BYColor999;
//            }
//            if ((j == floor.simples.count - 1)&& j%2 == 0) {
//                offset += header.height;
//            }
        }
//        offset += 12;
    }
    
    //product
    for (int i = 0 ; i < _info.products.count; i++) {
        offset += 12;
        BYHomeInfoSimple * simple = _info.products[i];
        BYImageView * header = [[BYImageView alloc]initWithFrame:CGRectMake(0 ,offset, SCREEN_WIDTH ,SCREEN_WIDTH / (float)simple.width*simple.height)];
        
        header.jumpURL = simple.link;
        header.image = [UIImage imageNamed:@"bg_placeholder"];
        [header setImageWithUrl:simple.imagePath placeholderName:@"bg_placeholder"];
        [header addTapAction:@selector(onImagetap:) target:header];
        offset += header.height;
        [_scroll addSubview:header];

    }
    _scroll.contentSize = CGSizeMake(SCREEN_WIDTH, offset);
}

- (void)refresh
{
    __weak BYThemeVC* wself = self;
    [_service loadThemePage:_categoryID type:0 finish:^(BYThemeInfo*info,BYError *error){
        if (error) {
            if (!self.info) {
                [self showPoolnetworkView];
//                [self.tipsView addTapAction:@selector(refresh) target:self];
                UIButton * tapRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
                tapRefresh.frame = CGRectMake(0, 0, self.tipsView.width, self.tipsView.height);
                [self.tipsView addSubview:tapRefresh];
                [tapRefresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
            }
            alertError(error);
            return;
        }
        [self hideTipsView];
        wself.info = info;
        [wself updateUI];
        
    }];
}

- (void)onGototop
{
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float location = scrollView.contentOffset.y;
//    NSLog(@"%f",location / scrollView.height);
    if (location > scrollView.height * 1 && _gototop.hidden == YES) {
        _gototop.hidden = NO;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _gototop.alpha = 1;
        } completion:^(BOOL finished){
            
        }];
    }else if(location < scrollView.height * 1 && _gototop.hidden == NO){
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _gototop.alpha = 0;
        } completion:^(BOOL finished){
            _gototop.hidden = YES;
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"setgobackuri");
    addCookies(self.url, @"gobackuri", @".biyao.com");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
