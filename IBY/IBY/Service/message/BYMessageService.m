//
//  BYMessageService.m
//  IBY
//
//  Created by St on 14-10-21.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYMessageService.h"
#import "BYMessage.h"
#import "MJExtension.h"

@implementation BYMessageService

- (void)resetDataList
{
    _isPageEnabled = YES;
    _limit = 10;
    _pageIndex = 1;
    _total = 0;
    _hasMore = YES;
}

- (void)fetchMessageListByType:(NSNumber*)messageType
                        finish:(void (^)(NSArray* messageList, BYError* error))finished
{
    NSString* url = @"/message/getmessage";
    NSDictionary* param = @{
        @"messageType" : messageType,
        @"pageIndex" : @(_pageIndex),
        @"pageSize" : @(_limit)
    };

    [BYNetwork get:url params:param finish:^(NSDictionary* data, BYError* error) {
        if (error || !data[@"entitys"]) {
            finished(nil,error);
            return ;
        }
        
        NSArray *msglist = [BYMessage mtlObjectsWithKeyValueslist:data[@"entitys"]];
        if (msglist.count == 0) {
            _hasMore = NO;
        }else if(msglist.count == _limit){
            _hasMore = YES;
            _pageIndex ++;
        }else{
            _hasMore = NO;
            _pageIndex ++;
        }
        
        finished(msglist,nil);
    }];
}

- (void)modifyReadStatus:(NSArray*)messageDatas
                  finish:(void (^)(BOOL success, BYError* error))finished
{
    if (messageDatas.count < 1) {
        BYLog(@"can not modifyReadStatusByIds messageDatas.count < 1");
        return;
    }
    NSString* url = @"/customermessage/updatemessage";
    NSArray* unitlist = [messageDatas bk_map:^id(BYMessage* obj) {
        return [NSString stringWithFormat:@"%d|%ld",obj.messageType,obj.messageId];
    }];
    NSString* unitlistStr = [unitlist componentsJoinedByString:@","];

    NSDictionary* param = @{
        @"username" : @([BYAppCenter sharedAppCenter].user.userID),
        @"typeAndId" : unitlistStr
    };

    [BYNetwork post:url params:param finish:^(NSDictionary* data, BYError* error) {
            if (error) {
                finished(NO,error);
                return ;
            }
            finished(YES,nil);
    }];
}

@end
