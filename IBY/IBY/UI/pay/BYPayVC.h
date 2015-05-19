//
//  BYPayVC.h
//  IBY
//
//  Created by St on 14/11/27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"
#import "BYBaseCell.h"

@interface BYPayVC : BYBaseVC

- (id)initWithOrderId:(NSString*)orderId;

@end

@interface BYPayTypeCell : BYBaseCell

+ (instancetype)cellWithTitle:(NSString*)title
                         icon:(NSString*)icon
                         desc:(NSString*)desc
                       target:(id)target
                          sel:(SEL)selector;

@end
