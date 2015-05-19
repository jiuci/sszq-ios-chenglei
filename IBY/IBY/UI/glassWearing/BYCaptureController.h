//
//  BYGlassesController.h
//  IBY
//
//  Created by panshiyu on 15/5/6.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYFaceDataUnit;
@interface BYCaptureController : NSObject

@property (nonatomic,assign)int designId;

+ (instancetype)sharedGlassesController;
- (void)goGlassWearingFromVC:(UIViewController*)fromVC;
- (float)RtBioRulerDetect:(UIImage*)image;
- (BOOL)RtBioRulerDetect:(UIImage*)image inUnit:(BYFaceDataUnit*)dataUnit;
@end
