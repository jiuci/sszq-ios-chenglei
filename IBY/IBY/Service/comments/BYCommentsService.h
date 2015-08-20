//
//  BYBusinessService.h
//  IBY
//
//  Created by panshiyu on 14/11/10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYCommentsService : BYBaseService

///@property (nonatomic,assign)int productId;
@property (nonatomic,assign)int pageSize;
@property (nonatomic,assign)int pageNo;

- (void)loadCommentsWithProductId:(int)productId
                        pageSize:(int)pageSize
                          pageNo:(int)pageNo
                          finish:(void (^)(NSDictionary *data, BYError* error))finished;


//发表评论
- (void)publishCommentWithOrderId:(NSString*)orderID
                       supplierID:(int)supplierID
                    commentRating:(NSString*)commentRating
                    qualityRating:(NSString*)qualityRating
                   attituteRating:(NSString*)attituteRating
                          comment:(NSString*)comment
                           finish:(void (^)(BOOL success, BYError* error))finished;
;
@end
