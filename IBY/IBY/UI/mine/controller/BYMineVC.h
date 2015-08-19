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
//typedef void (^BYJumpWebBlock)(NSString* jumpUrlString);
@property (nonatomic,strong)BYMutiSwitch *mutiSwitch;
//@property (nonatomic, copy) BYJumpWebBlock exitBlk;
@property (nonatomic, strong)UIImageView* hasNewMessage;
+ (instancetype)sharedMineVC;
- (void)onToPayOrders;

- (void)onInProcessOrders;

- (void)onToDeliverConfirmOrders;

//- (void)onAvatar;

- (void)onInRefundOrders;

- (void)loginAction;
@end

//BYNavVC* makeMinenav(BYJumpWebBlock blk);