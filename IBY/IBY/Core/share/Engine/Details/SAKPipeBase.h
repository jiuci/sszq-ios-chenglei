//
//  BaseShareEngine.h
//  SAKShareKit
//
//  Created by psy on 14-1-2.
//  Copyright (c) 2014年 psy. All rights reserved.
//

#import "SAKShareProtocol.h"
#import "SAKShareConfig.h"

@interface SAKPipeBase : NSObject<SAKShareMediaProtocol>

@property (nonatomic, copy) SAKDidShareBlock finishBlock;

- (void)getPath:(NSString *)path
         params:(NSDictionary *)params
         finish:(void (^)(NSDictionary *result, NSError *error))finish;

- (void)postPath:(NSString *)path
          params:(NSDictionary *)params
          finish:(void (^)(NSDictionary *result, NSError *error))finish;

@end
