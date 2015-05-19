//
//  BYFeedbackService.m
//  IBY
//
//  Created by panshiyu on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYFeedbackService.h"
@implementation BYFeedbackService

- (void)uploadFeedbackByContent:(NSString*)content
                         mobile:(NSString*)mobile
                         finish:(void (^)(BOOL success, BYError* error))finished
{
    NSDictionary* params = @{
        @"phone" : mobile,
        @"message" : content //[content urlEncodeUsingEncoding:NSUTF8StringEncoding]
    };

    [BYNetwork get:@"app/uploadfeedback" params:params finish:^(NSDictionary* data, BYError* error) {
//        if (error) {
//            finished(NO,error);
//        }else{
//            finished(YES,nil);
//        }
        finished(YES,nil);
    }];
}

@end
