//
//  BYPushCenter.h
//  IBY
//
//  Created by panshiyu on 15/2/15.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYPushCenter : NSObject

+ (instancetype)sharedPushCenter;

- (void)handleRemoteInfoWithApplication:(UIApplication*)application userinfo:(NSDictionary*)userInfo;

@end
