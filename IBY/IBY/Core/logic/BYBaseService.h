//
//  BYBaseService.h
//  IBY
//
//  Created by pan Shiyu on 14-8-26.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BYNetwork.h"

@interface BYBaseService : NSObject

- (void)setMemoryCache:(id)cache forKey:(NSString*)key;
- (id)memoryCacheForKey:(NSString*)key;

- (void)setCache:(id)cache forKey:(NSString*)key;
- (id)cacheForKey:(NSString*)key;

@end

@protocol BYListService <NSObject>

@optional
@property (nonatomic, assign, readonly) BOOL isPageEnabled;
@property (nonatomic, assign) int limit;
@property (nonatomic, readonly) int pageIndex;//页码。以后会用offset(偏移量)来替代
@property (nonatomic, readonly) int total;
@property (nonatomic, assign, readonly) BOOL hasMore;

- (void)resetDataList;

@end