//
//  BYLinearView.h
//  IBY
//
//  Created by panShiyu on 14/12/5.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYLinearView : UIView

@property (nonatomic, readonly) NSMutableArray* items;
@property (nonatomic, assign) BOOL autoAdjustFrameSize; // Updates the frame size as items are added/removed. Default is NO.

- (NSUInteger)by_addSubview:(UIView*)view paddingTop:(CGFloat)top;
- (NSUInteger)by_addSubview:(UIView*)view paddingTop:(CGFloat)top paddingBottom:(CGFloat)bottom;
- (void)by_removeSubview:(UIView*)view;
- (void)by_removeSubviewAtIndex:(NSUInteger)index;
- (void)by_removeAllSubviews;
- (void)by_insertSubview:(UIView*)newView atIndex:(NSUInteger)index;
- (void)by_updateDisplay;

@end
