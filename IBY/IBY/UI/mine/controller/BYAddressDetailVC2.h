//
//  BYAddressDetailVC2.h
//  IBY
//
//  Created by panshiyu on 15/1/5.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"
#import "BYAddressDetailVC.h"
#import "BYOrderService.h"
@class BYAddress;

@interface BYAddressDetailVC2 : BYBaseVC
@property (nonatomic, assign) id<BYAddressDetailDelegate> delegate;
@property (nonatomic, strong) BYAddress* address;
@property (nonatomic, assign) BOOL isEditMode;
@property (nonatomic, weak) BYOrderService* orderService;

@property (nonatomic, weak) UIViewController* popToVC;
@end
