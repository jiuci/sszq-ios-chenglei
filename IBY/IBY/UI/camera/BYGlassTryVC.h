//
//  BYGlassTryVC.h
//  IBY
//
//  Created by St on 15/4/7.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"
#import "BYFaceDataUnit.h"
@class BYGlassSampleView;

@interface BYGlassTryVC : BYBaseVC

- (id)initWithData:(BYFaceDataUnit*)faceData backGroundImg:(UIImage*)backImg;

- (void)selectedGlass:(BYGlassSampleView*)sampleGlasses;

@end
