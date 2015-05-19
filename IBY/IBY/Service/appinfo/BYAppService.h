//
//  BYAppInfo.h
//  IBY
//
//  Created by panshiyu on 14-10-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@class BYVersionInfo;
@interface BYAppService : BYBaseService

- (void)checkAppNeedUpdate:(void (^)(BYVersionInfo* versionInfo, BYError* error))finished;

- (void)uploadToken:(NSString*)token finished:(void (^)(BOOL success, BYError* error))finished;

@end

@interface BYVersionInfo : NSObject

@property (nonatomic, assign) BOOL forceUpdate;
@property (nonatomic, assign) BOOL hasNewVersion;

@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* version;
@property (nonatomic, copy) NSString* info;

@end
