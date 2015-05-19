//
//  BYGlassesController.m
//  IBY
//
//  Created by panshiyu on 15/5/6.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYCaptureController.h"
#import "BYCaptureVC.h"
#import "BYGlassPageVC.h"

#import "BYGlassService.h"
#import "BYFaceDataUnit.h"

#include "RtBioRuler.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "UIImage+OpenCV.h"

@interface BYCaptureController()
@property rt::RtBioRuler  bioRuler;
@end


@implementation BYCaptureController{
    
}

+ (instancetype)sharedGlassesController{
    static BYCaptureController* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (float)RtBioRulerDetect:(UIImage*)image {
    float faceWidth;
    IplImage* calculationImage = [image createIplImage];
    _bioRuler.Init( calculationImage, faceWidth );
    cvReleaseImage( &calculationImage );
    BYLog(@"____faceWidth___%f",faceWidth);
    return faceWidth;
}

- (BOOL)RtBioRulerDetect:(UIImage*)image inUnit:(BYFaceDataUnit*)dataUnit{
    CvPoint lEye;
    CvPoint rEye;
    float faceWidth;
    int facePixels;
    IplImage* calculationImage = [image createIplImage];
    bool detectCompele = _bioRuler.Detect(calculationImage, lEye, rEye, faceWidth ,facePixels);
    cvReleaseImage( &calculationImage );
    dataUnit.lEye = CGPointMake(lEye.x/1.0, lEye.y/1.0);
    dataUnit.rEye = CGPointMake(rEye.x/1.0, rEye.y/1.0);
    dataUnit.facePixels = facePixels;
    return detectCompele;
}

- (void)goGlassWearingFromVC:(UIViewController*)fromVC {
    BYGlassService *glassService = [[BYGlassService alloc]init];
    
    if([glassService nativeFacelist].count == 0){
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"共需拍摄2张照片，请准备一张身份证或者相同大小的卡片，摘下眼镜，秀发放到耳后"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
        BYCaptureVC* capVC = [[BYCaptureVC alloc] init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:capVC];
        [fromVC presentViewController:nav animated:YES completion:^{
        }];
    }else{
        BYGlassPageVC* pageVC = [[BYGlassPageVC alloc]init];
        [fromVC.navigationController pushViewController:pageVC animated:YES];
    }
}

@end
