//
//  BYCameraManager.h
//  IBY
//
//  Created by St on 15/3/27.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <MediaPlayer/MediaPlayer.h>

#define MAX_PINCH_SCALE_NUM   3.f
#define MIN_PINCH_SCALE_NUM   1.f

typedef void(^DidCapturePhotoBlock)(UIImage *stillImage);   //返回静态图

@interface BYCameraManager : NSObject

@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput *inputDevice;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;


//pinch
@property (nonatomic, assign) CGFloat preScaleNum;
@property (nonatomic, assign) CGFloat scaleNum;


- (void)configureWithParentLayer:(UIView*)parent previewRect:(CGRect)preivewRect;

- (void)takePicture:(DidCapturePhotoBlock)block;
- (void)switchCamera:(BOOL)isFrontCamera;
- (void)pinchCameraViewWithScalNum:(CGFloat)scale;
- (void)pinchCameraView:(UIPinchGestureRecognizer*)gesture;
- (void)switchFlashMode:(UIButton*)sender;
- (void)focusInPoint:(CGPoint)devicePoint;
//- (void)switchGrid:(BOOL)toShow;

@end
