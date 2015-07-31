//
//  BYAddressVC.h
//  IBY
//
//  Created by St on 14-10-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYOrderService.h"
@class BYAddress;
typedef void (^BYAddressSelectBlock)(BYAddress* address);

@interface BYAddressManagelistVC : BYBaseVC
@property (nonatomic, assign) BOOL inPayProcessing;
@property (nonatomic, weak) BYOrderService* orderService;
@property (nonatomic, copy) BYAddressSelectBlock selectBlock;
@property (nonatomic, weak) UIViewController* confirmOrderVC;
- (IBAction)addNewAddress:(id)sender;
@end
