//
//  BYGlassSinglePageView.m
//  IBY
//
//  Created by St on 15/4/3.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYGlassSinglePageView.h"
#import "BYGlassLocateDistVC.h"

#import "BYGlassService.h"

#import "BYGlassPageVC.h"

@interface BYGlassSinglePageView ()

@property (nonatomic , strong) UIImageView * bottomView;

@property (nonatomic , strong) UIImageView * imageView;

@property (nonatomic , strong) UIImageView * deleteBtnView;

@property (nonatomic , strong) BYFaceDataUnit * data;

@property (nonatomic , weak)UIViewController * glassPageVC;

@property (nonatomic , assign) BOOL  isCreateNewFace;

@end

@implementation BYGlassSinglePageView

- (id)initWithData:(BYFaceDataUnit *)data frame:(CGRect)frame byGlassPage:(UIViewController*)glassPageVC{
    self = [super init];
    if(self){
        self.frame = frame;
        _data = data;
        _glassPageVC = glassPageVC;
        _isCreateNewFace = NO;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame byGlassPage:(UIViewController*)glassPageVC;
{
    self = [super init];
    if(self){
        self.frame = frame;
        _glassPageVC = glassPageVC;
        _isCreateNewFace = YES;
    }
    return self;
}
- (void)setupUI{

    _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(-2, -2, self.width + 4, self.height + 7)];
    _bottomView.image = [[UIImage imageNamed:@"bg_photolist"] resizableImage];
    [self addSubview:_bottomView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, self.width - 6, self.height - 6)];
    NSData* imgData = [[NSFileManager defaultManager]  contentsAtPath:_data.imgPath2];
    UIImage* image = [UIImage imageWithData:imgData];
    _imageView.image = image;
    
    if (_isCreateNewFace) {//非照片
       
        _imageView.image = [[UIImage imageNamed:@"photolist_translucent"] resizableImage];
        UIImageView* takeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        takeImgView.image = [[UIImage imageNamed:@"photolist_takenew"] resizableImage];
        takeImgView.center = CGPointMake(_imageView.width / 2, _imageView.height / 2);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:_glassPageVC action:@selector(createNewFace) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = self.bounds;
        [_imageView addSubview:takeImgView];
        
        _imageView.center = CGPointMake(self.width / 2, self.height / 2);
        [self addSubview:_imageView];
        [self addSubview:button];
        return;
    }
    
    
    
    
    CGSize fitSize;
    float width = self.width - 6;
    float height = self.height - 6;
    if (width/height < image.size.width/image.size.height) {
        fitSize = CGSizeMake(width, image.size.height * ( width / image.size.width) );
    }else{
        fitSize = CGSizeMake(image.size.width * ( height / image.size.height), height );
    }
    BYLog(@"%.0f,%.0f",fitSize.width,fitSize.height);
    _imageView.size = fitSize;
    _imageView.center = CGPointMake(self.width / 2, self.height / 2);
    [self addSubview:_imageView];
    
    
    UIButton * tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tipButton.frame = self.bounds;
    [tipButton addTarget:self action:@selector(didTipInView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:tipButton];
    
    
    
    _deleteBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _deleteBtnView.right = _imageView.right - 6;
    _deleteBtnView.top =  6;
    _deleteBtnView.image = [UIImage imageNamed:@"photolist_delete"];
    _deleteBtnView.hidden = _number;
    [_deleteBtnView addTapAction:@selector(deleteSample) target:self];
    [self addSubview:_deleteBtnView];
}
- (void)didTipInView{
    BYGlassLocateDistVC* locateEyeVC = [[BYGlassLocateDistVC alloc] initWithData:_data backGroundImg:_imageView.image];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:locateEyeVC];
    nav.navigationBar.hidden = YES;
    [_glassPageVC presentViewController:nav animated:YES completion:nil];
}
- (void)deleteSample{
    UIAlertView* alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"确定删除照片？"];
    [alertView bk_addButtonWithTitle:@"取消" handler:^{
        
    }];
    [alertView bk_addButtonWithTitle:@"确定" handler:^{
        BYGlassService *saveGlassService = [[BYGlassService alloc]init];
        if ([saveGlassService removeFace:_data]) {
            [MBProgressHUD topShowTmpMessage:@"删除成功"];
            if (_deleteBlk) {
                _deleteBlk(_number);
            }
        }
    }];
    [alertView show];
}
- (void)setIsCurrentPage:(BOOL)isCurrentPage
{
    if (isCurrentPage) {
        _deleteBtnView.hidden = NO;
    }else{
        _deleteBtnView.hidden = YES;
    }
}
@end
