//
//  BYGlassSampleView.h
//  IBY
//
//  Created by St on 15/4/7.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYGlassTryVC.h"
@class BYGlasses;

@interface BYGlassSampleView : UIView

@property (nonatomic , copy) BYGlasses * glassesUnit;

@property (nonatomic , strong) BYGlassTryVC* parentVC;

//@property (nonatomic , strong) NSString * smallImgURL; //列表显示用图片地址
//
//@property (nonatomic , strong) NSString * imgURL; //试戴眼镜图片地址
//
//@property (nonatomic , strong) NSString * infoURL;  //眼镜信息图片地址

- (void)setupUI;

- (void)cancelSelected;

- (void)selected;

@end
