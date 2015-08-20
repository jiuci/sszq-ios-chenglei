//
//  BYPopMenu.m
//  IBY
//
//  Created by panShiyu on 14/12/4.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYPopMenu.h"

#define kCellHeight 40
#define kCellWidth 128

@interface BYPopMenu ()
@property (nonatomic, strong) UIButton* cover;
@property (nonatomic, strong) UIImageView* container;
@end

@implementation BYPopMenu

+ (instancetype)createPopoverView
{
    UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
    return [[self alloc] initWithFrame:keyWindow.bounds];
}

- (void)addBtnWithTitle:(NSString*)title
                   icon:(NSString*)icon
                hasLine:(BOOL)hasLine
                handler:(void (^)(id sender))handler
{
    float curTop = _container.height;

    UIImageView* iconView = [[UIImageView alloc] initWithFrame:BYRectMake(0, curTop, 16, 16)];
    iconView.center = CGPointMake(29, curTop + kCellHeight / 2);
    iconView.image = [UIImage imageNamed:icon];
    [_container addSubview:iconView];

    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(52, curTop, 70, kCellHeight)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:BYColor666 forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleLabel.font = Font(14);
    [btn bk_addEventHandler:^(id sender) {
        [self dismiss];
        handler(sender);
    } forControlEvents:UIControlEventTouchUpInside];

    btn.backgroundColor = [UIColor clearColor];
    [_container addSubview:btn];

    if (hasLine) {
        UIImageView* line = makeImgView(BYRectMake(0, curTop + kCellHeight, kCellWidth, 1), @"line_common");
        [_container addSubview:line];
    }

    _container.height = curTop + kCellHeight;
}

- (void)show
{
    self.alpha = 0;

    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];

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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);

        UIButton* cover = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
        [cover addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cover];
        self.cover = cover;

        _container = makeImgView(BYRectMake(0, 64, kCellWidth, 0), @"bg_topmenu");
        _container.right = SCREEN_WIDTH - 12;
        _container.userInteractionEnabled = YES;
        [self addSubview:_container];
    }
    return self;
}

- (void)dismiss
{
    [self removeFromSuperview];
}
@end
