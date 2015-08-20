//
//  BYStarView.h
//  IBY
//
//  Created by panshiyu on 14/11/10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYStarView : UIView
{
    UIView *_yellowView;//黄色的星星
    UIView *_grayView;//灰色的星星
}

@property(nonatomic,assign)CGFloat rating;//评分

@end
