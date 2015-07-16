//
//  BYLoginService.h
//  IBY
//
//  Created by panshiyu on 15/6/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface BYLoginService : BYBaseService<TencentSessionDelegate>

@property (nonatomic, strong)TencentOAuth * oAuth;
//用户未注册会返回空的user与error 208103
- (void)loginByUser:(NSString*)user
                pwd:(NSString*)pwd
             finish:(void (^)(BYUser* user, BYError* error))finished;
- (void)WXlogin;
- (void)QQlogin;
- (void)loginWithWXcode:(NSString*)code finish:(void (^)(BYUser* user, BYError* error))finished;
- (BOOL)canUseWXlogin;
- (BOOL)canUseQQlogin;
@end
