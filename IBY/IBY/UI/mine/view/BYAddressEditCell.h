//
//  BYAddressEditCell.h
//  IBY
//
//  Created by panshiyu on 15/1/5.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseCell.h"
#import "BYTextField.h"

BYTextField* addressEditTxtfield(NSString* placeholder, id<UITextFieldDelegate> delegate);

UILabel* addressEditLabel(NSString* initString);

@interface BYAddressEditCell : BYBaseCell
+ (instancetype)editCellWithTitle:(NSString*)title input:(UIView*)inputView;
@end

@interface BYAddressEditFooter : UIView
@property (nonatomic, strong) UIButton* confirmBtn;
@property (nonatomic, strong) UIButton* radioBtn;
@property (nonatomic, assign) BOOL willBeDefault;
+ (instancetype)addressEditFooter;
@end
