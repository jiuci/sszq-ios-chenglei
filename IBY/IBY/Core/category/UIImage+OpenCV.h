//
//  UIImage+OpenCV.h
//  IBY
//
//  Created by St on 15/4/7.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (UIImage_OpenCV)

+(UIImage *)imageWithCVMat:(const cv::Mat&)cvMat;
-(id)initWithCVMat:(const cv::Mat&)cvMat;
- ( IplImage *) createIplImage;
@property(nonatomic, readonly) cv::Mat CVMat;
@property(nonatomic, readonly) cv::Mat CVGrayscaleMat;

@end
