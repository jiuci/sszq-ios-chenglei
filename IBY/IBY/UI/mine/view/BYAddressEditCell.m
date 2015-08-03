//
//  BYAddressEditCell.m
//  IBY
//
//  Created by panshiyu on 15/1/5.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYAddressEditCell.h"

@implementation BYAddressEditCell

+ (instancetype)editCellWithTitle:(NSString*)title input:(UIView*)inputView
{
    BYAddressEditCell* cell = [[self alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, 40)];
    cell.showBottomLine = YES;

    UILabel* label = [UILabel labelWithFrame:BYRectMake(0, 0, 84, cell.height) font:Font(14) andTextColor:BYColor999];
    label.textAlignment = NSTextAlignmentRight;
    label.text = title;
    [cell addSubview:label];

    if (inputView) {
        inputView.left = 95;
        inputView.top = 0;
        [cell addSubview:inputView];
    }

    return cell;
}

@end

#pragma mark -

@implementation BYAddressEditFooter {
    UIImageView* _radioView;
}

+ (instancetype)addressEditFooter
{
    return [[self alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, 52)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIImageView* bg = makeImgView(BYRectMake(0, 0, self.width, self.height), @"bg_toolbar");
        [self addSubview:bg];

        _radioView = [[UIImageView alloc] initWithFrame:BYRectMake(12, 18, 16, 16)];
        _radioView.image = [UIImage imageNamed:@"icon_checkbox"];
        _radioView.highlightedImage = [UIImage imageNamed:@"icon_checkbox_on"];
        [self addSubview:_radioView];

        UILabel* radioDescLabel = [UILabel labelWithFrame:BYRectMake(36, 0, 150, self.height) font:Font(14) andTextColor:BYColor666];
        radioDescLabel.text = @"设为默认地址";
        [self addSubview:radioDescLabel];

        _radioBtn = [[UIButton alloc] initWithFrame:BYRectMake(0, 0, 150, self.height)];
        _radioBtn.backgroundColor = BYColorClear;
        [self addSubview:_radioBtn];

        UIButton* confirmBtn = [UIButton buttonWithFrame:BYRectMake(0, 0, 80, 40) title:@"保存" titleColor:BYColorWhite bgName:@"btn_red" handler:nil];
        confirmBtn.titleLabel.font = Font(16);
        confirmBtn.right = self.width - 12;
        confirmBtn.centerY = self.height / 2;
        [self addSubview:confirmBtn];
        _confirmBtn = confirmBtn;
    }
    return self;
}

- (void)setWillBeDefault:(BOOL)willBeDefault
{
    _willBeDefault = willBeDefault;
    _radioView.highlighted = _willBeDefault;
}

@end

#pragma mark -

BYTextField* addressEditTxtfield(NSString* placeholder, id<UITextFieldDelegate> delegate)
{
    BYTextField* txtFeild = makeDefaultTextField(placeholder, Font(14), BYColor333, nil);
    txtFeild.frame = BYRectMake(0, 0, 230, 40);
    txtFeild.insets = UIEdgeInsetsMake(0, 0, 0, 7);
    //top, left, bottom, right
    txtFeild.returnKeyType = UIReturnKeyNext;
    txtFeild.delegate = delegate;
    return txtFeild;
}



UILabel* addressEditLabel(NSString* initString)
{
    UILabel* label = [UILabel labelWithFrame:BYRectMake(0, 0, 230, 40) font:Font(14) andTextColor:BYColor333];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = initString;
    return label;
}
