//
//  BYLoginService.h
//  IBY
//
//  Created by panshiyu on 15/6/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYLoginService : BYBaseService
//用户未注册会返回空的user与error 208103
- (void)loginByUser:(NSString*)user
                pwd:(NSString*)pwd
             finish:(void (^)(BYUser* user, BYError* error))finished;

@end
