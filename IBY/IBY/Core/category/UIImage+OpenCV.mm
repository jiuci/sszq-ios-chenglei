//
//  UIImage+OpenCV.m
//  IBY
//
//  Created by St on 15/4/7.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "UIImage+OpenCV.h"

//static void ProviderReleaseDataNOP(void *info, const void *data, size_t size)
//{
//    // Do not release memory
//    return;
//}



@implementation UIImage (UIImage_OpenCV)

-(cv::Mat)CVMat
{
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                     // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(cv::Mat)CVGrayscaleMat
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat cvMat = cv::Mat(rows, cols, CV_8UC1); // 8 bits per component, 1 channel
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                     // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNone |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat
{
    return [[UIImage alloc] initWithCVMat:cvMat];
}

- (id)initWithCVMat:(const cv::Mat&)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1)
    {
        colorSpace = CGColorSpaceCreateDeviceGray();
    }
    else
    {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                     // Width
                                        cvMat.rows,                                     // Height
                                        8,                                              // Bits per component
                                        8 * cvMat.elemSize(),                           // Bits per pixel
                                        cvMat.step[0],                                  // Bytes per row
                                        colorSpace,                                     // Colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
                                        provider,                                       // CGDataProviderRef
                                        NULL,                                           // Decode
                                        false,                                          // Should interpolate
                                        kCGRenderingIntentDefault);                     // Intent
    
    self = [self initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return self;
}
- ( IplImage *) createIplImage{
    // Getting CGImage from UIImage
    CGImageRef imageRef = self. CGImage ;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB ();
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage( cvSize(self.size.width,self.size.height), IPL_DEPTH_8U , 4 );
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate ( iplimage->imageData, iplimage->width, iplimage->height, iplimage->depth, iplimage->widthStep, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault );
    // Drawing CGImage to CGContext
    CGContextDrawImage ( contextRef, CGRectMake ( 0 , 0 , self.size.width, self.size.height), imageRef ); CGContextRelease (contextRef); CGColorSpaceRelease (colorSpace);
    // Creating result IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U , 3 );
    cvCvtColor(iplimage, ret, CV_RGBA2BGR );
    cvReleaseImage(&iplimage);
    return ret;
}
@end
