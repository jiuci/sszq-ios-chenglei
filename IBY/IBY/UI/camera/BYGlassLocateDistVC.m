//
//  BYGlassLocateDistVC.m
//  IBY
//
//  Created by St on 15/4/3.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYGlassLocateDistVC.h"
#import "BYFaceDataUnit.h"
#import "BYGlassTryVC.h"
#import "BYGlassService.h"
#import "BYGlassesAnimateView.h"
#import "BYGlassesMagnifier.h"

@interface BYGlassLocateDistVC ()

@property (nonatomic , strong) UIImage * image;
@property (nonatomic , strong) BYFaceDataUnit* faceData;

@property (nonatomic , strong) UIImageView * imageView;

@property (nonatomic , strong) UIView * leftEyeView;
@property (nonatomic , strong) UIView * rightEyeView;

@property (nonatomic , strong) BYGlassesMagnifier * magnifier;

@property (nonatomic , strong) BYGlassesAnimateView * guideView;


@end

@implementation BYGlassLocateDistVC


- (id)initWithData:(BYFaceDataUnit *)faceData backGroundImg:(UIImage*)backImg{
    self= [super init];
    if(self){
        _image = backImg;
        _faceData = faceData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self.guideView startAnimating];
    
}

- (void)setupUI{
    
    _imageView = [[UIImageView alloc]init];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _imageView.image = _image;
    _imageView.size = _image.size;
    _imageView.center = self.view.center;
    [self.view addSubview:_imageView];
    
    
    
    
    
    _leftEyeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 42*2, 42*2)];
    UIImageView * leye = [[UIImageView alloc]initWithFrame:CGRectMake(21, 21, 42, 42)];
    leye.image = [UIImage imageNamed:@"camera_locateEye"];
    [_leftEyeView addSubview:leye];
    _leftEyeView.center = _faceData.lEye;
    _leftEyeView.userInteractionEnabled = YES;
    UIPanGestureRecognizer* panGestureRecognizer1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleAction:)];
    [_leftEyeView addGestureRecognizer:panGestureRecognizer1];
    [self.view addSubview:_leftEyeView];
    
    _rightEyeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 42*2, 42*2)];
    UIImageView * reye = [[UIImageView alloc]initWithFrame:CGRectMake(21, 21,  42, 42)];
    reye.image = [UIImage imageNamed:@"camera_locateEye"];
    _rightEyeView.center = _faceData.rEye;
    [_rightEyeView addSubview:reye];
    UIPanGestureRecognizer* panGestureRecognizer2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleAction:)];
    [_rightEyeView addGestureRecognizer:panGestureRecognizer2];
    panGestureRecognizer2.minimumNumberOfTouches = 1;
    _rightEyeView.userInteractionEnabled = YES;
    [self.view addSubview:_rightEyeView];
    
    UIButton* dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    dismissBtn.left = 12;
    dismissBtn.top = 22;
    [dismissBtn setImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissBtn];
    
    
    _magnifier = [[BYGlassesMagnifier alloc]initWithFrame:CGRectMake(3*SCREEN_PIXELUNIT, 60, 18*SCREEN_PIXELUNIT, 18*SCREEN_PIXELUNIT)];
    [self.view addSubview:_magnifier];
    _magnifier.baseIMG = _image;
    _magnifier.alpha = 0;
    _magnifier.top = dismissBtn.bottom + 7 * SCREEN_PIXELUNIT;
    
    
    UIButton* nextBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, 104, 40) title:@"下一步" titleColor:BYColorWhite bgName:@"camera_reshoot_btn" handler:^(id sender) {
        BYGlassTryVC* tryVC = [[BYGlassTryVC alloc]initWithData:_faceData backGroundImg:_image];
        BYGlassService * saveFaceService = [[BYGlassService alloc]init];
        [saveFaceService modifyFace:_faceData];
        [self.navigationController pushViewController:tryVC animated:YES];
    }];
    nextBtn.centerX = SCREEN_WIDTH / 2;
    nextBtn.bottom = SCREEN_HEIGHT - 28;
    [self.view addSubview:nextBtn];
    
    
    _guideView = [BYGlassesAnimateView AnimateView];
    
    _guideView.left = 12;
    _guideView.bottom = nextBtn.top - 12;
    
    [self.view addSubview:_guideView];
}

- (void)handleAction:(UIPanGestureRecognizer*) recognizer{
    _magnifier.alpha = 1;
    CGPoint translation = [recognizer translationInView:self.view];
    float locationX = recognizer.view.center.x + translation.x;
    float locationY = recognizer.view.center.y + translation.y;
    int dis = (SCREEN_WIDTH/16);//预留1/16宽度
    if (locationX<dis) {
        locationX = dis;
    }else if (locationX>(SCREEN_WIDTH-dis)){
        locationX = SCREEN_WIDTH - dis;
    }
    if (locationY<dis) {
        locationY = dis;
    }else if (locationY>(SCREEN_HEIGHT-dis)){
        locationY = SCREEN_HEIGHT - dis;
    }
    recognizer.view.center = CGPointMake(locationX,locationY);
    _magnifier.location = recognizer.view.center;
    recognizer.view.center = CGPointMake(locationX,locationY);
    [recognizer setTranslation:CGPointZero inView:self.view];
    if (recognizer.view == _leftEyeView) {
        _faceData.lEye = recognizer.view.center;
    }
    if (recognizer.view == _rightEyeView) {
        _faceData.rEye = recognizer.view.center;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:1 animations:^{
            _magnifier.alpha = 0;
        } completion:^(BOOL finish){
            
        }];
    }
}

- (void)dismiss{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
}


@end
