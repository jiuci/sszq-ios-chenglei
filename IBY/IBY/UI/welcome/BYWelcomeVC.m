//
//  BYWelcomeVC.m
//  IBY
//
//  Created by panshiyu on 15/2/27.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYWelcomeVC.h"

@interface BYWelcomeVC () <UIScrollViewDelegate>

@end

@implementation BYWelcomeVC {
    UIScrollView* _contentView;
    UIPageControl* _pageControl;

    NSArray* _frontImglist;
//    NSArray* _backImglist;
//    NSArray* _titlelist;
//    NSArray* _desclist;

    BOOL _hasDismiss;
    BOOL _needDismiss;
}

#pragma mark - View lifecycle

//- (id)initWithImages:(NSString*)imageName, ...
//{
//    self = [super initWithNibName:nil bundle:nil];
//    if (self) {
//        _imageArray = [[NSMutableArray alloc] init];
//
//        va_list argList;
//        if (imageName) {
//            [_imageArray addObject:imageName];
//            id arg;
//            va_start(argList, imageName);
//            while ((arg = va_arg(argList, id))) {
//                [_imageArray addObject:arg];
//            }
//            va_end(argList);
//        }
//    }
//
//    return self;
//}

- (void)viewDidLoad
{
    _frontImglist = @[ @"wel_1", @"wel_2", @"wel_3",@"wel_4" ];
    NSArray *upBgColors = @[HEXCOLOR(0xf9d350),HEXCOLOR(0xf85453),HEXCOLOR(0x43c8be),HEXCOLOR(0x8d7aa5)];
//    _backImglist = @[ @"welcome1_back", @"welcome2_back", @"welcome3_back" ];
//    _titlelist = @[ @"100%奢侈品质 1%价格", @"直连全球奢侈品制造商", @"我要的，才是必要的" ];
//    _desclist = @[ @"全球最高性价比", @"开启消费新时代", @"高度个性化" ];

    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_contentView setContentSize:CGSizeMake(SCREEN_WIDTH * ([_frontImglist count] + 1), SCREEN_HEIGHT)];
    [_contentView setPagingEnabled:YES];
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;

    _contentView.delegate = self;

    for (int i = 0; i < [_frontImglist count]; i++) {
//        UIImageView* bg = makeImgView(BYRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT), _backImglist[i]);
        UIImageView *bg = [[UIImageView alloc] initWithFrame:BYRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bg.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:bg];
        
        UIImageView *bgUp = [[UIImageView alloc] initWithFrame:BYRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, 0)];
        bgUp.backgroundColor = upBgColors[i];
        [_contentView addSubview:bgUp];
        

        CGFloat frontHeight = SCREEN_WIDTH * 1920 / 1080;
        CGFloat realWidth = frontHeight > SCREEN_HEIGHT ? SCREEN_HEIGHT *1080 /1920 : SCREEN_WIDTH;
        CGFloat realHeight = frontHeight > SCREEN_HEIGHT ? SCREEN_HEIGHT : frontHeight;
        UIImageView* front = makeImgView(BYRectMake(SCREEN_WIDTH * i, 0, realWidth, realHeight), _frontImglist[i]);
        front.centerY = SCREEN_HEIGHT / 2;
        front.centerX = SCREEN_WIDTH * i + SCREEN_WIDTH/2;
        [_contentView addSubview:front];
        
        bgUp.height = (SCREEN_HEIGHT - realHeight)/2 + realHeight * 1262 / 1920;

//        UILabel* titlelabel = [UILabel labelWithFrame:BYRectMake(SCREEN_WIDTH * i, SCREEN_HEIGHT - 126, SCREEN_WIDTH, 20) font:Font(18) andTextColor:HEXCOLOR(0x000000)];
//        titlelabel.textAlignment = NSTextAlignmentCenter;
//        titlelabel.text = _titlelist[i];
//        [_contentView addSubview:titlelabel];
//
//        UILabel* desclabel = [UILabel labelWithFrame:BYRectMake(SCREEN_WIDTH * i, SCREEN_HEIGHT - 104, SCREEN_WIDTH, 20) font:Font(13) andTextColor:HEXCOLOR(0x473368)];
//        desclabel.textAlignment = NSTextAlignmentCenter;
//        desclabel.text = _desclist[i];
//        [_contentView addSubview:desclabel];

        if (i == (_frontImglist.count - 1)) {
            CGRect r = CGRectMake(SCREEN_WIDTH * i, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 100);
            UIButton* button = [[UIButton alloc] initWithFrame:r];
            button.backgroundColor = [UIColor clearColor];
            [button bk_addEventHandler:^(id sender) {
                [self willDismissLater];
            } forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:button];
        }
    }
    _contentView.bounces = NO;
    [self.view addSubview:_contentView];

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(60, SCREEN_HEIGHT - 40, 200, 30)];
    _pageControl.centerX = SCREEN_WIDTH / 2;
    [_pageControl setNumberOfPages:[_frontImglist count]];
    //    [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    _pageControl.currentPageIndicatorTintColor = HEXCOLOR(0x9272af);
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.view addSubview:_pageControl];
}

#pragma mark - private method

- (void)willDismissLater
{
    if (_needDismiss) {
        return;
    }
    _needDismiss = YES;
    _contentView.userInteractionEnabled = NO;
    [_contentView setContentOffset:CGPointMake(SCREEN_WIDTH * [_frontImglist count], 0) animated:YES];
}

- (void)dismissUserGuide
{
    if (!_hasDismiss) {
        [self.view removeFromSuperview];
        _contentView.delegate = nil;
        if (_tutorialDone) {
            _tutorialDone();
        }
        _hasDismiss = YES;
    }
}

- (void)pageControlValueChanged:(id)sender
{
    NSInteger page = _pageControl.currentPage;

    CGRect frame = _contentView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_contentView scrollRectToVisible:frame animated:YES];
}

#pragma mark -
#pragma mark ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;

    if (!_needDismiss && scrollView.contentOffset.x > (SCREEN_WIDTH * ([_frontImglist count] - 1) + 5)) {
        scrollView.userInteractionEnabled = NO;
        _needDismiss = YES;
    }
}

//手滑动，结束的时候会触发这个方法
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    if (_needDismiss) {
        [self performSelector:@selector(dismissUserGuide) withObject:nil afterDelay:0.1];
    }
}

// setContentOffset 结束的时候会触发的方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView*)scrollView
{
    if (_needDismiss) {
        [self performSelector:@selector(dismissUserGuide) withObject:nil afterDelay:0.1];
    }
}

@end
