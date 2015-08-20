//
//  BYAvatarSettingVC.m
//  IBY
//
//  Created by kangjian on 15/7/29.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYAvatarSettingVC.h"
#define AVATARSIZE 150
@interface BYAvatarSettingVC ()
@property (nonatomic, strong) UIScrollView * backScroll;
@property (nonatomic, strong) UIImageView * backImg;
@property (nonatomic, strong) UIScrollView * frontScroll;
@end

@implementation BYAvatarSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
- (void)setupUI
{
    self.title = @"个人头像";
//    _frontScroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
//    [self.view addSubview:_frontScroll];
//    _frontScroll.delegate = self;
    _backScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height*.7)];
    _backScroll.delegate = self;
    [self.view addSubview:_backScroll];
    UIImage * image = [UIImage imageNamed:@"tutorial02"];
    _backImg = [[UIImageView alloc]initWithImage:image];
    float imagesize = image.size.width < image.size.height ? image.size.width : image.size.height;
    _backScroll.maximumZoomScale = 3;
    _backScroll.minimumZoomScale = AVATARSIZE / imagesize;
    _backScroll.alwaysBounceVertical = YES;
    _backScroll.alwaysBounceHorizontal = YES;
    _backScroll.showsHorizontalScrollIndicator = NO;
    _backScroll.showsVerticalScrollIndicator = NO;
    
//    _frontScroll.maximumZoomScale = 3;
//    _frontScroll.minimumZoomScale = AVATARSIZE / imagesize;
//    _frontScroll.alwaysBounceVertical = YES;
//    _frontScroll.alwaysBounceHorizontal = YES;
//    _frontScroll.showsHorizontalScrollIndicator = NO;
//    _frontScroll.showsVerticalScrollIndicator = NO;
    
    [_backScroll addSubview:_backImg];
    UIView* rim = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    rim.userInteractionEnabled = YES;
    rim.multipleTouchEnabled = YES;
    rim.size = CGSizeMake(AVATARSIZE, AVATARSIZE);
    rim.center = _backScroll.center;
    [self.view addSubview:rim];
//    _backScroll.frame =rim.frame;
//    rim = _backScroll;
    rim.backgroundColor = [UIColor clearColor];
    rim.layer.shadowColor = [[UIColor blackColor] CGColor];
    rim.layer.shadowOpacity = 1.0;
    rim.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    rim.layer.cornerRadius = 5;
    rim.layer.masksToBounds = YES;
    rim.layer.borderWidth = 1;
    rim.layer.borderColor = [HEXCOLOR(0x1aabde) CGColor];
    _backImg.backgroundColor = [UIColor whiteColor];
    _backScroll.backgroundColor = [UIColor blackColor];
//    _backScroll.clipsToBounds = NO;
    
    _backImg.centerX = _backScroll.width / 2;
    _backImg.centerY = _backScroll.height / 2;
    
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return _backImg;
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
//    _backImg.center = _backScroll.center;
//    _backImg.centerX = _backScroll.centerX + (_backImg.width - AVATARSIZE) / 2;
//    _backImg.centerY = _backScroll.centerY + (_backImg.height - AVATARSIZE) / 2;
    
//    scrollView.contentSize = CGSizeMake(scrollView.width + _backImg.width - AVATARSIZE, scrollView.height + _backImg.height - AVATARSIZE);
    
//    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x - (_backImg.width - AVATARSIZE) / 2, scrollView.contentOffset.y - (_backImg.height - AVATARSIZE) / 2);
    
//    NSLog(@"%@",NSStringFromCGSize(scrollView.contentSize));
//    
//    NSLog(@"%@",NSStringFromCGRect(_backImg.frame));
    
    if ([scrollView isEqual:_frontScroll]) {
        
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    _backImg.center = _backScroll.center;
//    if ([scrollView isEqual:_frontScroll]) {
//        _backScroll.zoomScale = _frontScroll.zoomScale;
//    }
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
