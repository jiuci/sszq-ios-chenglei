//
//  BYAddressDetailVC2.m
//  IBY
//
//  Created by panshiyu on 15/1/5.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYAddressDetailVC2.h"
#import "BYLinearScrollView.h"
#import "BYAddressEditCell.h"
#import "BYAddress.h"
#import "BYAddressAreaSelectView.h"
#import "BYAddressSelectionView.h"
#import "BYAddressService.h"

@interface BYAddressDetailVC2 () <UITextFieldDelegate, BYAddressSelectionDelegate,UITextViewDelegate>

@property (nonatomic, strong) BYLinearScrollView* bodyView;

@property (nonatomic, strong) BYTextField* receiverTxtfield;
@property (nonatomic, strong) BYTextField* phoneTxtfield;
@property (nonatomic, strong) UITextView* addressDetailTxtfield;
@property (nonatomic, strong) UILabel* provinceLabel;
@property (nonatomic, strong) BYAddressEditFooter* footer;

@property (nonatomic, strong) BYAddressService* service;

@property (nonatomic, strong) BYAddressSelectionView* selectionView;

@property (nonatomic, strong) BYAddressAreaSelectView* selectView;

@end

@implementation BYAddressDetailVC2 {
    CGPoint svos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.autoHideKeyboard = YES;

    self.navigationItem.title = _isEditMode ? @"修改收货地址" : @"添加收货地址";

    _selectView = [BYAddressAreaSelectView createPopoverView];

    if (_isEditMode) {
        _address = [_address mirrorAddress];
        [_selectView updateData:_address.province city:_address.city area:_address.area];
    }
    else {
        _address = [[BYAddress alloc] init];
        [_selectView updateData:nil city:nil area:nil];
    }
    __weak BYAddressDetailVC2* wself = self;
    _selectView.saveBlk = ^(BYProvince* province, BYCity* city, BYArea* area) {
        wself.address.province = province;
        wself.address.city = city;
        wself.address.area = area;
        [wself updateUI];
    };

    _service = [[BYAddressService alloc] init];

    [self setupUI];

    _selectionView = [BYAddressSelectionView createPopoverView];
    _selectionView.delegate = self;

    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _footer.bottom = self.view.height;
}

#pragma mark -

- (BOOL)verifyIntegrity
{

    if ([self.receiverTxtfield.text isEqual:@""]) {
        [MBProgressHUD topShowTmpMessage:@"请填写收货人信息"];
        [self.receiverTxtfield resignFirstResponder];
        return NO;
    }
    if ([self.phoneTxtfield.text isEqual:@""]) {
        [MBProgressHUD topShowTmpMessage:@"请填写手机号"];
        [self.phoneTxtfield resignFirstResponder];
        return NO;
    }
    if (!_address.province || !_address.city || !_address.area) {
        [MBProgressHUD topShowTmpMessage:@"请选择省，市和地区"];
        return NO;
    }

    if ([self.addressDetailTxtfield.text isEqual:@""]) {
        [MBProgressHUD topShowTmpMessage:@"请填写详细地址"];
        [self.addressDetailTxtfield resignFirstResponder];
        return NO;
    }

    
    if (self.addressDetailTxtfield.text.length > 120) {
        [MBProgressHUD topShowTmpMessage:@"详细地址不能超过120字符"];
        [self.addressDetailTxtfield resignFirstResponder];
        return NO;
    }

    return YES;
}

- (void)onConfirm
{
    if (![self verifyIntegrity]) {
        return;
    }

    _address.receiver = self.receiverTxtfield.text;
    _address.phone = self.phoneTxtfield.text;
    _address.address = self.addressDetailTxtfield.text;
//    _address.zipcode = self.zipcodeTxtfield.text;

    __weak BYAddressDetailVC2* wself = self;

    if (_isEditMode) {
        [MBProgressHUD topShow:@"更新中..."];
        [self.service updateAddressByAddressId:_address.addressId address:_address.address areaId:[_address.area.areaId intValue] receiver:_address.receiver phone:_address.phone isdefault:_address.isdefault zipcode:_address.zipcode finish:^(BOOL success, BYError* error) {
            if (error) {
                alertError(error);
            }else{
                [MBProgressHUD topShowTmpMessage:@"更新完成"];
                [wself didPopBack];
                
            }
        }];
    }
    else {
        [MBProgressHUD topShow:@"添加中..."];
        [self.service addAddressByAddress:_address.address areaId:_address.area.areaId receiver:_address.receiver phone:_address.phone isdefault:_address.isdefault zipcode:_address.zipcode finish:^(NSNumber* addressId, BYError* error) {
            if (error) {
                alertError(error);
            }else{
                [MBProgressHUD topShowTmpMessage:@"添加完成"];
                wself.address.addressId = [addressId intValue];
                [wself didPopBack];
            }
        }];
    }
}

- (void)didPopBack
{
    if (_delegate) {
        [_delegate needUpdate];
    }

    //    if (self.orderService) {
    //        [_address reProcessData];
    //        self.orderService.curAddress = _address;
    //    }

    [self.navigationController popViewControllerAnimated:YES];
    //    if (self.popToVC) {
    //        [self.navigationController popToViewController:self.popToVC animated:YES];
    //    }
    //    else {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
}

- (void)onSetDefault
{
    _address.isdefault = !_address.isdefault;
    [_footer setWillBeDefault:_address.isdefault];
}

- (void)onProvince
{
    [_selectView showInfoByMark:BYAddressTypeProvince];
    if (_selectView.hasData) {
        [_selectView showInView:self.view];
    }
    
}





- (void)didSelect:(id)selectedData
{
//    if ([selectedData isKindOfClass:[BYProvince class]]) {
        BYProvince* province = selectedData;

        _provinceLabel.text = province.provinceName;
        _address.city = nil;
        _address.area = nil;
        _address.province = selectedData;
        [self updateUI];
//    }
//    else if ([selectedData isKindOfClass:[BYCity class]]) {
//        BYCity* city = selectedData;
//
//        _cityLabel.text = city.cityName;
//        _address.area = nil;
//        _address.city = selectedData;
//        [self updateUI];
//    }
//    else {
//        BYArea* area = selectedData;
//        _areaLabel.text = area.areaName;
//        _address.area = selectedData;
//        [self updateUI];
//    }
}

#pragma mark -

//- (void)onBackgroundTap
//{
//    [self.bodyView setContentOffset:svos animated:YES];
//    [super onBackgroundTap];
//}
//
//- (void)textFieldDidBeginEditing:(UITextField*)textField
//{
//    svos = self.bodyView.contentOffset;
//    CGPoint pt;
//    CGRect rc = [textField bounds];
//    rc = [textField convertRect:rc toView:self.bodyView];
//    pt = rc.origin;
//    pt.x = 0;
//    pt.y -= 60;
//    [self.bodyView setContentOffset:pt animated:YES];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField*)textField
//{
//    [self.bodyView setContentOffset:svos animated:YES];
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if ([textField isEqual:_receiverTxtfield]) {
        _address.receiver = textField.text;
    }
    else if ([textField isEqual:_phoneTxtfield]) {
        if ([textField.text isMobilePhoneNumber]) {
            _address.phone = textField.text;
        }
        else {
            [MBProgressHUD topShowTmpMessage:@"请输入11位手机号"];
        }
    }
    else if ([textField isEqual:_addressDetailTxtfield]) {
        _address.address = textField.text;
    }
//    else if ([textField isEqual:_zipcodeTxtfield]) {
//        if ([textField.text isZipcode]) {
//            _address.zipcode = textField.text;
//        }
//        else {
//            [MBProgressHUD topShowTmpMessage:@"请填写6位邮政编码"];
//        }
//    }
}

#pragma mark -

- (void)setupUI
{
    _bodyView = makeLinearScrollView(self);
    _bodyView.autoAdjustContentSize = NO;
    //_bodyView.minContentSizeHeight = SCREEN_HEIGHT + 20;
    [self.view addSubview:_bodyView];

    _receiverTxtfield = addressEditTxtfield(@"", self);
    BYAddressEditCell* cell1 = [BYAddressEditCell editCellWithTitle:@"收货人：" input:_receiverTxtfield];
    [self.bodyView by_addSubview:cell1 paddingTop:12];

    _phoneTxtfield = addressEditTxtfield(@"", self);
    _phoneTxtfield.text = [BYAppCenter sharedAppCenter].user.phoneNum;
    _phoneTxtfield.keyboardType = UIKeyboardTypeNumberPad;
    
    BYAddressEditCell* cell2 = [BYAddressEditCell editCellWithTitle:@"手机号码：" input:_phoneTxtfield];
    [self.bodyView by_addSubview:cell2 paddingTop:0];
    [self.phoneTxtfield setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField* txtField, NSRange range, NSString* str) {
        
        NSString* realStr = [txtField.text stringByReplacingCharactersInRange:range withString:str];
        if (txtField.text.length > realStr.length) {
            return YES;
        }
        if (realStr.length > 20) {
            return NO;
        }
        return YES;
    }];
    
    
    _provinceLabel = addressEditLabel(@"请选择");
    BYAddressEditCell* cell3 = [BYAddressEditCell editCellWithTitle:@"所在地区：" input:_provinceLabel];
    [cell3 addTarget:self action:@selector(onProvince) forControlEvents:UIControlEventTouchUpInside];
    [self.bodyView by_addSubview:cell3 paddingTop:0];

    _addressDetailTxtfield = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 230, 40 - 4)];
    _addressDetailTxtfield.backgroundColor = [UIColor clearColor];
    _addressDetailTxtfield.font = Font(14);
    _addressDetailTxtfield.textColor = BYColor333;
    //top, left, bottom, right
    _addressDetailTxtfield.returnKeyType = UIReturnKeyDefault;
    _addressDetailTxtfield.delegate = self;
    BYAddressEditCell* cell6 = [BYAddressEditCell editCellWithTitle:@"详细地址：" input:_addressDetailTxtfield left:90];
    [self.bodyView by_addSubview:cell6 paddingTop:12];
    _addressDetailTxtfield.top += 4;


    _footer = [BYAddressEditFooter addressEditFooter];
    _footer.bottom = self.view.height;
    [_footer setWillBeDefault:YES];
    [_footer.confirmBtn addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    [_footer.radioBtn addTarget:self action:@selector(onSetDefault) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_footer];
}

- (void)updateUI
{
    BYAddress* data = _address;
    if (data.receiver) {
        self.receiverTxtfield.text = data.receiver;
    }
    if (data.phone) {
        self.phoneTxtfield.text = data.phone;
    }
    if (data.address) {
        self.addressDetailTxtfield.text = data.address;
    }
    [self resizeTextView:self.addressDetailTxtfield];
    
    
    NSString* provinceString = [NSString stringWithFormat:@"%@ %@ %@",data.province.provinceName,data.city.cityName,data.area.areaName];
    if ([data.city.cityName isEqualToString:@"市辖区"]||[data.city.cityName isEqualToString:@"县"]) {
        provinceString = [NSString stringWithFormat:@"%@ %@",data.province.provinceName,data.area.areaName];
    }
    self.provinceLabel.text = data.province.provinceName ? provinceString : @"请选择";
    [self resizeLabel:self.provinceLabel];
    [self.bodyView by_updateDisplay];
    if (_isEditMode) {
        [_footer setWillBeDefault:_address.isdefault];
    }else{
        _address.isdefault = YES;
        [_footer setWillBeDefault:YES];
    }
    
}

- (void)resizeLabel:(UILabel*)label
{
    CGSize size = [label.text sizeWithFont:Font(14) maxSize:CGSizeMake(label.width, 1000)];
    label.height = label.height > size.height ? label.height :size.height;
    label.superview.height = label.superview.height > size.height ? label.superview.height :size.height;
}

- (void)resizeTextView:(UITextView*)textView
{
    
    CGSize size = [textView.text sizeWithFont:Font(14) maxSize:CGSizeMake(textView.width, 1000)];
    size = [textView sizeThatFits:textView.size];
    size.height += 12;
    textView.height = textView.height > size.height ? textView.height :size.height;
    textView.superview.height = textView.superview.height > size.height ? textView.superview.height :size.height;
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self resizeTextView:textView];
}
@end
