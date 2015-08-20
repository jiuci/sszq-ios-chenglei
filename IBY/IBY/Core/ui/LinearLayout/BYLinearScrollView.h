//
//  MTAutoLinearLayoutScrollView.h
//  iMeituan
//
//  Created by pp on 6/27/13.
//  Copyright (c) 2013 iby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TPKeyboardAvoidingScrollView.h>

//可纵向线性布局的scrollview
@interface BYLinearScrollView : TPKeyboardAvoidingScrollView <UITextViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, readonly) NSMutableArray* items;
@property (nonatomic, assign) BOOL autoAdjustFrameSize; // Updates the frame size as items are added/removed. Default is NO.
@property (nonatomic, assign) BOOL autoAdjustContentSize; // Updates the contentView as items are added/removed. Default is YES.
@property (nonatomic, assign) CGFloat minContentSizeHeight;

- (NSUInteger)by_addEmptyViewWithPaddingTop:(CGFloat)top;
- (NSUInteger)by_addSubview:(UIView*)view paddingTop:(CGFloat)top;
- (NSUInteger)by_addSubview:(UIView*)view paddingTop:(CGFloat)top paddingBottom:(CGFloat)bottom;
- (void)by_removeSubview:(UIView*)view;
- (void)by_removeSubviewAtIndex:(NSUInteger)index;
- (void)by_removeAllSubviews;
- (void)by_insertSubview:(UIView*)newView atIndex:(NSUInteger)index;
- (void)by_updateDisplay;

- (CGFloat)by_layoutOffset;

@end

BYLinearScrollView* makeLinearScrollView(UIViewController* vc);
