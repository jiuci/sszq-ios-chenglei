//
//  BYCommonWebVC.h
//  IBY
//
//  Created by panshiyu on 15/3/30.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"
#import "BYWebView.h"
#import "BYMutiSwitch.h"

@interface BYCommonWebVC : BYBaseVC
@property (nonatomic,strong)BYMutiSwitch *mutiSwitch;
@property (nonatomic, strong) BYWebView* webView;

@property (nonatomic,assign)BOOL showTabbar;

- (void)onWeixinAuth:(NSString*)code;
- (void)onAppShake;
- (void)onSelectGlasses:(int)designId;

@end

@interface BYBarButton : UIButton

+(instancetype)barBtnWithIcon:(NSString*)normalIcon hlIcon:(NSString*)hlIcon title:(NSString*)title;

@end

