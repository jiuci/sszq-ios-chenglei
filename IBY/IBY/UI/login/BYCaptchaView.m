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
@property (weak, nonatomic) IBOutlet UIImageView* captchaImgView;
@end

@implementation BYCaptchaView {
    __weak IBOutlet UITextField* captchaFileld;
    BYCaptchaService* _service;
}

+ (instancetype)captchaView
{
    BYCaptchaView* instance = [[[NSBundle mainBundle] loadNibNamed:@"BYCaptchaView" owner:nil options:nil] lastObject];
    instance.frame = CGRectMake(0, 0, SCREEN_WIDTH, 59);
    return instance;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _service = [[BYCaptchaService alloc] init];
}

- (IBAction)onRefreshCaptcha:(id)sender
{
    [self refreshCaptchaImage];
}

- (void)refreshCaptchaImage
{
    [_service fetchImageVerifyCode:^(UIImage* image, BYError* error) {
        if(error){
            [MBProgressHUD topShowTmpMessage:@"获取验证图片出错。"];
            return ;
        }

        self.captchaImgView.image = image;
    }];
}

- (void)valueCheckWithSuccessBlock:(void (^)())block
{
    if (captchaFileld.text.length < 2) {
        [MBProgressHUD topShowTmpMessage:@"请输入图片验证码"];
        return;
    }

    [_service checkImageVerifyCode:captchaFileld.text finish:^(BOOL success, BYError* error) {
        if (!success|| error) {
            [MBProgressHUD showError:@"验证码错误"];
            return ;
        }
        //[self refreshCaptchaImage];
        if (block) {
            block();
        }
    }];
}

@end
