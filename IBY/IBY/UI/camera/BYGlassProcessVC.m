//
//  BYGlassProcessVC.m
//  IBY
//
//  Created by St on 15/3/27.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYGlassProcessVC.h"
#import "BYGlassLocateDistVC.h"
#import "BYGlassService.h"

#import "BYCaptureController.h"



@interface BYGlassProcessVC ()

@property (nonatomic , strong) UIImageView* processImageView;
@property (nonatomic , strong) UIImage* processImage;

@property (nonatomic , strong) BYFaceDataUnit* faceData;

@property (nonatomic, strong) UIImageView *faceFrameView; //脸部 虚线框

@property (nonatomic, assign) enum DetectStatus detectFaceStatus;

@property (nonatomic, assign) BOOL didTipNext;
@end

@implementation BYGlassProcessVC

- (id)initWithImage:(UIImage *)img faceData:(BYFaceDataUnit *)faceData{
    self = [super init];
    if(self){
        self.processImage = img;
        self.faceData = faceData;
        self.detectFaceStatus = DetectUnfinished;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _didTipNext = NO;
    [self setupUI];
}

- (void)setupUI{
    

    self.processImageView = [[UIImageView alloc] init ];//WithFrame:CGRectMake(0, 0, SCREEN_BOUNDS_SIZE.width,  SCREEN_BOUNDS_SIZE.height)];
    self.processImageView.image = self.processImage;
    self.processImageView.size = self.processImage.size;
    self.processImageView.center = CGPointMake(SCREEN_BOUNDS_SIZE.width / 2, SCREEN_BOUNDS_SIZE.height / 2);
    self.processImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.processImageView];
    
    //-----
    UIImage* faceImage = [UIImage imageNamed:@"camera_faceframe_withoutcard"];
    
    float suitWidth = .9 * SCREEN_WIDTH;
    float suitheight = faceImage.size.height * (suitWidth / faceImage.size.width);
    
    _faceFrameView = [[UIImageView alloc] initWithFrame:BYRectMake(0, 0, suitWidth, suitheight)];
    _faceFrameView.centerX = SCREEN_WIDTH / 2;
    _faceFrameView.centerY = (SCREEN_HEIGHT *.4);
    
    _faceFrameView.image = faceImage;
    [self.view addSubview:_faceFrameView];
    
    UIImageView *dashLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 2)];
    [self.view addSubview:dashLine];
    
    UIGraphicsBeginImageContext(dashLine.frame.size);   //开始画线
    [dashLine.image drawInRect:CGRectMake(0, 0, dashLine.frame.size.width, dashLine.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    CGFloat lengths[] = {10,5};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor whiteColor].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, -10.0, 2.0);    //开始画线
    CGContextAddLineToPoint(line, SCREEN_WIDTH + 10, 2.0);
    CGContextMoveToPoint(line, -10.0, 0.0);    //开始画线
    CGContextAddLineToPoint(line, SCREEN_WIDTH + 10, 0.0);
    CGContextMoveToPoint(line, -10.0, 1.0);    //开始画线
    CGContextAddLineToPoint(line, SCREEN_WIDTH + 10, 1.0);
    CGContextStrokePath(line);
    
    dashLine.image = UIGraphicsGetImageFromCurrentImageContext();
    
    dashLine.top = _faceFrameView.height * 0.45 + _faceFrameView.top;
    
    UILabel* noticeLabel = [UILabel labelWithFrame:CGRectMake(0, 0, 100, 15) font:[UIFont systemFontOfSize:10] andTextColor:BYColorWhite];
    noticeLabel.text = @"眼睛水平线";
    noticeLabel.bottom = dashLine.top;
    [self.view addSubview:noticeLabel];
    //-----
    
    UIButton* dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    dismissBtn.left = 12;
    dismissBtn.top = 22;
    [dismissBtn setImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissBtn];
    
    float blank = SCREEN_WIDTH - 96 - 124;
    blank = (blank / 3);
    UIButton* reshootBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 96, 40)];
    reshootBtn.left = blank;
    reshootBtn.bottom = SCREEN_HEIGHT - 28;
    [reshootBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [reshootBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reshootBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [reshootBtn setBackgroundImage:[[UIImage imageNamed:@"camera_reshoot_btn"] resizableImage] forState:UIControlStateNormal];
    [reshootBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reshootBtn];
    
    UIButton* saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 124, 40)];
    [saveBtn setBackgroundImage:[[UIImage imageNamed:@"camera_sure_btn"] resizableImage] forState:UIControlStateNormal];
    [saveBtn setTitle:@"拍好了" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    saveBtn.left = blank * 2 +96;
    saveBtn.bottom = SCREEN_HEIGHT - 28;
    [saveBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    
}
- (void)sureAction{
    [MBProgressHUD topShow:@"识别中"];
    BOOL detectCompele = [[BYCaptureController sharedGlassesController] RtBioRulerDetect:_processImage inUnit:_faceData];
    [MBProgressHUD topHide];
    if (detectCompele) {
            
        BYGlassLocateDistVC* locateEyeVC = [[BYGlassLocateDistVC alloc] initWithData:_faceData backGroundImg:self.processImage];
        [self.navigationController pushViewController:locateEyeVC animated:YES];
//        [iConsole log:@"脸宽%.1fmm",_faceData.distance];
//        [iConsole log:@"脸占像素%d/屏幕宽像素%.0f",_faceData.facePixels,_faceData.image1.size.width];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_faceData setImg2:_processImage];
            _faceData.step2Finishied = YES;
                
            [self setUserDefault];
        });
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"哦喔，没有成功\n亲，请调整背景或姿势再试一次" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [self dismiss];
    }
}

- (void)setUserDefault{

    BYGlassService *saveGlassService = [[BYGlassService alloc]init];
    [saveGlassService appendFace:_faceData];
}


- (void)dismiss{
    self.reshootPhotoBlok();
    [self.navigationController popViewControllerAnimated:YES];
}

@end
