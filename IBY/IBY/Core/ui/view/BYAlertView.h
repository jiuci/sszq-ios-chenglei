//
//  BYAlertView.h
//  IBY
//
//  Created by panshiyu on 15/3/11.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BYAlertBlock)();

@interface BYAlertView : UIAlertView <UIAlertViewDelegate>

+ (instancetype)alertViewWithTitle:(NSString*)titile;
+ (instancetype)alertViewWithTitle:(NSString*)titile detail:(NSString*)detail;
+ (instancetype)alertViewWithTitle:(NSString*)titile detail:(NSString*)detail cancelTips:(NSString*)cancelTips;

/**
 * 给AlertView中对应title的button添加相应的响应事件。
 * @params target, 事件的接受者。
 * @params selector, 响应事件的名称。
 * @params title, 对应button的名称。
 */

//- (void)addTarget:(id)target action:(SEL)selector forTitle:(NSString*)title;
- (void)setTitle:(NSString*)title withBlock:(BYAlertBlock)block;

@end

#define BYAlert(s)                                                                                                                            \
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:s delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil]; \
    [alert show];
#define BYAlertDetail(t, s)                                                                                                                 \
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:t message:s delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil]; \
    [alert show];
