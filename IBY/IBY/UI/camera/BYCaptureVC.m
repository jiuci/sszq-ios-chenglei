//
//  BYCaptureVC.m
//  IBY
//
//  Created by St on 15/3/27.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYCaptureVC.h"
#import "BYCameraManager.h"
#import "BYGlassProcessVC.h"

#import "BYGlassService.h"

#import "BYFaceDataUnit.h"

#import "UIImage+Resize.h"
#import "BYCustomButton.h"

#import "BYCaptureController.h"
//对焦
#define ADJUSTINT_FOCUS @"adjustingFocus"

#define RATEFORFACE      0.692
#define RATEFOREYE      0.518

#define SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE      0   //对焦框是否一直闪到对焦完成




@interface BYCaptureVC ()

@property (nonatomic, assign) CGRect previewRect;

@property (nonatomic, assign) CGPoint currTouchPoint;

@property (nonatomic, strong) BYCameraManager *captureManager;

@property (nonatomic, strong) UIImageView *faceFrameView; //脸部 虚线框

@property (nonatomic, strong) UIView *topContainerView;//顶部view

@property (nonatomic, strong) UIView *bottomContainerView;//除了顶部标题、拍照区域剩下的所有区域

@property (nonatomic, strong) UIView *guideView;//引导流程view

@property (nonatomic, strong) UILabel* noticeLabel;

@property (nonatomic, strong) UIImageView* guideImv;

@property (nonatomic, strong) UIPageControl *pageControl;

//对焦
@property (nonatomic, strong) UIImageView *focusImageView;

@property (nonatomic, strong)  UIButton* switchBtn;
@property (nonatomic, strong)  BYCustomButton* showGuide;
//数据
@property (nonatomic, strong) BYFaceDataUnit* dataUnit;

@property (nonatomic, assign) enum DetectStatus status;


@end

@implementation BYCaptureVC{
    int alphaTimes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [MBProgressHUD topShowTmpMessage:@"该设备不支持拍照功能~~！T_T"];

        [self dismissView];
        return;
    }
    
    //navigation bar hide
    self.title = @"眼镜拍照";
    
    if (self.navigationController && !self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
    //status bar hide
    if (self.navigationController) {
        //iOS7，需要plist里设置 View controller-based status bar appearance 为NO
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
    
    //初始化数据
    _dataUnit = [[BYFaceDataUnit alloc]init];

    //session manager
    BYCameraManager* manager = [[BYCameraManager alloc] init];
    
    //预显示区域的 大小
    self.previewRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
    
    [manager configureWithParentLayer:self.view previewRect:self.previewRect];
    self.captureManager = manager;
    
    [self addFaceFrame];
    [self addTopView];
    [self addFocusView];
    [self addBottomView];
    [self addGuideView];
    
    [self step1];
    
    [_captureManager.session startRunning];
    
    //缩放被屏蔽掉啦屏蔽掉啦！！！
//    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:manager action:@selector(pinchCameraView:)];
//    [self.view addGestureRecognizer:pinch];
    
}


- (void)step1{
    _noticeLabel.text = @"提示：使用卡片会使试戴效果更佳";
    _faceFrameView.image = [UIImage imageNamed:@"bg_figure_frame_withcard"];
    self.switchBtn.hidden = NO;
    self.showGuide.hidden = NO;
}

- (void)step2{
    _noticeLabel.text = @"请拿掉卡片再拍一张";
    _faceFrameView.image = [UIImage imageNamed:@"bg_figure_frame_withoutcard"];
    self.switchBtn.hidden = YES;
    self.showGuide.hidden = YES;
    _status = DetectUnfinished;
}

- (void)addFaceFrame{
    
    UIImage* faceImage = [UIImage imageNamed:@"bg_figure_frame_withcard"];

    float suitWidth = .9 * SCREEN_WIDTH;
    float suitheight = faceImage.size.height * (suitWidth / faceImage.size.width);

    _faceFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, suitWidth, suitheight)];
    _faceFrameView.centerX = SCREEN_WIDTH / 2;
    _faceFrameView.centerY = (SCREEN_HEIGHT *.4);
    
    _faceFrameView.image = faceImage;
    [self.view addSubview:_faceFrameView];
    
//    UIImageView *dashLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 2)];
//    [self.view addSubview:dashLine];
//    
//    UIGraphicsBeginImageContext(dashLine.frame.size);   //开始画线
//    [dashLine.image drawInRect:CGRectMake(0, 0, dashLine.frame.size.width, dashLine.frame.size.height)];
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
//    
//    
//    CGFloat lengths[] = {10,5};
//    CGContextRef line = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(line, [UIColor whiteColor].CGColor);
//    
//    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
//    CGContextMoveToPoint(line, -10.0, 2.0);    //开始画线
//    CGContextAddLineToPoint(line, SCREEN_WIDTH + 10, 2.0);
//    CGContextMoveToPoint(line, -10.0, 0.0);    //开始画线
//    CGContextAddLineToPoint(line, SCREEN_WIDTH + 10, 0.0);
//    CGContextMoveToPoint(line, -10.0, 1.0);    //开始画线
//    CGContextAddLineToPoint(line, SCREEN_WIDTH + 10, 1.0);
//    CGContextStrokePath(line);
//    
//    dashLine.image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    dashLine.top = _faceFrameView.height * .45 + _faceFrameView.top;
    
//    UILabel* noticeLabel = [UILabel labelWithFrame:CGRectMake(0, 0, 100, 15) font:[UIFont systemFontOfSize:10] andTextColor:BYColorWhite];
//    noticeLabel.text = @"眼睛水平线";
//    noticeLabel.bottom = dashLine.top;
//    [self.view addSubview:noticeLabel];
}

- (void)addTopView{
    if(!_topContainerView){
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        
        UIView * tView = [[UIView alloc] initWithFrame:rect];
        tView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tView];
        self.topContainerView = tView;
        
        _switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
        _switchBtn.right = SCREEN_WIDTH - 12;
        _switchBtn.top = 22;
        [_switchBtn setImage:[UIImage imageNamed:@"camera_switch"] forState:UIControlStateNormal];
        [_switchBtn addTarget:self action:@selector(switchCamera:) forControlEvents:UIControlEventTouchUpInside];
        _switchBtn.selected = YES;
        [tView addSubview:_switchBtn];
        
        UIButton* dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
        dismissBtn.left = 12;
        dismissBtn.top = 22;
        [dismissBtn setImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
        [dismissBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [tView addSubview:dismissBtn];
        
        _showGuide = [BYCustomButton btnWithFrame:CGRectMake(0, 0, 23*SCREEN_PIXELUNIT, 8*SCREEN_PIXELUNIT)
                                icon:@"icon_guide_info"
                               title:@"新手引导"
                           titleFont:Font(14)
                          titleColor:BYColorWhite];
        [_showGuide setNormalBg:@"camera_reshoot_btn"];
        [_showGuide setHighlightBg:@"camera_reshoot_btn"];
        
        _showGuide.right = _switchBtn.left - 3 * SCREEN_PIXELUNIT;
        _showGuide.centerY = _switchBtn.centerY;
        
        [_showGuide addTarget:self action:@selector(showGuideView) forControlEvents:UIControlEventTouchUpInside];
        [tView addSubview:_showGuide];
        
        
    }
}

- (void)addBottomView{
    
    UIButton* shootBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH / 5), (SCREEN_WIDTH / 5))];
    shootBtn.centerX = SCREEN_WIDTH / 2;
    shootBtn.bottom =  SCREEN_HEIGHT - 18;
    [shootBtn setBackgroundImage:[UIImage imageNamed:@"camera_shoot"] forState:UIControlStateNormal];
    [shootBtn addTarget:self action:@selector(takePictureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shootBtn];
    
    _noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    _noticeLabel.text = @"请把脸放在虚线框中";
    _noticeLabel.bottom = shootBtn.centerY - 43;
    [_noticeLabel setFont:[UIFont systemFontOfSize:16]];
    [_noticeLabel setTextColor:BYColorWhite];
    _noticeLabel.textAlignment = NSTextAlignmentCenter;
    _noticeLabel.shadowColor = BYColor4DA6FF;
    _noticeLabel.shadowOffset = CGSizeMake(1, 1);
    
    
    [self.view addSubview:_noticeLabel];
}

- (void)addFocusView{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_focus_x.png"]];
    imgView.alpha = 0;
    [self.view addSubview:imgView];
    self.focusImageView = imgView;
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device addObserver:self forKeyPath:ADJUSTINT_FOCUS options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
#endif
}


-(void)addGuideView
{
    _guideView = [[UIView alloc]initWithFrame:self.view.frame];
    UIScrollView * guideScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    guideScroll.delegate = self;
    NSArray * imageArray = [NSArray arrayWithObjects:@"tutorial01",@"tutorial02",@"tutorial03",@"tutorial04",@"tutorial05", nil];
    for (int i = 0 ; i<imageArray.count; i++) {
        UIImageView*imv =[[UIImageView alloc]init];
        imv.image = [UIImage imageNamed:imageArray[i]];
        imv.size = CGSizeMake(SCREEN_WIDTH, imv.image.size.height/imv.image.size.width*SCREEN_WIDTH);
        imv.left = i*SCREEN_WIDTH;
        [guideScroll addSubview:imv];
        guideScroll.size = CGSizeMake(SCREEN_WIDTH, imv.height);
        guideScroll.contentSize = CGSizeMake(i*SCREEN_WIDTH+SCREEN_WIDTH, imv.size.height);
        if (i == imageArray.count-1) {
            //加入关闭按钮（区域）
            UIButton * useRightNow = [UIButton buttonWithType:UIButtonTypeCustom];
            [useRightNow addTarget:self action:@selector(closeGuideView) forControlEvents:UIControlEventTouchUpInside];
            
            useRightNow.size = CGSizeMake(imv.size.width * 2 / 9, imv.size.height /7);
            useRightNow.bottom = imv.bottom;
            useRightNow.centerX = imv.centerX;
            [guideScroll addSubview:useRightNow];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
        }
    }
    
    
    
    guideScroll.centerY = SCREEN_HEIGHT / 2;
    guideScroll.pagingEnabled = YES;
    [_guideView addSubview:guideScroll];
    _guideView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.9];
    
    UIButton * closeGuideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * closeImg = [UIImage imageNamed:@"close_guide"];
    [closeGuideBtn setImage:closeImg forState:UIControlStateNormal];
    closeGuideBtn.size = CGSizeMake(10*SCREEN_PIXELUNIT, 10*SCREEN_PIXELUNIT);
    [_guideView addSubview:closeGuideBtn];
    closeGuideBtn.right = SCREEN_WIDTH - 8 * SCREEN_PIXELUNIT;
    closeGuideBtn.top = 5 * SCREEN_PIXELUNIT;
    [closeGuideBtn addTarget:self action:@selector(closeGuideView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_guideView];
    
    _guideImv = [[UIImageView alloc]init];
    UIGraphicsBeginImageContext(_guideView.bounds.size);
    [_guideView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _guideImv.image = viewImage;
    
    NSString* kHasShowGuide = @"com.biyao.glassesTryGuide";
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:kHasShowGuide];
    if (!dict) {
        dict = [NSDictionary dictionary];
    }
    BOOL hasShow = [dict[[BYAppCenter sharedAppCenter].appVersion] boolValue];
    if (!hasShow) {
        hasShow = YES;
        NSMutableDictionary* mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
        mdict[[BYAppCenter sharedAppCenter].appVersion] = @(YES);
        [[NSUserDefaults standardUserDefaults] setObject:mdict forKey:kHasShowGuide];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _guideView.alpha = 1;
    }else{
        _guideView.alpha = 0;
    }
    _pageControl = [[UIPageControl alloc]initWithFrame:BYRectMake(0, 0, 300, 30)];
    _pageControl.centerY = guideScroll.bottom + (SCREEN_HEIGHT - guideScroll.bottom) /2;
    _pageControl.centerX = SCREEN_WIDTH / 2;
    _pageControl.currentPageIndicatorTintColor = HEXCOLOR(0xffffff);
    _pageControl.pageIndicatorTintColor = HEXCOLOR(0xeeeeee);
    _pageControl.numberOfPages = imageArray.count;
    [_guideView addSubview:_pageControl];
}

-(void)closeGuideView
{

    UIGraphicsBeginImageContext(_guideView.bounds.size);
    [_guideView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _guideImv.image = viewImage;
    _guideImv.frame = self.view.frame;
    [self.view addSubview:_guideImv];
    _guideView.alpha = 0;
    _guideImv.alpha = 1;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _guideImv.frame = CGRectMake(_showGuide.centerX, _showGuide.centerY, 0, 0);
        _guideImv.alpha = 0;
    } completion:^(BOOL finished){
        [_guideImv removeFromSuperview];
        _showGuide.enabled = YES;
    }];
}
-(void)showGuideView
{
//    if (_guideView.alpha > 0||_guideImv.superview) {
//        return;
//    }
    _showGuide.enabled = NO;
    _guideImv.frame = CGRectMake(_showGuide.centerX, _showGuide.centerY, 0, 0);
    _guideImv.alpha = 0;
    [self.view addSubview:_guideImv];
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _guideImv.alpha = 1;
        _guideImv.frame = self.view.frame;
    } completion:^(BOOL finished){
        _guideView.frame = self.view.frame;
        _guideView.alpha = 1;
        [_guideImv removeFromSuperview];
        
    }];
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat pageWidth = SCREEN_WIDTH;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}
#pragma mark actions
//拍照页面，拍照按钮
- (void)takePictureBtnPressed:(UIButton*)sender {
    
    
#if SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [SVProgressHUD showErrorWithStatus:@"设备不支持拍照功能T_T"];
        return;
    }
#endif
    
    __block UIActivityIndicatorView *actiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actiView.center = CGPointMake(SCREEN_BOUNDS_SIZE.width / 2, SCREEN_BOUNDS_SIZE.height / 2);
    [actiView startAnimating];
    [self.view addSubview:actiView];
    __weak BYCaptureVC* weakself = self;
    [_captureManager takePicture:^(UIImage *stillImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
   
        });
        
        UIImage* rightImage = nil;
        
        if(_switchBtn.selected){ //背面摄像头翻转图像
            CGRect rect = CGRectMake(0, 0, stillImage.size.width, stillImage.size.height);//创建矩形框
            UIGraphicsBeginImageContext(rect.size);//根据size大小创建一个基于位图的图形上下文
            CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
            CGContextClipToRect(currentContext, rect);//设置当前绘图环境到矩形框
            
            
            CGContextRotateCTM(currentContext, M_PI);
            CGContextTranslateCTM(currentContext, -rect.size.width, -rect.size.height);
            //CGContextTranslateCTM(currentContext,0.0,200.0);
            
            CGContextDrawImage(currentContext, rect, stillImage.CGImage);//绘图
            
            rightImage = UIGraphicsGetImageFromCurrentImageContext();//获得图片
            UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境
        }else{
            rightImage = stillImage;
        }
        float scale = .0;
        if (SCREEN_WIDTH/SCREEN_HEIGHT > rightImage.size.width/rightImage.size.height) {//先缩放图片 之后裁剪
            scale = SCREEN_WIDTH / rightImage.size.width ;
            CGSize newSize = CGSizeMake(rightImage.size.width*scale, rightImage.size.height*scale);
            UIGraphicsBeginImageContext(newSize);
            [rightImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            rightImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            rightImage = [rightImage getSubImage:CGRectMake(0 , rightImage.size.height/2 - SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT)];
        }else{
            scale = SCREEN_HEIGHT / rightImage.size.height ;
            CGSize newSize = CGSizeMake(rightImage.size.width*scale, rightImage.size.height*scale);
            UIGraphicsBeginImageContext(newSize);
            [rightImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            rightImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            rightImage = [rightImage getSubImage:CGRectMake( rightImage.size.width/2 - SCREEN_WIDTH/2 ,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        }

        [actiView stopAnimating];
        [actiView removeFromSuperview];
        actiView = nil;
        
        double delayInSeconds = 2.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            sender.userInteractionEnabled = YES;
            //[weakSelf_SC showCdiameraCover:NO];
        });
        
        if(!_dataUnit.step1Finishied){
            _dataUnit.image1 = rightImage;
            _dataUnit.step1Finishied = YES;
            UIImageView* imageView = [[UIImageView alloc] init ];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
            imageView.image = rightImage;
            imageView.size = rightImage.size;
            imageView.center = self.view.center;
            [self.view addSubview:imageView];
            [UIView animateWithDuration:0.3 animations:^{
                self.view.alpha = 0;
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.view.alpha = 1;
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                imageView.frame = CGRectMake((SCREEN_WIDTH - 10) / 2, (SCREEN_HEIGHT - 10) / 2, 10, 10);
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:0.6 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                imageView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT, 2, 2);
            } completion:^(BOOL finished) {
                imageView.hidden = YES;
            }];
            
            [MBProgressHUD topShow:@"识别中"];
            BYCaptureController* BYcapC = [BYCaptureController sharedGlassesController];
            float faceWidth = [BYcapC RtBioRulerDetect:_dataUnit.image1];
            _dataUnit.distance = faceWidth;
            [MBProgressHUD topHide];
            [weakself step2];
        }else{
            BYGlassProcessVC* glassProcessVC = [[BYGlassProcessVC alloc] initWithImage:rightImage faceData:_dataUnit];

            glassProcessVC.reshootPhotoBlok = ^(){
                
                [weakself step1];
                _dataUnit.imgPath1 = nil;
                _dataUnit.imgPath2 = nil;
                _dataUnit.step1Finishied = NO;
                _dataUnit.step2Finishied = NO;
            };
            
            [weakself.navigationController pushViewController:glassProcessVC animated:YES];
        }
        
    }];
}

- (void)setUserDefault{

    BYGlassService *saveGlassService = [[BYGlassService alloc]init];
    [saveGlassService appendFace:_dataUnit];
}

- (void)switchCamera:(UIButton*)sender{
    sender.selected = ! sender.selected;
    [_captureManager switchCamera:sender.selected];
}

- (void)dismissView{



    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    if (self.navigationController) {
        if ([UIApplication sharedApplication].statusBarHidden == YES) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        }
    }
}

#pragma mark  default touch to focus

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!_showGuide.enabled) {//引导按钮不可交互时，不显示聚焦
        return;
    }
    alphaTimes = -1;
    
    UITouch *touch = [touches anyObject];
    _currTouchPoint = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(_captureManager.previewLayer.bounds, _currTouchPoint) == NO) {
        return;
    }
    if (_currTouchPoint.y > SCREEN_HEIGHT * .8 || _currTouchPoint.y < SCREEN_HEIGHT * .2) {
        return;
    }
    
    [_captureManager focusInPoint:_currTouchPoint];
    
    //对焦框
    [_focusImageView setCenter:_currTouchPoint];
    _focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    [UIView animateWithDuration:0.1f animations:^{
        _focusImageView.alpha = 1.0f;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self showFocusInPoint:_currTouchPoint];
    }];
#else
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _focusImageView.alpha = 1.f;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _focusImageView.alpha = 0.f;
        } completion:nil];
    }];
#endif
}

#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
//监听对焦是否完成了
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:ADJUSTINT_FOCUS]) {
        BOOL isAdjustingFocus = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        if (!isAdjustingFocus) {
            alphaTimes = -1;
        }
    }
}

- (void)showFocusInPoint:(CGPoint)touchPoint {
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        int alphaNum = (alphaTimes % 2 == 0 ? 1.0f : 0.6f);
        self.focusImageView.alpha = alphaNum;
        alphaTimes++;
        
    } completion:^(BOOL finished) {
        
        if (alphaTimes != -1) {
            [self showFocusInPoint:_currTouchPoint];
        } else {
            self.focusImageView.alpha = 0.0f;
        }
    }];
}



#endif

- (void)dealloc{

    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device removeObserver:self forKeyPath:ADJUSTINT_FOCUS context:nil];
    }
#endif
    
    self.captureManager = nil;
}



@end
