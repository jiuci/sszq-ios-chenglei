//
//  BYComment.m
//  IBY
//
//  Created by panshiyu on 14/11/11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYComment.h"

@implementation BYComment
- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{
        @"comment" : @"_comment",
        @"comment_id" : @"_comment_id",
        @"rating" : @"_rating",
        @"reply_comment" : @"reply_comment",
        @"create_time" : @"_create_time",
        @"avatar_url" : @"_avatar_url",
        @"nickname" : @"_nickname",
        @"sizdeName" : @"_size_name"
    };
}
@end
