//
//  BYAddressDetailVC.h
//  IBY
//
//  Created by St on 14-10-23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"
#import "BYAddress.h"

#import "BYBaseCell.h"

@protocol BYAddressDetailDelegate <NSObject>

- (void)needUpdate;

@end

@interface BYAddressDetailVC : BYBaseVC

@property (nonatomic, assign) id<BYAddressDetailDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView* addressView;
@property (weak, nonatomic) IBOutlet UITextField* receiverTextField;
@property (weak, nonatomic) IBOutlet UITextField* phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField* detailaddressTextFiled;
@property (weak, nonatomic) IBOutlet UITextField* zipcodeTextField;

@property (weak, nonatomic) IBOutlet UITextField* provinceTextField;
@property (weak, nonatomic) IBOutlet UITextField* cityTextField;
@property (weak, nonatomic) IBOutlet UITextField* areaTextField;
@property (weak, nonatomic) IBOutlet UIButton* isdefaultButton;
@property (weak, nonatomic) IBOutlet UIImageView* defaultImageView;

- (void)update:(BYAddress*)data;

- (id)initWithData:(BYAddress*)data;

- (IBAction)selectProvince:(id)sender;
- (IBAction)selectCity:(id)sender;
- (IBAction)selectArea:(id)sender;
- (IBAction)changeClick:(id)sender;
- (IBAction)isdefaultClick:(id)sender;

@end
