//
//  BYGlassPageVC.m
//  IBY
//
//  Created by St on 15/4/1.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYGlassPageVC.h"
#import "BYFaceDataUnit.h"
#import "BYCaptureVC.h"
#import "BYGlassSinglePageView.h"

#import "BYGlassService.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#define FRAMEWIDTH 240

#define FRAMERATE  (468.0/640)

#define NUMBER_OF_MIN 2

@interface BYGlassPageVC () <UIScrollViewDelegate>

@property (nonatomic , strong)BYGlassService *glassService;
@end

@implementation BYGlassPageVC{
    UIScrollView* _contentView;
    UIPageControl* _pageControl;
    NSArray* _dataArray;
    
    float _rate;
    float _rateForPic;
    float _suitWidth;
    float _suitHeight;
    float _suitWidthForPic;
    float _suitHeightForPic;
    
    float _orginContentPointX;
}

-(BYGlassService*)glassService{
    if (!_glassService) {
        _glassService =[[BYGlassService alloc]init];
    }
    return _glassService;
}

- (void)viewWillAppear:(BOOL)animated{
    if([self.glassService nativeFacelist].count == 0){
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    
    [self updateData];
    [self updateUI];
}


- (id)initWithArray:(NSArray *)dataArray{
    self = [super init];
    if ((self)) {
        _dataArray = dataArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择一张照片试戴";
    
    
    
    _suitWidthForPic = (SCREEN_WIDTH * FRAMERATE);
    _suitHeightForPic = (SCREEN_HEIGHT * FRAMERATE);
    
    _suitHeight = _suitHeightForPic + 15;
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT / 20), _suitWidthForPic + 6 + 18 , _suitHeight)];
    _contentView.centerX = SCREEN_WIDTH / 2.0;
    _contentView.pagingEnabled = YES;
    _contentView.clipsToBounds = NO;
    _contentView.delegate = self;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.showsVerticalScrollIndicator = NO;
    self.view.clipsToBounds = YES;
    
    _orginContentPointX = _contentView.size.width;
    
    [self.view addSubview:_contentView];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:BYRectMake(0, 0, 300, 30)];
    _pageControl.bottom = _contentView.bottom + (SCREEN_HEIGHT - 20 - 44 - _contentView.bottom) /2;
    _pageControl.centerX = SCREEN_WIDTH / 2;
    _pageControl.currentPageIndicatorTintColor = HEXCOLOR(0x523669);
    _pageControl.pageIndicatorTintColor = HEXCOLOR(0xb0a4b9);
    
    [self.view addSubview:_pageControl];
    
    
    
}

- (void)createNewFace{
    if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusRestricted
            || authorizationStatus == AVAuthorizationStatusDenied) {
            
            // 没有权限
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"请在“设置-隐私-相机”选项中，允许必要访问您的相机。"
                                                               delegate:nil
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }

    BYCaptureVC* capVC = [[BYCaptureVC alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:capVC];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

- (void)updateUI{
    
    _orginContentPointX = _contentView.contentOffset.x;//保留位标
    
    [_contentView removeAllSubviews];
    
    [_pageControl setNumberOfPages:[_dataArray count] + 1];
    
    _contentView.contentSize = CGSizeMake((_suitWidthForPic + 6 + 18) * (_dataArray.count + 1), _suitHeight );
    
    for(int i = 0 ; i < _dataArray.count  ; i++){
        BYFaceDataUnit* data = _dataArray[i];
        BYGlassSinglePageView* singlePage = [[BYGlassSinglePageView alloc] initWithData:data frame:CGRectMake(12 , 0, _suitWidthForPic + 6, _suitHeightForPic + 6) byGlassPage:self];
        [singlePage setupUI];
        singlePage.left = (i+1) * (_suitWidthForPic + 6 + 18) + 9;
        [_contentView addSubview:singlePage];
        
        singlePage.number = i+1;
        singlePage.deleteBlk = ^(int number){
            
            [self updateData];
            [self updateUI];
        };

    }
    
    [self buildCreateNewFaceWithLeft:.0];
    _contentView.contentSize = CGSizeMake((_suitWidthForPic + 6 + 18) * (_dataArray.count + 1), _suitHeight );
    
    _contentView.contentOffset = CGPointMake(_orginContentPointX, 0);//恢复位标
    [self scrollViewDidScroll:_contentView];//恢复当前选择的删除标记
    
    if (_dataArray.count == 0) {
        [self createNewFace];
    }
}
- (void)buildCreateNewFaceWithLeft:(float)left
{

    BYGlassSinglePageView* singlePage = [[BYGlassSinglePageView alloc]
                                         initWithFrame:CGRectMake(left , 0, _suitWidthForPic + 6, _suitHeightForPic + 6)
                                         byGlassPage:self];
    [singlePage setupUI];
    [_contentView addSubview:singlePage];

}

- (void)updateData{
    _dataArray = [self.glassService nativeFacelist];

}

#pragma mark ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat pageWidth = _suitWidthForPic + 6 + 18;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    for (BYGlassSinglePageView * pageView in _contentView.subviews) {
        if (![pageView isKindOfClass:[BYGlassSinglePageView class]]) {
            continue;
        }
        
        if (pageView.number == _pageControl.currentPage) {
            pageView.isCurrentPage = YES;
        }else{
            pageView.isCurrentPage = NO;
        }
    }
}


@end
