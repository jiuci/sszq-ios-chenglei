//
//  BYBookTurnInfo.h
//  IBY
//
//  Created by panshiyu on 15/3/11.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseDomain.h"

@interface BYBookTurnInfo : BYBaseDomain

@property (nonatomic, assign) int bookedNum;
@property (nonatomic, strong) NSDate* currentServerTime;
@property (nonatomic, strong) NSDate* saleEndtime;
@property (nonatomic, strong) NSDate* saleStartTime;
@property (nonatomic, assign) int turnId;

@property (nonatomic, assign) BOOL isNext; //当前是否是下一轮，在销售期就是下一轮

- (id)initWithDict:(NSDictionary*)data;

@end
