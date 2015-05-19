//
//  BYPopMenu.h
//  IBY
//
//  Created by panShiyu on 14/12/4.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYPopMenu : UIView

+ (instancetype)createPopoverView;

- (void)hide;
- (void)show;

- (void)addBtnWithTitle:(NSString*)title
                   icon:(NSString*)icon
                hasLine:(BOOL)hasLine
                handler:(void (^)(id sender))handler;

@end
