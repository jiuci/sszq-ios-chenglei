//
//  BYAddressSelectCell.h
//  IBY
//
//  Created by St on 15/1/7.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYAddressSelectCell : UITableViewCell

- (void)setupUI;

- (void)updateTitle:(NSString*)title;

- (void)isSelected:(BOOL)isSelected;

@end
