//
//  BYBasePopoverView.m
//  IBY
//
//  Created by panshiyu on 14-10-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBasePopoverView.h"

@implementation BYBasePopoverView

+ (instancetype)createPopoverView
{
    UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
    return [[self alloc] initWithFrame:keyWindow.bounds];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);

        UIButton* bgButton = [[UIButton alloc] initWithFrame:BYRectMake(0, 0, self.width, self.height)];
        bgButton.backgroundColor = [UIColor clearColor];
        [bgButton bk_addEventHandler:^(id sender) {
                    if (_autoHideWhenTapBg == YES) {
                        [self hide];
                    }
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];

        _autoHideWhenTapBg = YES;
    }
    return self;
}

- (void)showInView:(UIView*)view
{
    self.alpha = 0;

    if (view) {
        [view addSubview:self];
    }
    else {
        UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
        [keyWindow addSubview:self];
    }

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished){

    }];
}

- (void)hide
{
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        CFRunLoopStop([runLoop getCFRunLoop]);
    }];
    [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
//{
//    return !([touch.view isKindOfClass:[UIControl class]]);
//}

@end
