//
//  BYMessage.h
//  IBY
//
//  Created by St on 14-10-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseDomain.h"

@interface BYMessage : BYBaseDomain

@property (nonatomic, assign) long messageId;
@property (nonatomic, copy) NSString* messageContent;
@property (nonatomic, assign) int messageType;
@property (nonatomic, copy) NSString* messageTitle;
@property (nonatomic, copy) NSString* msgTime;
@property (nonatomic, assign) BOOL hasRead;

@end
