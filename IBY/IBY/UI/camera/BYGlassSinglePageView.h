//
//  BYGlassSinglePageView.h
//  IBY
//
//  Created by St on 15/4/3.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYFaceDataUnit.h"


typedef void (^deleteBlock)(int number);

@interface BYGlassSinglePageView : UIView

@property (nonatomic , copy) deleteBlock deleteBlk;
@property (nonatomic , assign) int number;
@property (nonatomic , assign) BOOL isCurrentPage;

- (id)initWithData:(BYFaceDataUnit*)data frame:(CGRect)frame byGlassPage:(UIViewController*)glassPageVC;

- (id)initWithFrame:(CGRect)frame byGlassPage:(UIViewController*)glassPageVC;

- (void)setupUI;

@end
