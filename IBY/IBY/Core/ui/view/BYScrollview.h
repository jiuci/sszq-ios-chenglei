//
//  BYScrollview.h
//  IBY
//
//  Created by panshiyu on 14/12/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BYScrollTime 3.0

@class BYScrollItem;

typedef void (^BYScrollTapBlock)(BYScrollItem* item);

//简单来说，就是scrollview + pageControl的功能
@interface BYScrollview : UIView

@property (nonatomic, copy) BYScrollTapBlock tapBlk;
@property (nonatomic, assign) BOOL autoScrollEnable;
@property (nonatomic, assign) BOOL showPageControl;
@property (nonatomic, strong, readonly) NSArray* items;

- (instancetype)initWithFrame:(CGRect)frame layout:(UICollectionViewFlowLayout*)layout;
- (void)update:(NSArray*)datas;

@end

@interface BYScrollItem : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, copy) NSString* imgUrl;

+ (instancetype)itemWithData:(id)data imgUrl:(NSString*)imgUrl;

@end

@interface BYScrollUnit : UICollectionViewCell

@property (nonatomic, strong) BYScrollItem* refIteml;

@end
