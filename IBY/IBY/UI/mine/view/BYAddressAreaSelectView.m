//
//  BYAddressAreaSelectView.m
//  IBY
//
//  Created by St on 15/1/7.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYAddressAreaSelectView.h"
#import "BYAddressService.h"
#import "BYAddress.h"
#import "BYAddressSelectCell.h"

static NSString* cellId = @"BYAddressSelectCell";
#define cellHeight 45

@interface BYAddressAreaSelectView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray* tableViewArray;

@property (nonatomic, strong) UIView* mainView;
@property (nonatomic, strong) UITableView* selectTableView;
@property (nonatomic, strong) BYAddressService* addressService;
@property (nonatomic, strong) UIButton* lastButton;
@property (nonatomic, strong) UIButton* nextButton;

@property (nonatomic, strong) NSMutableArray* showList;
@property (nonatomic, assign) int selectedProvinceId;
@property (nonatomic, assign) int selectedCityId;
@property (nonatomic, assign) int selectedAreaId;
@property (nonatomic, strong) BYProvince* selectedProvince;
@property (nonatomic, strong) BYCity* selectedCity;
@property (nonatomic, strong) BYArea* selectedArea;
@property (nonatomic, strong) NSIndexPath* preIndex;
@property (nonatomic, assign) int marker;

@property (nonatomic, assign) int lock;

@end

@implementation BYAddressAreaSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lock = -1;
        _selectedProvinceId = -1;
        _selectedCityId = -1;
        _selectedAreaId = -1;
        _showList = [NSMutableArray array];
        _addressService = [[BYAddressService alloc] init];
        [self setupUI];

        self.autoHideWhenTapBg = NO;
    }
    return self;
}

- (void)updateData:(BYProvince*)province city:(BYCity*)city area:(BYArea*)area
{
    _selectedProvince = province;
    _selectedCity = city;
    _selectedArea = area;
}

- (void)setupUI
{

    _mainView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 270, 290)];
    _mainView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    _mainView.size = CGSizeMake(270, 290);
    [self addSubview:_mainView];

    UIImageView* backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _mainView.width, _mainView.height)];
    backImageView.image = [[UIImage imageNamed:@"icon_address_background"] resizableImage];
    [_mainView addSubview:backImageView];

    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _mainView.width, 47)];
    titleLabel.textColor = BYColorb768;
    titleLabel.text = @"请选择";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = Font(16);
    [_mainView addSubview:titleLabel];

    UIImageView* lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 47, 270, 1)];
    lineView.image = [UIImage imageNamed:@"line_common"];
    [_mainView addSubview:lineView];

    _selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, 270, cellHeight * 4)];
    _selectTableView.backgroundColor = BYColorBG;
    _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _selectTableView.delegate = self;
    _selectTableView.dataSource = self;
    [_mainView addSubview:_selectTableView];

    UIImageView* lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, _selectTableView.bottom, _mainView.width, 1)];
    lineView1.image = [UIImage imageNamed:@"line_common"];
    [_mainView addSubview:lineView1];

    UIButton* cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(_mainView.width - 48, 0, 48, 48)];
    [cancelButton setImage:[[UIImage imageNamed:@"icon_address_close"] resizableImage] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
    [_mainView addSubview:cancelButton];

    // 上一步和下一步按钮
    _lastButton = [[UIButton alloc] initWithFrame:CGRectMake(15, _selectTableView.bottom + 9, 112, 44)];
    [_lastButton setBackgroundImage:[[UIImage imageNamed:@"bg_frame_size_default"] resizableImage] forState:UIControlStateNormal];
    [_lastButton setTitle:@"上一步" forState:UIControlStateNormal];
    _lastButton.titleLabel.font = Font(16);
    [_lastButton setTitleColor:BYColor999 forState:UIControlStateNormal];
    [_lastButton addTarget:self action:@selector(lastStepClick) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_lastButton];

    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(_lastButton.right + 16, _selectTableView.bottom + 9, 112, 44)];
    [_nextButton setBackgroundImage:[[UIImage imageNamed:@"btn_red"] resizableImage] forState:UIControlStateNormal];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    _nextButton.titleLabel.font = Font(16);
    [_nextButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_nextButton];
}

- (void)buttonMatch
{
    if (_marker == BYAddressTypeProvince) {
        _nextButton.frame = CGRectMake(15, _selectTableView.bottom + 9, 240, 44);
    }
    else {
        _nextButton.frame = CGRectMake(_lastButton.right + 16, _selectTableView.bottom + 9, 112, 44);
    }
}

#pragma 按钮相应方法

- (void)dismissClick
{
    [self hide];
}

- (void)lastStepClick
{

    _marker--;
    [self buttonMatch];
    [self showInfoByMark:_marker];
}

- (void)nextStepClick
{
    _marker++;
    if (_marker > BYAddressTypeArea) {
        [self hide];
        self.saveBlk(_selectedProvince, _selectedCity, _selectedArea);
    }

    [self buttonMatch];
    [self showInfoByMark:_marker];
}

- (void)showInfoByMark:(int)mark
{
    _marker = mark;
    [self buttonMatch];

    switch (mark) {
    case BYAddressTypeProvince: {
        _nextButton.userInteractionEnabled = NO;
        _lastButton.userInteractionEnabled = NO;
        [self.addressService fetchProvinceList:^(NSArray* provinceList, BYError* error) {
            if(error){
                alertError(error);
            }else{
                if(!provinceList || provinceList.count == 0){
                    [MBProgressHUD topShowTmpMessage:@"获取省信息时出现问题"];
                }else{
                    [self.showList removeAllObjects];
                    [self.showList addObjectsFromArray:provinceList];
                    if (!_selectedProvince) {
                        _selectedProvince = _showList[0];
                    }
                    [_selectTableView reloadData];
                    runBlockAfterDelay(0.3, ^{
                        for (int i = 0; i < _showList.count; i++) {
                            BYProvince* province = _showList[i];
                            if([province.provinceId isEqualToString:_selectedProvince.provinceId]){
                                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                [_selectTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                                //[_selectTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                continue;
                            }
                        }
                        _nextButton.userInteractionEnabled = YES;
                        _lastButton.userInteractionEnabled = YES;
                    });
                }
            }
        }];

    }

    break;
    case BYAddressTypeCity: {
        _nextButton.userInteractionEnabled = NO;
        _lastButton.userInteractionEnabled = NO;
        [self.addressService fetchCityListByProvinceId:[_selectedProvince.provinceId intValue] finish:^(NSArray* cityList, BYError* error) {
                if(error){
                    alertError(error);
                }else{
                    if(!cityList || cityList.count == 0){
                        [MBProgressHUD topShowTmpMessage:@"获取城市信息时出现问题"];
                    }else{
                        [self.showList removeAllObjects];
                        [self.showList addObjectsFromArray:cityList];
                        if (!_selectedCity) {
                            _selectedCity = _showList[0];
                        }
                        [_selectTableView reloadData];
                        runBlockAfterDelay(0.3, ^{
                            for (int i = 0; i < _showList.count; i++) {
                                BYCity* city = _showList[i];
                                if([city.cityId isEqualToString:_selectedCity.cityId]){
                                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                    [_selectTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                                    //[_selectTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                    continue;
                                }
                            }
                            _nextButton.userInteractionEnabled = YES;
                            _lastButton.userInteractionEnabled = YES;
                        }) ;
                        
                        
                        
                    }
                    
                }
        }];

    } break;

    case BYAddressTypeArea: {
        _nextButton.userInteractionEnabled = NO;
        _lastButton.userInteractionEnabled = NO;
        [self.addressService fetchAreaListByCityId:[_selectedCity.cityId intValue] finish:^(NSArray* areaList, BYError* error) {
                if(error){
                    alertError(error);
                }else{
                    if(!areaList || areaList.count == 0){
                        [MBProgressHUD topShowTmpMessage:@"获取区域信息时出现问题"];
                    }else{
                        [self.showList removeAllObjects];
                        [self.showList addObjectsFromArray:areaList];
                        if (!_selectedArea) {
                            _selectedArea = _showList[0];
                        }
                        [_selectTableView reloadData];
                        runBlockAfterDelay(0.3, ^{
                            
                            for (int i = 0; i < _showList.count; i++) {
                                BYArea* area = _showList[i];
                                if([area.areaId isEqualToString:_selectedArea.areaId]){
                                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                    [_selectTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                                    //[_selectTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                    continue;
                                }
                            }
                            _nextButton.userInteractionEnabled = YES;
                            _lastButton.userInteractionEnabled = YES;
                        });
                        
                        
                    }
                    
                }
        }];
    } break;
    default:
        break;
    }
}

#pragma 默认方法

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return cellHeight;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _showList.count;
}

- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    BYAddressSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[BYAddressSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell setupUI];
    }

    [cell isSelected:NO];
    id place = _showList[indexPath.row];
    if ([place isKindOfClass:[BYProvince class]]) {

        BYProvince* province = _showList[indexPath.row];
        [cell updateTitle:province.provinceName];
        if (_selectedProvince && [_selectedProvince.provinceId intValue] == [province.provinceId intValue]) {
            [cell isSelected:YES];

            _preIndex = indexPath;
        }
    }
    else if ([place isKindOfClass:[BYCity class]]) {
        BYCity* city = _showList[indexPath.row];
        [cell updateTitle:city.cityName];
        if (_selectedCity && [_selectedCity.cityId intValue] == [city.cityId intValue]) {
            [cell isSelected:YES];

            _preIndex = indexPath;
        }
    }
    else {
        BYArea* area = _showList[indexPath.row];
        [cell updateTitle:area.areaName];
        if (_selectedArea && [_selectedArea.areaId intValue] == [area.areaId intValue]) {
            [cell isSelected:YES];
            _preIndex = indexPath;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (!_preIndex) {
        _preIndex = indexPath;
    }
    else {
        BYAddressSelectCell* PreCell = (BYAddressSelectCell*)[tableView cellForRowAtIndexPath:_preIndex];
        _preIndex = indexPath;
        [PreCell isSelected:NO];
    }

    BYAddressSelectCell* cell = (BYAddressSelectCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell isSelected:YES];
    id place = _showList[indexPath.row];
    if ([place isKindOfClass:[BYProvince class]]) {
        BYProvince* SelectedProvince = _showList[indexPath.row];
        if (![_selectedProvince.provinceId isEqualToString:SelectedProvince.provinceId]) {
            _selectedProvince = _showList[indexPath.row];
            _selectedCity = nil;
            _selectedArea = nil;
        }
    }
    else if ([place isKindOfClass:[BYCity class]]) {
        BYCity* SelectedCity = _showList[indexPath.row];
        if (![_selectedProvince.provinceId isEqualToString:SelectedCity.cityId]) {
            _selectedCity = _showList[indexPath.row];
            _selectedArea = nil;
        }
    }
    else {
        BYArea* SelectedArea = _showList[indexPath.row];
        if (![_selectedProvince.provinceId isEqualToString:SelectedArea.areaId]) {
            _selectedArea = _showList[indexPath.row];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //[tableView reloadData];
}

@end
