//
//  BYAddressCell.h
//  IBY
//
//  Created by St on 14-10-23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYTbVC.h"
#import "BYAddress.h"
#import "TTTAttributedLabel.h"

@interface BYAddressCell : BYTableCell
@property (weak, nonatomic) IBOutlet UILabel* receiverLabel;

@property (weak, nonatomic) IBOutlet UILabel* addressLabel;

@property (strong, nonatomic)  UIImageView* isdefaultMark;
- (void)update:(BYAddress*)data;

@end
