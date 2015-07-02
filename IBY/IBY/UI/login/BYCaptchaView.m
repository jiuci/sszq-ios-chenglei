//
//  BYLoginCaptchaView.m
//  IBY
//
//  Created by panshiyu on 14/12/23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYCaptchaView.h"
#import "BYCaptchaService.h"
#import "Base64Helper.h"

@interface BYCaptchaView ()
@property (strong, nonatomic) UIImageView* captchaImgView;
@property (strong, nonatomic) UITextField* captchaFileld;
@property (strong, nonatomic) UIImageView* bgInput;
@property (strong, nonatomic) UIActivityIndicatorView* indicatorView;

@end

@implementation BYCaptchaView {
    BYCaptchaService* _service;
}

+ (instancetype)captchaView
{
    BYCaptchaView* instance = [[BYCaptchaView alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, 52)];
    return instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat captchaWidth = 90;
        CGFloat refreshWidth = 24;
        CGFloat top = 12;
        CGFloat height = self.height - 12;
        CGFloat leftWidth = self.width - 38 * 2 - captchaWidth - refreshWidth - 12;

        UIImageView* bgInput = [[UIImageView alloc] initWithFrame:BYRectMake(38, top, leftWidth, height)];
        bgInput.image = [[UIImage imageNamed:@"bg_inputbox"] resizableImage];
        bgInput.highlightedImage = [[UIImage imageNamed:@"bg_inputbox_on"] resizableImage];
        [self addSubview:bgInput];
        _bgInput = bgInput;

        _captchaFileld = [[UITextField alloc] initWithFrame:BYRectMake(50, top, bgInput.width - 12 - 12, height)];
        _captchaFileld.placeholder = @"请输入验证码";
        _captchaFileld.keyboardType = UIKeyboardTypeNumberPad;
        _captchaFileld.clearButtonMode = UITextFieldViewModeWhileEditing;
        _captchaFileld.font = Font(14);
        [self addSubview:_captchaFileld];

        UIImageView* refreshBgView = [[UIImageView alloc] initWithFrame:BYRectMake(0, top, refreshWidth, height)];
        refreshBgView.image = [[UIImage imageNamed:@"bg_captcha_refresh"] resizableImage];
        refreshBgView.right = self.width - 38;
        [self addSubview:refreshBgView];

        UIImageView* refreshIconView = [[UIImageView alloc] initWithFrame:BYRectMake(0, 0, 16, 16)];
        refreshIconView.image = [UIImage imageNamed:@"icon_refresh"];
        refreshIconView.center = CGPointMake(refreshBgView.width / 2, refreshBgView.height / 2);
        [refreshBgView addSubview:refreshIconView];

        _captchaImgView = [[UIImageView alloc] initWithFrame:BYRectMake(0, top, captchaWidth, height)];
        _captchaImgView.backgroundColor = [UIColor lightGrayColor];
        _captchaImgView.right = refreshBgView.left;
        [self addSubview:_captchaImgView];

        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = CGPointMake(_captchaImgView.width / 2, _captchaImgView.height / 2);
        _indicatorView.hidden = YES;
        [_captchaImgView addSubview:_indicatorView];

        UIButton* refreshBtn = [[UIButton alloc] initWithFrame:BYRectMake(0, top, captchaWidth + refreshWidth, height)];
        refreshBtn.right = refreshBgView.right;
        [refreshBtn addTarget:self action:@selector(onRefreshCaptcha:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:refreshBtn];

        //--
        _service = [[BYCaptchaService alloc] init];
        __weak BYCaptchaView* wself = self;
        [_captchaFileld setBk_didBeginEditingBlock:^(UITextField* txtField) {
            wself.bgInput.highlighted = YES;
        }];

        [_captchaFileld setBk_didEndEditingBlock:^(UITextField* txtField) {
            wself.bgInput.highlighted = NO;
        }];
    }
    return self;
}

- (void)onRefreshCaptcha:(id)sender
{
    [self refreshCaptchaImage];
}

- (void)refreshCaptchaImage
{
    _captchaImgView.image = nil;
    _indicatorView.hidden = NO;
    [_indicatorView startAnimating];
    [_service fetchImageVerifyCode:^(UIImage* image, BYError* error) {
        [_indicatorView stopAnimating];
        _indicatorView.hidden = YES;

        if (error) {
            [MBProgressHUD topShowTmpMessage:@"获取验证图片出错"];
            return;
        }

        self.captchaImgView.image = image;
    }];
}

- (void)valueCheckWithSuccessBlock:(void (^)())block
{
    if (self.captchaFileld.text.length < 2) {
        [MBProgressHUD topShowTmpMessage:@"请输入图片验证码"];
        [self.captchaFileld becomeFirstResponder];
        return;
    }

    [_service checkImageVerifyCode:self.captchaFileld.text
                            finish:^(BOOL success, BYError* error) {
                                if (!success || error) {
                                    [MBProgressHUD showError:@"验证码错误"];
                                    [self.captchaFileld becomeFirstResponder];
                                    return;
                                }
                                //[self refreshCaptchaImage];
                                if (block) {
                                    block();
                                }
                            }];
}

@end
