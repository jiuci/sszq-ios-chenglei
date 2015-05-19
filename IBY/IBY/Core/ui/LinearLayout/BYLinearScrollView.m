//
//  MTAutoLinearLayoutScrollView.m
//  iMeituan
//
//  Created by pp on 6/27/13.
//  Copyright (c) 2013 iby. All rights reserved.
//

#import "BYLinearScrollView.h"
#import "BYLinearItem.h"

@implementation BYLinearScrollView {
    UITapGestureRecognizer* _tapTextViewGesture;
}

- (NSUInteger)by_addEmptyViewWithPaddingTop:(CGFloat)top
{
    UIView* emptyView = [[UIView alloc] initWithFrame:BYRectMake(0, 0, self.width, 0)];
    emptyView.backgroundColor = [UIColor clearColor];
    return [self by_addSubview:emptyView paddingTop:top];
}

- (NSUInteger)by_addSubview:(UIView*)view paddingTop:(CGFloat)top
{
    return [self by_addSubview:view paddingTop:top paddingBottom:0];
}

- (NSUInteger)by_addSubview:(UIView*)view paddingTop:(CGFloat)top paddingBottom:(CGFloat)bottom
{
    [super addSubview:view];

    BYLinearItem* item = [[BYLinearItem alloc] initWithView:view paddingTop:top paddingBottom:bottom];
    [_items addObject:item];

    if (_autoAdjustFrameSize) {
        [self resetFrameSize];
    }

    if (_autoAdjustContentSize) {
        [self resetContentSize];
    }

    [self by_updateDisplay];
    return _items.count - 1;
}

- (void)by_removeSubview:(UIView*)view
{
    BYLinearItem* realItem = [_items bk_match:^BOOL(BYLinearItem* obj) {
        return obj.view == view;
    }];
    if (realItem) {
        [realItem.view removeFromSuperview];
        [_items removeObject:realItem];
        [self by_updateDisplay];
    }
}

- (void)by_removeSubviewAtIndex:(NSUInteger)index
{
    if (index >= _items.count) {
        return;
    }

    BYLinearItem* realItem = _items[index];
    [realItem.view removeFromSuperview];
    [_items removeObject:realItem];
    [self by_updateDisplay];
}

- (void)by_removeAllSubviews
{
    [_items bk_each:^(BYLinearItem* obj) {
        [obj.view removeFromSuperview];
    }];
    [_items removeAllObjects];
    [self by_updateDisplay];
}

- (void)by_insertSubview:(UIView*)newView atIndex:(NSUInteger)index
{
    if (index >= _items.count) {
        return;
    }

    [super addSubview:newView];
    BYLinearItem* realItem = [[BYLinearItem alloc] initWithView:newView paddingTop:0 paddingBottom:0];
    [_items insertObject:realItem atIndex:index];
    [self by_updateDisplay];
}

- (void)by_updateDisplay
{
    float curBottom = 0;
    for (BYLinearItem* item in _items) {
        if (item.view.hidden) {
            continue;
        }
        curBottom += item.paddingTop;
        item.view.top = curBottom;
        curBottom = curBottom + item.view.height + item.paddingBottom;
    }

    curBottom = MAX(curBottom, _minContentSizeHeight);
    self.contentSize = CGSizeMake(self.frame.size.width, curBottom);
}

- (CGFloat)by_layoutOffset
{
    return [self layoutOffset];
}

#pragma mark -

- (void)resetFrameSize
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self layoutOffset]);
}

- (void)resetContentSize
{
    float curOffset = [self layoutOffset];
    curOffset = MAX(curOffset, _minContentSizeHeight);
    self.contentSize = CGSizeMake(self.frame.size.width, curOffset);
}

- (CGFloat)layoutOffset
{
    CGFloat curOffset = 0;
    for (BYLinearItem* item in _items) {
        if (item.view.hidden) {
            continue;
        }
        curOffset = curOffset + item.paddingTop + item.view.height + item.paddingBottom;
    }
    return curOffset;
}

#pragma mark - init things

- (id)init
{
    self = [super init];
    if (self) {
        [self setupLinearScrollView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLinearScrollView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupLinearScrollView];
    }
    return self;
}

- (void)setupLinearScrollView
{
    [self observeTextView:YES];
    _items = [[NSMutableArray alloc] init];
    _autoAdjustFrameSize = NO;
    _autoAdjustContentSize = YES;
    self.autoresizesSubviews = NO;

    self.backgroundColor = [UIColor clearColor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

- (void)observeTextView:(BOOL)isObserveTextView
{
    if (!isObserveTextView) {
        if (_tapTextViewGesture) {
            [self removeGestureRecognizer:_tapTextViewGesture];
            _tapTextViewGesture = nil;
        }
    }
    else {
        if (!_tapTextViewGesture) {
            _tapTextViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundTap)];
            _tapTextViewGesture.cancelsTouchesInView = NO;
            _tapTextViewGesture.delegate = self;
            [self addGestureRecognizer:_tapTextViewGesture];
        }
    }
}

- (void)onBackgroundTap
{
    [self endEditing:YES];
}

@end

BYLinearScrollView* makeLinearScrollView(UIViewController* vc)
{
    BYLinearScrollView* bodyView = [[BYLinearScrollView alloc] initWithFrame:BYRectMake(0, 0, vc.view.width, vc.view.height)];
    bodyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return bodyView;
}
