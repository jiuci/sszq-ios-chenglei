//
//  BYHeaderView.h
//  IBY
//
//  Created by coco on 14-9-18.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYMineVC;
@interface BYMineHeaderView : UIView

@property (nonatomic, weak) BYMineVC* mineVC;

+ (instancetype)headerView;
- (void)updateUI;

- (void)setupUI;

@end
