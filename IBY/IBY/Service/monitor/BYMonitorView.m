//
//  BYMonitorView.m
//  IBY
//
//  Created by panshiyu on 14-10-15.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYMonitorView.h"
#import "BYNetwork.h"
#import "BYMutiSwitch.h"

@implementation BYMonitorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BYColorBG;

        UIButton* (^makeTmpBtn)(NSString * title) = ^(NSString* title) {
            UIButton *btn = [[UIButton alloc] initWithFrame:BYRectMake(0, 0, 320, 30)];
            [btn setBackgroundImage:[[UIImage imageNamed:@"icon_btn_default.9"] resizableImage] forState:UIControlStateNormal];
            btn.titleLabel.font = Font(15);
            btn.tintColor = [UIColor blackColor];
            [btn setTitle:title forState:UIControlStateNormal];
            return btn;
        };

        UILabel* (^makeTmpLabel)(NSString * title) = ^(NSString* title) {
            UILabel *label = [UILabel labelWithFrame:CGRectMake(0, 0, 320, 20) font:Font(15) andTextColor:BYColor333];
            label.text = title;
            return label;
        };

        UIButton* hideBtn = makeTmpBtn(@"隐藏");
        [hideBtn bk_addEventHandler:^(id sender) {
            [self removeFromSuperview];
        } forControlEvents:UIControlEventTouchUpInside];
        [self by_addSubview:hideBtn paddingTop:40];

        UILabel* netLabel = makeTmpLabel(@"API切换");
        [self by_addSubview:netLabel paddingTop:10];

        NSArray* netNames = @[
            @"开发",
            @"测试",
            @"预发布",
            @"线上"
        ];
        BYMutiSwitch* mutiSwitch = [[BYMutiSwitch alloc] initWithFrame:BYRectMake(0, 0, 320, 40)];

        [netNames enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL* stop) {
            BYNetMode mode = (BYNetMode)idx;
            [mutiSwitch addButtonWithTitle:obj handler:^(id sender) {
                [BYNetwork switchToMode:mode];
            }];
        }];

        [mutiSwitch setSelectedAtIndex:[BYNetwork sharedNetwork].currentMode];
        [self by_addSubview:mutiSwitch paddingTop:20];
    }
    return self;
}

@end
