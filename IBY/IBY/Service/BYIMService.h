//
//  BYIMPassWordService.h
//  IBY
//
//  Created by forbertl on 15/10/13.
//  Copyright © 2015年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYIMService : BYBaseService
@property (nonatomic,strong)NSString * token;
- (void)loadpassword:(void (^)(NSString * password, BYError* error))finished;

- (void)getTargetStatus:(NSString *)user finish:(void (^)(BOOL online, BYError* error))finished;


@end
