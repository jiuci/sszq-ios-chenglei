//
//  BYAddressSelectionView.h
//  IBY
//
//  Created by St on 14-10-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBasePopoverView.h"

@protocol BYAddressSelectionDelegate <NSObject>
- (void)didSelect:(id)selectedData;
@end

@interface BYAddressSelectionView : BYBasePopoverView
@property (nonatomic, assign) id<BYAddressSelectionDelegate> delegate;

- (void)updateData:(NSArray*)data;

@end
