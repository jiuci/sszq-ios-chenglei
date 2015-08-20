//
//  BYAddressDetailVC.m
//  IBY
//
//  Created by St on 14-10-23.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYAddressDetailVC.h"
#import "BYaddressService.h"
#import "BYaddressSelectionView.h"
#import "BYAddressAreaSelectView.h"

@interface BYAddressDetailVC () <UITextFieldDelegate, BYAddressSelectionDelegate>

@property (nonatomic, strong) BYAddress* addressData;
@property (nonatomic, strong) BYAddressService* addressService;
@property (nonatomic, strong) NSMutableArray* showList;
@property (nonatomic, strong) BYAddressSelectionView* selectionView;
@property (nonatomic, strong) BYAddressAreaSelectView* selectView;
@property (nonatomic, assign) int isdefault;

@property (nonatomic, strong) BYProvince* selectedProvince;
@property (nonatomic, strong) BYCity* selectedCity;
@property (nonatomic, strong) BYArea* selectedArea;

@end

@implementation BYAddressDetailVC

- (id)initWithData:(BYAddress*)data
{
    self = [super init];
    if (self) {

        self.selectedProvince = nil;
        self.selectedCity = nil;
        self.selectedArea = nil;
        self.addressData = data;

        self.addressService = [[BYAddressService alloc] init];
        _showList = [NSMutableArray array];

        if (data) {
            self.addressData = data;
            self.isdefault = data.isdefault;
        }
        else {
            self.addressData = nil;
            self.isdefault = 0;
        }
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self update:self.addressData];

    self.showList = [NSMutableArray array];
    self.selectionView = [BYAddressSelectionView createPopoverView];
    self.selectionView.delegate = self;

    self.selectView = [BYAddressAreaSelectView createPopoverView];
    self.phoneTextField.text = [BYAppCenter sharedAppCenter].user.phoneNum;
    [self.phoneTextField setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField* txtField, NSRange range, NSString* str) {
        NSString* realStr = [txtField.text stringByReplacingCharactersInRange:range withString:str];
        if (txtField.text.length > realStr.length) {
            return YES;
        }
        if (realStr.length > 20) {
            return NO;
        }
        return YES;
    }];
    [self setUpForDismissKeyboard];
}

- (IBAction)selectProvince:(id)sender
{
    [self.view endEditing:YES];
    [self.addressService fetchProvinceList:^(NSArray* provinceList, BYError* error) {
            if(error){
                alertError(error);
            }else{
                if(!provinceList || provinceList.count == 0){
                    [MBProgressHUD topShowTmpMessage:@"获取省信息时出现问题"];
                }else{
                    [self.showList removeAllObjects];
                    [self.showList addObjectsFromArray:provinceList];
                    [self.selectionView updateData:self.showList];
                    [self.view endEditing:YES];
                    [self.selectionView showInView:self.view];
                }
    
            }

    }];
}

- (IBAction)selectCity:(id)sender
{
    [self.view endEditing:YES];

    if (_selectedProvince && ![_provinceTextField.text isEqualToString:@"请选择"]) {
        [self.addressService fetchCityListByProvinceId:[_selectedProvince.provinceId intValue] finish:^(NSArray* cityList, BYError* error) {
            if(error){
                alertError(error);
            }else{
                if(!cityList || cityList.count == 0){
                    [MBProgressHUD topShowTmpMessage:@"获取城市信息时出现问题"];
                }else{
                    [self.showList removeAllObjects];
                    [self.showList addObjectsFromArray:cityList];
                    
                    [self.selectionView updateData:self.showList];
                    [self.view endEditing:YES];
                    [self.selectionView showInView:self.view];
                    //[self.pickerView reloadAllComponents];
                }
                
            }
        }];
    }
    else {
        [MBProgressHUD topShowTmpMessage:@"请先选择省"];
    }
}


- (IBAction)changeClick:(id)sender
{
    BOOL verifyCode = [self verifyIntegrity];

    __weak BYAddressDetailVC* wself = self;

    if (verifyCode) {
        //data不为空表示 是进行地址修改   为空表示是新建的地址
        if (self.addressData) {
            [MBProgressHUD showMessage:@""];
            [self.addressService updateAddressByAddressId:self.addressData.addressId address:self.detailaddressTextFiled.text
                                                   areaId:[self.selectedArea.areaId intValue]
                                                 receiver:self.receiverTextField.text
                                                    phone:self.phoneTextField.text
                                                isdefault:self.isdefault
                                                  zipcode:nil
                                                   finish:^(BOOL success, BYError* error) {
                 if(error){
                     [MBProgressHUD hideHUD];
                 }else{
                     [MBProgressHUD topShowTmpMessage:@"数据加载失败"];
                     __strong BYAddressDetailVC *sself = wself;
                     [sself.delegate needUpdate];
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                                                   }];
        }
        else {
            [self.addressService addAddressByAddress:self.detailaddressTextFiled.text areaId:self.selectedArea.areaId receiver:self.receiverTextField.text phone:self.phoneTextField.text isdefault:self.isdefault zipcode:nil finish:^(NSNumber* addressId, BYError* error) {
                if(error){
                    [MBProgressHUD topShowTmpMessage:@"新建地址失败"];
                }else{
                    __strong BYAddressDetailVC *sself = wself;
                    [sself.delegate needUpdate];
                    [MBProgressHUD topShowTmpMessage:@"新建地址成功"];
                    [sself.navigationController popViewControllerAnimated:YES];
                    
                }
            }];
        }
    }
}

- (IBAction)isdefaultClick:(id)sender
{
    //    self.isdefault = !self.isdefault;
    //    if (self.isdefault) {
    //        self.isdefaultButton.alpha = 0.35;
    //    }
    //    else {
    //        self.isdefaultButton.alpha = 1;
    //    }
}

- (IBAction)deleteButton:(id)sender
{
    __weak BYAddressDetailVC* wself = self;

    [self.addressService deleteAddressByAddressId:self.addressData.addressId finish:^(BOOL success, BYError* error) {
        if(error){
            [MBProgressHUD topShowTmpMessage:@"删除失败"];
        }else{
            [MBProgressHUD topShowTmpMessage:@"删除成功"];
            __strong BYAddressDetailVC *sself = wself;
            [sself.delegate needUpdate];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (BOOL)verifyIntegrity
{

    if ([self.receiverTextField.text isEqual:@""]) {
        [MBProgressHUD topShowTmpMessage:@"请填写收货人信息"];
        return NO;
    }
    else if ([self.phoneTextField.text isEqual:@""]) {
        [MBProgressHUD topShowTmpMessage:@"请填写手机号"];
        return NO;
    }
    else if ([self.provinceTextField.text isEqual:@""]) {
        [MBProgressHUD topShowTmpMessage:@"请选择省，市或者地区"];
        return NO;
    }
    else if ([self.detailaddressTextFiled.text isEqual:@""]) {
        [MBProgressHUD topShowTmpMessage:@"请填写详细地址"];
        return NO;
    }
    else {
        return YES;
    }
}



- (BOOL)isMobilePhoneNumber:(NSString*)phoneNum
{
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"^1[\\d\\*]{10}$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:phoneNum options:0 range:NSMakeRange(0, [phoneNum length])];
    if (1 == numberOfMatches) {
        return YES;
    }
    return NO;
}

- (void)update:(BYAddress*)data
{
    self.phoneTextField.delegate = self;
    [self.defaultImageView addTapAction:@selector(defaultTap) target:self];

    if (data) {
        self.receiverTextField.clearButtonMode = UITextFieldViewModeAlways;
        self.receiverTextField.text = data.receiver;
        self.phoneTextField.text = data.phone;
        self.detailaddressTextFiled.text = data.address;
        self.selectedProvince = data.province;
        self.selectedCity = data.city;
        self.selectedArea = data.area;
        self.provinceTextField.text = self.selectedProvince.provinceName;
//        self.cityTextField.text = self.selectedCity.cityName;
//        self.areaTextField.text = self.selectedArea.areaName;
        if (self.isdefault == 1) {
            self.isdefaultButton.alpha = 0.35;
            self.defaultImageView.image = [UIImage imageNamed:@"icon_checkbox_on"];
        }
        else {
            self.isdefaultButton.alpha = 1;
            self.defaultImageView.image = [UIImage imageNamed:@"icon_checkbox"];
        }
    }
}

- (void)defaultTap
{
    self.isdefault = !self.isdefault;
    if (self.isdefault == 1) {
        self.isdefaultButton.alpha = 0.35;
        self.defaultImageView.image = [UIImage imageNamed:@"icon_checkbox_on"];
    }
    else {
        self.isdefaultButton.alpha = 1;
        self.defaultImageView.image = [UIImage imageNamed:@"icon_checkbox"];
    }
}

- (void)setUpForDismissKeyboard
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer* singleTapGR =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue* mainQuene = [NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification* note) {
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification* note) {
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer*)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
//    NSLog(@"have ended editing!");
    if (![self isMobilePhoneNumber:self.phoneTextField.text]) {
        [MBProgressHUD topShowTmpMessage:@"请输入11位手机号"];
    }
    
}
- (void)didSelect:(id)selectedData
{
    if ([selectedData isKindOfClass:[BYProvince class]]) {
        _selectedProvince = selectedData;
        _selectedCity = nil;
        _selectedArea = nil;
        self.provinceTextField.text = _selectedProvince.provinceName;
//        self.cityTextField.text = @"";
//        self.areaTextField.text = @"";
        [self.selectionView hide];
    }
    else if ([selectedData isKindOfClass:[BYCity class]]) {
        _selectedCity = selectedData;
        _selectedArea = nil;
//        self.cityTextField.text = _selectedCity.cityName;
//        self.areaTextField.text = @"";
        [self.selectionView hide];
    }
    else {
        _selectedArea = selectedData;
//        self.areaTextField.text = _selectedArea.areaName;
        [self.selectionView hide];
    }
}

@end
