//
//  BYAddressSelectionView.m
//  IBY
//
//  Created by St on 14-10-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYAddressSelectionView.h"
#import "BYAddress.h"

@interface BYAddressSelectionView () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UILabel* titlelabel;

@property (nonatomic, strong) NSArray* data;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, strong) UIButton* sureButton;
@property (nonatomic, assign) NSInteger selectedNum;

@end

@implementation BYAddressSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {

        self.data = [NSArray array];
        self.selectedNum = 0;

        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.backgroundColor = BYColorWhite;
        self.pickerView.bottom = self.bottom;
        [self addSubview:self.pickerView];

        self.sureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sureButton bk_addEventHandler:^(id sender) {
            [self hide];
            if (_delegate && [_delegate respondsToSelector:@selector(didSelect:)]){
                [_delegate didSelect:self.data[self.selectedNum]];
            }

        } forControlEvents:UIControlEventTouchUpInside];
        self.sureButton.bottom = self.pickerView.top;
        [self addSubview:self.sureButton];

        self.autoHideWhenTapBg = NO;
    }

    return self;
}

- (void)updateData:(NSArray*)data
{
    self.data = data;
    [self.pickerView reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return self.data.count;
}

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.data[row] isKindOfClass:[BYProvince class]]) {
        BYProvince* province = self.data[row];
        return province.provinceName;
    }
    else if ([self.data[row] isKindOfClass:[BYCity class]]) {
        BYCity* city = self.data[row];
        return city.cityName;
    }
    else {
        BYArea* area = self.data[row];
        return area.areaName;
    }
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedNum = row;
}

@end
