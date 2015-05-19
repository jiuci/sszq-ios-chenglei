//
//  BYLinearView.m
//  IBY
//
//  Created by panShiyu on 14/12/5.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYLinearView.h"
#import "BYLinearItem.h"

@implementation BYLinearView

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
}

#pragma mark -

- (void)resetFrameSize
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self layoutOffset]);
}

- (float)layoutOffset
{
    float curOffset = 0;
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
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _items = [[NSMutableArray alloc] init];
    _autoAdjustFrameSize = NO;
    self.autoresizesSubviews = NO;
}

@end
