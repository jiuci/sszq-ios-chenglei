//
//  BYBusinessService.m
//  IBY
//
//  Created by panshiyu on 14/11/10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYCommentsService.h"

@implementation BYCommentsService

- (void)loadCommentsWithProductId:(int)productId
                         pageSize:(int)pageSize
                           pageNo:(int)pageNo
                           finish:(void (^)(NSDictionary* data, BYError* error))finished
{
    NSDictionary* params = @{
        @"productId" : @(productId),
        @"pageSize" : @(pageSize),
        @"pageNo" : @(pageNo)
    };
    [BYNetwork get:@"product/comment/CommentShow" params:params finish:^(NSDictionary* data, BYError* error) {
        
        if (data) {
            
            finished(data,nil);
        }else{
            
            finished(nil,error);
        }
    }];
}

//发表评论
- (void)publishCommentWithOrderId:(NSString*)orderID
                       supplierID:(int)supplierID
                    commentRating:(NSString*)commentRating
                    qualityRating:(NSString*)qualityRating
                   attituteRating:(NSString*)attituteRating
                          comment:(NSString*)comment
                           finish:(void (^)(BOOL success, BYError* error))finished
{
    NSDictionary* params = @{
        @"orderId" : orderID,
        @"supplierId" : @(supplierID),
        @"first" : commentRating,
        @"second" : qualityRating,
        @"third" : @"0",
        @"fourth" : attituteRating,
        @"commentList" : comment
    };

    NSString* url = @"CustomerOrder/SaveOrderComment";
    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        
        if (error) {
            finished(NO,error);
            return ;
        }
        finished(YES,nil);
    }];
}
@end
