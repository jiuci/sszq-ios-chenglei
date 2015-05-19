//
//  BYBaseService.m
//  IBY
//
//  Created by pan Shiyu on 14-8-26.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYBaseService ()
@property (nonatomic, strong) NSMutableDictionary* cachemap;
@end

@implementation BYBaseService

- (void)setCache:(id)cache forKey:(NSString*)key
{
    if (key && cache) {
        [[TMCache PermanentCache] setObject:cache forKey:key];
    }
}

- (id)cacheForKey:(NSString*)key
{
    if (!key) {
        return nil;
    }
    return [[TMCache PermanentCache] objectForKey:key];
}

- (id)init
{
    self = [super init];
    if (self) {
        //初始化一下分页数据
        if ([self respondsToSelector:@selector(resetDataList)]) {
            [self performSelector:@selector(resetDataList) withObject:nil];
        }
    }
    return self;
}

- (NSMutableDictionary*)cachemap
{
    if (!_cachemap) {
        _cachemap = [NSMutableDictionary dictionary];
    }
    return _cachemap;
}

- (void)setMemoryCache:(id)cache forKey:(NSString*)key
{
    if (cache && key) {
        self.cachemap[key] = cache;
    }
}
- (id)memoryCacheForKey:(NSString*)key
{
    if (key) {
        return self.cachemap[key];
    }
    return nil;
}

@end
