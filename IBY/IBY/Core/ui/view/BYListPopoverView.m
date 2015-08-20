//
//  BYListPopoverView.m
//  IBY
//
//  Created by panshiyu on 15/1/22.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYListPopoverView.h"

@implementation BYListPopoverView

#pragma mark - 基础方法

- (void)cancel
{
    if (_selectedBlock) {
        _selectedBlock(nil);
    }

    [self removeFromSuperview];
}

- (void)showInView:(UIView*)superView withTopPadding:(CGFloat)top
{
    _isShown = YES;

    CGFloat aimHeight = self.contentView.height;
    self.contentView.height = 0;

    self.top = top;

    [superView addSubview:self];

    [UIView animateWithDuration:0.3
        delay:0
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{
             self.contentView.height =aimHeight;
        }
        completion:^(BOOL finished){

        }];
}

- (void)hide
{
    _isShown = NO;
    if (_dismissBlk) {
        _dismissBlk();
    }
    [self removeFromSuperview];
}

- (void)resetContentFrame
{
    //被子类重写，需要重置一些view的frame的时候使用
}

- (void)dealloc
{
    _mainListView.delegate = nil;
    _mainListView.dataSource = nil;
    _subListView.delegate = nil;
    _subListView.dataSource = nil;
}

- (id)init
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    if (self) {
        [self initUI];
        [self addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self resetContentFrame];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);

    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 263)];
    _contentView.clipsToBounds = YES;
    _contentView.backgroundColor = BYColorClear;
    [self addSubview:_contentView];

    _listContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 263)];
    _listContainerView.backgroundColor = BYColorBG;
    [self.contentView addSubview:_listContainerView];

    _subListView = [UITableView tableViewWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, _listContainerView.height) delegete:self];
    _subListView.showsVerticalScrollIndicator = NO;
    _subListView.showsHorizontalScrollIndicator = NO;
    _subListView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.listContainerView addSubview:_subListView];

    _mainListView = [UITableView tableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, _listContainerView.height) delegete:self];
    _mainListView.showsVerticalScrollIndicator = NO;
    _mainListView.showsHorizontalScrollIndicator = NO;
    _mainListView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.listContainerView addSubview:_mainListView];
}

#pragma mark -

#pragma mark - UITableViewDataSource and UITableViewDelegate, 需要重写的部分

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _mainListView) {
        return _mainDataArray.count;
    }
    else {
        return _subDataArray.count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //初始化cell，需要重写
    return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //选中cell
}

@end
