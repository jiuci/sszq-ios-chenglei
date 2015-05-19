//
//  BYGlassProcessVC.h
//  IBY
//
//  Created by St on 15/3/27.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"
#import "BYFaceDataUnit.h"
enum DetectStatus{
    DetectFailure,
    DetectSuccess,
    DetectUnfinished
};

typedef void (^reshootPhotoBlock)(void);

typedef void (^stepFinishBlock)(bool success);

@interface BYGlassProcessVC : BYBaseVC

@property (nonatomic, copy) reshootPhotoBlock reshootPhotoBlok;

- (id)initWithImage:(UIImage*)img faceData:(BYFaceDataUnit*)faceData;

@end
