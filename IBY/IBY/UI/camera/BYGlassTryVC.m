//
//  BYGlassTryVC.m
//  IBY
//
//  Created by St on 15/4/7.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYGlassTryVC.h"
#import "BYGlassService.h"
#import "BYGlassSampleView.h"
#import "BYGlasses.h"
#import "BYImageView.h"
#import "BYCaptureController.h"
#import "UIImage+Resize.h"
#import "BYCustomButton.h"

@interface BYGlassTryVC ()

@property (nonatomic , strong) BYFaceDataUnit * faceData;

@property (nonatomic , strong) UIImage * image;
@property (nonatomic , strong) UIImageView * imageView;
@property (nonatomic , strong) BYImageView * detailView;
@property (nonatomic , strong) BYImageView * glassImgView;
@property (nonatomic , strong) UIScrollView* glassContentScrollView;
@property (nonatomic , strong) UIButton * reconnectButton;
@property (nonatomic , strong) UIButton* buyBtn;
@property (nonatomic , strong) NSMutableArray* glassArray;
@property (nonatomic , strong) NSMutableArray* glassViewArray;

@property (nonatomic , strong) BYGlassSampleView* activeGlasses;

@property (nonatomic , strong) UIWebView * web;//test

@property (nonatomic, assign) float maxScale;
@property (nonatomic, assign) BOOL firstLoad;
@property (nonatomic, assign) float minScale;
@property (nonatomic, assign) CGSize glassSize;
@property (nonatomic, assign) int number;

@end

@implementation BYGlassTryVC{
    int _designId;
    
    NSString *_testImg;
}

- (id)initWithData:(BYFaceDataUnit *)faceData backGroundImg:(UIImage*)backImg{
    self = [super init];
    if(self){
        _image = backImg;
        _faceData = faceData;
        _glassArray = [NSMutableArray array];
        _glassViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self updateData];
    _number = 0;
    
}
- (void)updateData{
    
    [BYGlassService fetchTryListByDesignId:[BYCaptureController sharedGlassesController].designId needShow:YES faceWidth:(_faceData.distance) finish:^(NSArray *glassesList, BYError *error) {
        if (!error) {
            [self refreshGlass:glassesList];
        }else{
            BYLog(@"%@",error);
        }
        [self connectedToHost:!error];
    }];
    
}

#pragma mark - 有无网络连接调整UI
- (void)connectedToHost:(BOOL)isConnect
{
    if (isConnect) {
        _reconnectButton.hidden = YES;
        _glassContentScrollView.hidden = NO;
        [_buyBtn setBackgroundImage:[[UIImage imageNamed:@"camera_buy_btn"] resizableImage] forState:UIControlStateNormal];
        [_buyBtn setBackgroundImage:[[UIImage imageNamed:@"camera_buy_btn"] resizableImage] forState:UIControlStateHighlighted];
    }else{
        
        [MBProgressHUD topShowTmpMessage:@"网络连接异常，请调整后重试"];
        _reconnectButton.hidden = NO;
        _glassContentScrollView.hidden = YES;
        [_buyBtn setBackgroundImage:[[UIImage imageNamed:@"bg_main_btn_undo"] resizableImage] forState:UIControlStateNormal];
        [_buyBtn setBackgroundImage:[[UIImage imageNamed:@"bg_main_btn_undo"] resizableImage] forState:UIControlStateHighlighted];
    }
}
#pragma mark -
- (void)setupUI{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _imageView.image = _image;
    _imageView.size = _imageView.image.size;
    _imageView.center = self.view.center;
    [self.view addSubview:_imageView];
    
    UIButton* dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    dismissBtn.left = 12;
    dismissBtn.top = 22;
    [dismissBtn setImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissBtn];
    
    
    
    BYCustomButton *detailBtn = [BYCustomButton btnWithFrame:CGRectMake(0, 0, 23*SCREEN_PIXELUNIT, 8*SCREEN_PIXELUNIT)
                                         icon:@"icon_guide_info"
                                        title:@"镜框尺寸"
                                    titleFont:Font(14)
                                   titleColor:BYColorWhite];
    [detailBtn setNormalBg:@"camera_reshoot_btn"];
    [detailBtn setHighlightBg:@"camera_reshoot_btn"];
    
    detailBtn.right = SCREEN_WIDTH - 2 * SCREEN_PIXELUNIT;
    detailBtn.centerY = dismissBtn.centerY;
    [detailBtn addTarget:self action:@selector(showGlassesDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailBtn];
    
    
    _buyBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, 104, 32) title:@"立即购买" titleColor:BYColorWhite bgName:@"camera_buy_btn" handler:^(id sender) {
        BOOL isConnect = [BYAppCenter sharedAppCenter].isNetConnected;
        [self connectedToHost:isConnect];
        if (isConnect) {
            NSDictionary *params = @{
                                     @"did":@(_activeGlasses.glassesUnit.designId)
                                     };
            
            [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHomeWithGlassesId params:params];
        }
        
    }];
    _buyBtn.bottom = SCREEN_HEIGHT * .95;
    _buyBtn.centerX = SCREEN_WIDTH / 2;
    [self.view addSubview:_buyBtn];
    
    _glassContentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    _glassContentScrollView.backgroundColor = BYColorClear;
    [self.view addSubview:_glassContentScrollView];
    _glassContentScrollView.bottom = _buyBtn.top - 10;
    
    _reconnectButton = [UIButton buttonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) title:@"网络连接异常，请调整后重试" titleColor:[UIColor whiteColor] bgName:nil handler:^(id sender){
        if ([BYAppCenter sharedAppCenter].isNetConnected) {
            [self updateData];
        }else{
            [MBProgressHUD topShowTmpMessage:@"网络连接异常，请调整后重试"];
        }
    }];
    _reconnectButton.center = _glassContentScrollView.center;
    [self.view addSubview:_reconnectButton];
    _reconnectButton.hidden = YES;
    
    _firstLoad = YES;
    _glassImgView = [[BYImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    _glassImgView.alpha = 0;
    _glassImgView.backgroundColor = BYColorClear;
    UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleAction:)];
    [_glassImgView addGestureRecognizer:panGestureRecognizer];
    UIPinchGestureRecognizer* pinGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    [_glassImgView addGestureRecognizer:pinGestureRecognizer];
    UIRotationGestureRecognizer* rotationGestureRecongnizer = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotation:)];
    [_glassImgView addGestureRecognizer:rotationGestureRecongnizer];
    _glassImgView.userInteractionEnabled = YES;
    [self.view addSubview:_glassImgView];
    
    
    _detailView = [[BYImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    _detailView.alpha = 0;
    _detailView.backgroundColor = BYColorClear;
    [_detailView addTapAction:@selector(showGlassesDetail) target:self];
    [self.view addSubview:_detailView];
    
    UIImageView * closeDetail = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    closeDetail.right = _detailView.width;
    closeDetail.top = 0;
    closeDetail.image = [UIImage imageNamed:@"photolist_delete"];
    [_detailView addSubview:closeDetail];
    
    //guide
    NSString* kHasShowGuide = @"com.biyao.glassesTryGestureRecognizerGuide";
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
        [self addGuide];
    }else{
//        [self addGuide];
    }
}
-(void)addGuide
{
    UIView * guideView = [[UIImageView alloc]initWithFrame:self.view.frame];
    UIImageView * guideImv = [[UIImageView alloc]initWithFrame:guideView.frame];
    [guideView addSubview:guideImv];
    [self.view addSubview:guideView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:guideView action:@selector(removeFromSuperview)];
    [guideView addGestureRecognizer:tap];
    guideView.userInteractionEnabled = YES;
    guideImv.image = [UIImage imageNamed:@"tutorial"];
    guideImv.width = SCREEN_WIDTH;
    guideImv.height = guideImv.image.size.height / guideImv.image.size.width * SCREEN_WIDTH;
    guideImv.centerY = SCREEN_HEIGHT / 2;
    guideView.backgroundColor = [UIColor blackColor];
    guideView.alpha = .6;
}
- (void)handleAction:(UIPanGestureRecognizer*) recognizer{
    
    CGPoint translation = [recognizer translationInView:self.view];
    float x = recognizer.view.center.x + translation.x;
    float y = recognizer.view.center.y + translation.y;
    x = x > 0 ? x : 0;
    y = y > 0 ? y : 0;
    x = x < SCREEN_WIDTH ? x : SCREEN_WIDTH;
    y = y < SCREEN_HEIGHT ? y : SCREEN_HEIGHT;
    recognizer.view.center = CGPointMake(x,y);
//    _glassCenter = recognizer.view.center;
    [recognizer setTranslation:CGPointZero inView:self.view];
}
- (void)handlePinch:(UIPinchGestureRecognizer*) recognizer{
    _maxScale = SCREEN_WIDTH / _glassImgView.size.width;
    _minScale = SCREEN_WIDTH / 2 / _glassImgView.size.width;
    
    recognizer.scale = recognizer.scale > _minScale ? recognizer.scale : _minScale;
    recognizer.scale = recognizer.scale < _maxScale ? recognizer.scale : _maxScale;
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        _glassImgView.transform = CGAffineTransformScale(_glassImgView.transform, recognizer.scale, recognizer.scale);
        recognizer.scale = 1;
    }
//    NSLog(@"%@",NSStringFromCGSize(CGSizeApplyAffineTransform(_glassSize, _glassImgView.transform)));
    return;
//    float scale = (recognizer.scale - 1) + 1;
//    scale = scale * _glassScale;
//    if (_glassImgView.width * scale < SCREEN_WIDTH && scale > .5) {
//        float width = _glassImgView.width;
//        _glassImgView.width = _glassSize.width *scale;
//        _glassImgView.height = _glassSize.height *scale;
//        _glassImgView.center = _glassCenter;
//        if (recognizer.state == 4||recognizer.state == 3) {
//            _glassScale = scale;
//        }
//    }else if (scale <= .5){
//        _glassScale = .5;
//        _glassImgView.width = _glassSize.width *_glassScale;
//        _glassImgView.height = _glassSize.height *_glassScale;
//        _glassImgView.center = _glassCenter;
//
//    }else if (_glassImgView.width * scale >= SCREEN_WIDTH){
//        _glassScale = SCREEN_WIDTH / _glassSize.width;
//        _glassImgView.width = _glassSize.width *_glassScale;
//        _glassImgView.height = _glassSize.height *_glassScale;
//        _glassImgView.center = _glassCenter;
//    }
//    
}
- (void)handleRotation:(UIRotationGestureRecognizer*) recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {//    _glassImgView.transform = CGAffineTransformMakeRotation(_glassRotation + recognizer.rotation);
        _glassImgView.transform = CGAffineTransformRotate(_glassImgView.transform, recognizer.rotation);
        [recognizer setRotation:0];
    }
//    if (recognizer.state == 3 || recognizer.state == 4) {
//        _glassRotation = recognizer.rotation;
//    }
}
- (void)refreshGlass:(NSArray*)glassesArray
{
    if (!glassesArray) {
        return;
    }
    _glassArray = [NSMutableArray arrayWithArray:glassesArray];
    [_glassContentScrollView removeAllSubviews];
    float suitWidth = _glassArray.count * (12 + 60) + 12;
    if(suitWidth < SCREEN_WIDTH){
        _glassContentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 70);
    }else{
        _glassContentScrollView.contentSize = CGSizeMake(suitWidth, 70);
    }
    
    
    
    for (int i = 0 ; i < _glassArray.count; i++) {
        BYGlassSampleView* glassSampleView = [[BYGlassSampleView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        glassSampleView.glassesUnit = _glassArray[i];
        [glassSampleView setupUI];
        glassSampleView.backgroundColor = [UIColor clearColor];
        glassSampleView.userInteractionEnabled = YES;
        glassSampleView.left = 12 + i * (12 + 60);
        glassSampleView.parentVC = self;
        glassSampleView.tag = i;
        [_glassContentScrollView addSubview:glassSampleView];
        [_glassViewArray addObject:glassSampleView];
        
    }
    if (_glassViewArray.count) {
        [_glassViewArray[0] selected];
    }
    
}
- (void)reloadGlassesTry
{
    if (!_activeGlasses) {
        return;
    }
    __weak BYGlassTryVC *weakself = self;
    [_glassImgView setImageWithUrl:_activeGlasses.glassesUnit.imgURL placeholderName:nil finish:^(UIImage* image){
        [weakself resizeGlassesImg:image];
    }];
    
}
- (void)resizeGlassesImg:(UIImage*)image
{
//    NSArray*array =[NSArray arrayWithObjects:@"0.2",@"0.3",@"0.4",@"0.5", nil];
//    
//    _glassImgView.image = [UIImage imageNamed:array[_number++]];
//    if (_number>=array.count) {
//        _number = 0;
//    }
    if (image && image.size.width>0 ) {
        CGPoint center = _glassImgView.center;
        CGAffineTransform transform = _glassImgView.transform;
        
        int width=0;
        width = (_faceData.facePixels / _faceData.distance * (_activeGlasses.glassesUnit.faceWidth) * 40 / 37.0);//边框大小修正
        
//        NSLog(@"%f",_faceData.distance);
        _maxScale = SCREEN_WIDTH / width;
        _minScale = SCREEN_WIDTH / 2 / width;
        _glassImgView.transform = CGAffineTransformIdentity;
        _glassImgView.frame = CGRectMake(0, 0, width, (_glassImgView.image.size.height/_glassImgView.image.size.width*width));
        float deflection = .1;                                                                              //向下的旋转偏移修正
        _glassImgView.centerY = _faceData.lEye.y/2 + _faceData.rEye.y/2 + (_faceData.rEye.x - _faceData.lEye.x) * deflection;
        _glassImgView.centerX = _faceData.lEye.x/2 + _faceData.rEye.x/2 + (_faceData.rEye.y - _faceData.lEye.y) * deflection;
        float rotation = (_faceData.rEye.y-_faceData.lEye.y)/(float)(_faceData.rEye.x-_faceData.lEye.x);
        _glassImgView.transform = CGAffineTransformMakeRotation(rotation);
//        _glassCenter = _glassImgView.center;
//        _glassSize = _glassImgView.size;
        _glassSize = _glassImgView.size;
        if (_firstLoad) {
            _firstLoad = NO;
        }else{
            _glassImgView.center = center;
            _glassImgView.transform = transform;
        }
    }else{
        [MBProgressHUD topShowTmpMessage:@"网络连接异常，请调整后重试"];
    }
}
- (void)showGlassesImg
{
    if (!_activeGlasses) {
        return;
    }
    
    if (_glassImgView.alpha == 0) {
        [UIView animateWithDuration:.5
                         animations:^{
                             _glassImgView.alpha = 1;
                         }
                         completion:nil];
    }
}
- (void)reloadGlassesDetail
{
    if (!_activeGlasses) {
        return;
    }
    __weak BYGlassTryVC *weakself = self;
    [_detailView setImageWithUrl:_activeGlasses.glassesUnit.infoURL placeholderName:nil finish:^(UIImage* image){
        [weakself resizeDetailView:image];
    }];
}
- (void)resizeDetailView:(UIImage*)image
{
    if (image&&image.size.width>0) {
        _detailView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/image.size.width*image.size.height);
        _detailView.bottom = _glassContentScrollView.top - 32;
    }else{
        _detailView.alpha = 0;
        [MBProgressHUD topShowTmpMessage:@"网络连接异常，请调整后重试"];
    }
    [UIView animateWithDuration:.5
                     animations:^{
                         _detailView.alpha = 1;
                     }
                     completion:^(BOOL finish){
                         
                     }];
    
}
- (void)showGlassesDetail
{
    if (!_activeGlasses||![BYAppCenter sharedAppCenter].isNetConnected) {
        [MBProgressHUD topShowTmpMessage:@"网络连接异常，请调整后重试"];
        return;
    }
    
    if (_detailView.alpha == 1) {
        [self hideDetailView];
        return;
    }
    [self reloadGlassesDetail];
    
}
- (void)hideDetailView
{
    [UIView animateWithDuration:.5
                     animations:^{
                         _detailView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                     }];
}
- (void)selectedGlass:(BYGlassSampleView*)sampleGlasses{

//    BYGlasses *glass =_glassArray[sampleGlasses.tag];
//    int designID = glass.designId;
//    NSString * str = [NSString stringWithFormat:@"http://m.biyao.com/product/show?designid=%d",designID];
//    if (!_web.superview) {
//        _web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _glassContentScrollView.top)];
//        [self.view addSubview:_web];
//    }
//    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    return;//测试下单等操作用
    if (_activeGlasses == sampleGlasses) {
        return;
    }
    
    for (BYGlassSampleView* view in _glassViewArray) {
        [view cancelSelected];
    }
//    [iConsole log:@"change select"];
    _activeGlasses = sampleGlasses;
    
    [self reloadGlassesTry];
    [self showGlassesImg];
    if (_detailView.alpha == 1) {
        [self reloadGlassesDetail];
    }
//    [iConsole log:@"select complete"];
    
}
- (void)dismiss{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
