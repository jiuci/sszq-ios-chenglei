//
//  BYAddressCell.m
//  IBY
//
//  Created by St on 14-10-23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYAddressCell.h"
#import "BYOrderService.h"

@implementation BYAddressCell

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.showRightArrow = YES;
    self.width = SCREEN_WIDTH;
    self.height = 80;
    self.backgroundColor = [UIColor whiteColor];
    _isdefaultMark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_address_defultaddress"]];
    [self.contentView addSubview:_isdefaultMark];
//    _isdefaultMark.width = _isdefaultMark.width * 1.5;
//    _isdefaultMark.height = _isdefaultMark.height * 1.5;
    _isdefaultMark.right = SCREEN_WIDTH;
    
    
//    self.addressLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
}


- (void)update:(BYAddress*)data
{
    if (!data) {
        _receiverLabel.text = @"请添加地址信息";
        _addressLabel.text = nil;

        return;
    }
    
    _receiverLabel.text = [NSString stringWithFormat:@"%@    %@", data.receiver, data.phone];
    
    NSString* address = [NSString stringWithFormat:@"%@%@%@\n%@", data.provinceName, data.cityName, data.areaName, data.address];
    CGSize size = [address sizeWithFont:Font(13) maxSize:CGSizeMake(self.width - 24, 100)];
    _addressLabel.height = size.height + 12;
    _addressLabel.text = address;
    _addressLabel.numberOfLines = 0;
    
    if (data.isdefault) {
        _receiverLabel.textColor = HEXCOLOR(0x523669);
        _addressLabel.textColor = HEXCOLOR(0x523669);
        _isdefaultMark.hidden = NO;
        
    }else{
        _receiverLabel.textColor = BYColor333;
        _addressLabel.textColor = BYColor666;
        _isdefaultMark.hidden = YES;
    }
}


@end
