//
//  BYMessage.m
//  IBY
//
//  Created by St on 14-10-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYMessage.h"

@implementation BYMessage


+ (NSDictionary*)JSONKeyPathsByPropertyKey
{
    return @{
        @"messageId" : @"id",
        @"messageType" : @"messageType",
        @"messageTitle" : @"messageTitle",
        @"msgTime" : @"message_time",
        @"hasRead" : @"readFlag"
    };
}

+ (NSValueTransformer*)messageContentJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithBlock:^id(NSString *msgContent) {
        return [msgContent stripHtml];
    }];
//    return  [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{@""}];
//    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[DVAnswer class]];
}

@end
