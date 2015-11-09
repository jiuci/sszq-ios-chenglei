/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "MessageModel.h"
#import "BYAppCenter.h"
@implementation MessageModel

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        //code
    }
    
    return self;
}

- (void)dealloc{
    
}

- (NSString *)messageId
{
    return _message.messageId;
}

- (MessageDeliveryState)status
{
    return _message.deliveryState;
}

- (NSURL *)headImageURL
{
    if (self.isSender) {
        if (![BYAppCenter sharedAppCenter].user.avatar || [[BYAppCenter sharedAppCenter].user.avatar isEqual:[NSNull null]]) {
            return nil;
        }
        NSURL * url = [NSURL URLWithString:[BYAppCenter sharedAppCenter].user.avatar];
        return url;
    }
    return _headImageURL;
}
@end
