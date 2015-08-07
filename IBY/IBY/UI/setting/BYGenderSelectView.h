//
//  BYGenderSelectView.h
//  IBY
//
//  Created by kangjian on 15/8/5.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBasePopoverView.h"
@protocol BYGenderSelectionDelegate <NSObject>
@required
- (void)didSelect:(UIButton*)sender;
@end

@interface BYGenderSelectView : BYBasePopoverView
@property (nonatomic, assign) id<BYGenderSelectionDelegate> delegate;

@end
