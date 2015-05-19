//
//  BYListPopoverView.h
//  IBY
//
//  Created by panshiyu on 15/1/22.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^dismissBlock)();
@interface BYListPopoverView : UIButton <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) dismissBlock dismissBlk;
@property (nonatomic, readonly) BOOL isShown;

@property (nonatomic, strong) UIView* contentView; //包含两个tableview
@property (nonatomic, strong) UIView* listContainerView; //包含两个tableview
@property (nonatomic, strong) UITableView* mainListView; //左边的list
@property (nonatomic, strong) UITableView* subListView; //右边的list

@property (nonatomic, strong) NSArray* mainDataArray; //左边list的data
@property (nonatomic, strong) NSArray* subDataArray; //右边list的data

@property (nonatomic, copy) void (^selectedBlock)(id selectedInfo);

- (void)showInView:(UIView*)superView withTopPadding:(CGFloat)top;
- (void)cancel;
- (void)resetContentFrame;
- (void)hide;

@end
