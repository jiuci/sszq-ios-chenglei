//
//  BYFaceDataUnit.h
//  IBY
//
//  Created by St on 15/3/30.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseDomain.h"

@interface BYFaceDataUnit : BYBaseDomain

@property (nonatomic , copy) NSString* imgPath1;
@property (nonatomic , copy) NSString* imgPath2;
@property (nonatomic , assign) BOOL step1Finishied;
@property (nonatomic , assign) BOOL step2Finishied;

@property (nonatomic , assign) float distance;
@property (nonatomic , assign) int facePixels;

@property (nonatomic , assign) CGPoint lEye;
@property (nonatomic , assign) CGPoint rEye;

@property (nonatomic , assign) BOOL isValid;

@property (nonatomic , strong) UIImage * image1;

- (void)setImg1:(UIImage*)img distance:(float)dist;

- (void)setImg2:(UIImage*)img ;

- (UIImage*)getImg2;

@end
