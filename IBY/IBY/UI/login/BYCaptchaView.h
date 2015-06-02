//
//  BYLoginCaptchaView.h
//  IBY
//
//  Created by panshiyu on 14/12/23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYCaptchaView : UIView

+ (instancetype)captchaView;

//错误已经在BYLoginCaptchaView处理并显示了
//如果将来有需要放出来，请修改此方法，并把Block改成 finishBLock，对应的参数也需要加上了
- (void)valueCheckWithSuccessBlock:(void (^)())block;

- (void)refreshCaptchaImage;

@end
