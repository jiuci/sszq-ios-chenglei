//
//  BYEditService.h
//  IBY
//
//  Created by St on 14-11-3.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYEditService : NSObject

- (void)fetchDesignDataWithDesignId:(NSString*)designId finish:(void (^)(NSDictionary* data, BYError* error))finished;

@end
