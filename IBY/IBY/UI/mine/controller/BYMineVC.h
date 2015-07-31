//
//  BYMine.h
//  IBY
//
//  Created by coco on 14-9-18.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BYMutiSwitch.h"

@interface BYMineVC : BYBaseVC
typedef void (^BYMineExitBlock)(NSString* jumpUrlString);
@property (nonatomic,strong)BYMutiSwitch *mutiSwitch;
@property (nonatomic, copy) BYMineExitBlock exitBlk;
+ (instancetype)sharedMineVC;
- (void)onToPayOrders;

- (void)onInProcessOrders;

- (void)onToDeliverConfirmOrders;

- (void)onAvatar;

@end

BYNavVC* makeMinenav(BYMineExitBlock blk);