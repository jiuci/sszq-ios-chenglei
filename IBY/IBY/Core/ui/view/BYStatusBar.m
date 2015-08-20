//
//  BYMutiSwitch.h
//  IBY
//
//  Created by panshiyu on 14-10-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYStatusBar.h"

@implementation BYStatusBar

@synthesize button = _button;
@synthesize messageLabel = _messageLabel;
@synthesize userInfo = _userInfo;

static BYStatusBar *instance = nil;

- (UIButton *)button {
    if (nil == _button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        _button.backgroundColor = [UIColor clearColor];
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return _button;
}
- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.width, self.height)];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textAlignment = NSTextAlignmentRight;
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = BoldFont(12);
        [self addSubview:_messageLabel];
    }
    return _messageLabel;
}
- (void)buttonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:BYStatusBarTapNotification object:_userInfo];
}

- (id)init {
    CGRect f=[[UIScreen mainScreen] bounds];    
    CGRect s=[[UIApplication sharedApplication] statusBarFrame];
    self = [super initWithFrame:CGRectMake(0, 0, f.size.width, s.size.height)];
    if (self != nil) {
        self.windowLevel = UIWindowLevelStatusBar;
        self.backgroundColor = [UIColor blackColor];
        self.hidden = NO;
        self.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
        }];
        self.messageLabel.alpha = 0;
    }
    
    return self;
}
+ (void)disappear:(BOOL)animated {
    if (instance != nil) {
        if (animated) {
            [UIView animateWithDuration:1 animations:^{
                instance.alpha = 0;
            } completion:^(BOOL finished) {
                instance = nil;
            }];
        }else {
            instance = nil;
        }
    }
}
+ (void)disappearAnimate {
    [self disappear:YES];
}
+ (BYStatusBar *)sharedStatusBar {
    if (instance == nil) {
        instance = [[BYStatusBar alloc] init];
    }
    return instance;
}

+ (void)showStatusBarMessage:(NSString *)message disappearAfter:(NSTimeInterval)second {
    
    BYStatusBar *statusBar = [BYStatusBar sharedStatusBar];
    
    if (message) {
        if (statusBar.messageLabel.alpha == 1) {//正在显示是，只换上面的文字
            statusBar.messageLabel.text = message;
            [self cancelPreviousPerformRequestsWithTarget:self selector:@selector(disappearAnimate) object:nil];
            [self performSelector:@selector(disappearAnimate) withObject:nil afterDelay:second+1];
        }else {
            [UIView animateWithDuration:0.5 animations:^{
                statusBar.messageLabel.alpha = 1;
                statusBar.messageLabel.text = message;
            } completion:^(BOOL finished) {
                if (second > 0) {
                    [self performSelector:@selector(disappearAnimate) withObject:nil afterDelay:second];
                }
            }];
        }
        
    }else {
        if (second > 0) {
            [self performSelector:@selector(disappearAnimate) withObject:nil afterDelay:second];
        }
    }
}


+ (void)showStatusBarMessage:(NSString *)message disappearAfter:(NSTimeInterval)second userInfo:(id)userInfo {
    BYStatusBar *statusBar = [BYStatusBar sharedStatusBar];
    statusBar.userInfo = userInfo;
    [self showStatusBarMessage:message disappearAfter:second];
    [[self sharedStatusBar] button];
}
@end
