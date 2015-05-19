//
//  BYMessageService.h
//  IBY
//
//  Created by St on 14-10-21.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYMessageService : BYBaseService <BYListService>

@property (nonatomic, assign, readonly) BOOL isPageEnabled;
@property (nonatomic, assign) int limit;
@property (nonatomic, readonly) int pageIndex;
@property (nonatomic, readonly) int total;
@property (nonatomic, assign, readonly) BOOL hasMore;
- (void)resetDataList;

- (void)fetchMessageListByType:(NSNumber*)messageType
                        finish:(void (^)(NSArray* messageList, BYError* error))finished;

- (void)modifyReadStatus:(NSArray*)messageDatas
                  finish:(void (^)(BOOL success, BYError* error))finished;

@end
