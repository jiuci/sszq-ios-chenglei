//
//  BYFeedbackService.h
//  IBY
//
//  Created by panshiyu on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

@interface BYFeedbackService : BYBaseService

- (void)uploadFeedbackByContent:(NSString*)content
                       mobile:(NSString*)mobile
                       finish:(void (^)(BOOL success, BYError* error))finished;

@end
