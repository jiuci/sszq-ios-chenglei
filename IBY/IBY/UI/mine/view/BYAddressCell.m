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
    self.showRightArrow = YES;

    self.backgroundColor = [UIColor whiteColor];

    self.addressLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
}

- (void)updateReceverInfo:(BYAddress*)address
{
    NSString* preStr = address.isdefault ? @"[默认] " : @"";
    NSString* subStr = [NSString stringWithFormat:@"%@    %@", address.receiver, address.phone];
    NSDictionary* arialdict = [NSDictionary dictionaryWithObject:BYColorb768 forKey:NSForegroundColorAttributeName];
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:preStr attributes:arialdict];

    NSDictionary* veradnadict = [NSDictionary dictionaryWithObject:BYColor666 forKey:NSForegroundColorAttributeName];
    NSMutableAttributedString* VattrString = [[NSMutableAttributedString alloc] initWithString:subStr attributes:veradnadict];

    [attrString appendAttributedString:VattrString];
    _receiverLabel.attributedText = attrString;
}

- (void)update:(BYAddress*)data
{
    if (!data) {
        _receiverLabel.text = @"请添加地址信息";
        _addressLabel.text = nil;

        return;
    }

    //TODO: 如果木有地址，会怎么展示
    [self updateReceverInfo:data];

    NSString* address = [NSString stringWithFormat:@"%@%@%@%@", data.provinceName, data.cityName, data.areaName, data.address];
    CGSize size = [address sizeWithFont:Font(13) maxSize:CGSizeMake(208, 50)];
    _addressLabel.height = size.height + 5;
    _addressLabel.text = address;
}

- (void)setItem:(BYTableItem*)item
{
    BYOrderService* service = item.cellData;
    BYAddress* address = service.curAddress;

    [self updateReceverInfo:address];

    NSString* addressString = [NSString stringWithFormat:@"%@%@%@%@", address.provinceName, address.cityName, address.areaName, address.address];
    _addressLabel.text = addressString;
}

@end
