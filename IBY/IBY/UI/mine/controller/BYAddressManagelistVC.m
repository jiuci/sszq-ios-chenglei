//
//  BYAddressVC.m
//  IBY
//
//  Created by St on 14-10-22.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYAddressManagelistVC.h"

#import "BYAddressCell.h"
#import "BYAddressDetailVC.h"
#import "BYAddressDetailVC2.h"
#import "BYAddressService.h"
#import "BYAutosizeBgButton.h"

#import "BYPoolNetworkView.h"

static NSString* cellID = @"BYAddressCell";

@interface BYAddressManagelistVC () <BYAddressDetailDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BYAutosizeBgButton * addBtn;
    float offset ;
    UILabel * noneLabel;
    UIImageView* noneImage;
}
@property (weak, nonatomic) IBOutlet UITableView* addressTableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) NSMutableArray* addressList;
@property (nonatomic, strong) UITableViewCell *prototypeCell;
@end

@implementation BYAddressManagelistVC {
    BYAddressService* _addressService;
    BOOL _needUpdate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.title = @"我的地址";
    self.view.height = SCREEN_HEIGHT - self.navigationController.navigationBar.height - [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.view.width = SCREEN_WIDTH;
    _addressService = [[BYAddressService alloc] init];
    _addressList = [NSMutableArray array];

    self.addressTableView.delegate = self;
    self.addressTableView.dataSource = self;
    self.addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.addressTableView.sectionFooterHeight = 12;
    

    
    

    UINib* nib = [UINib nibWithNibName:@"BYAddressCell" bundle:nil];
    [self.addressTableView registerNib:nib forCellReuseIdentifier:cellID];
    self.prototypeCell  = [self.addressTableView dequeueReusableCellWithIdentifier:cellID];
    
    _needUpdate = YES;

    self.tipsTopPadding = 70;
    
    addBtn = [[BYAutosizeBgButton alloc]initWithFrame:CGRectMake(12, 0, self.view.width - 24, 40)];
    addBtn.bottom = self.view.height - 20;
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addNewAddress:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red"] resizableImage] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red_on"] resizableImage] forState:UIControlStateHighlighted];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addBtn setTitle:@"添加收货地址" forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"icon_address_add"] forState:UIControlStateNormal|UIControlStateNormal];
    [addBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [addBtn setTitleColor:BYColorWhite forState:UIControlStateNormal];
    addBtn.hidden = YES;
    
    float height = 0;
    noneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_address_none"]];
    noneImage.centerX = self.view.width / 2;
    height += noneImage.height;
    [self.view addSubview:noneImage];
    height += 20;
    noneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, height, self.view.width, 20)];
    noneLabel.text = @"您还没有创建过收货地址喔~";
    noneLabel.textAlignment = NSTextAlignmentCenter;
    noneLabel.textColor = BYColor666;
    noneLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:noneLabel];
    height += 20;
    height += 32;
    height += 40;
    offset = (self.view.height - height - (SCREEN_HEIGHT - self.view.height)) / 2;
    noneImage.top += offset;
    noneLabel.top += offset;
    [self.view sendSubviewToBack:noneLabel];
    [self.view sendSubviewToBack:noneImage];
    
    _addressTableView.backgroundColor = self.view.backgroundColor;
}

- (void)setNoneAddr:(BOOL)noneaddr
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (_needUpdate) {
        [self updateData];
        _needUpdate = NO;
    }
}

- (void)updateData
{
    [self hideTipsView];
    [MBProgressHUD topShow:@"更新中..."];
    [_addressService fetchAddressList:^(NSArray* addressList, BYError* error) {
        [MBProgressHUD topHide];
        if(error){
            addBtn.hidden = YES;
            self.addressTableView.hidden = YES;
            alertError(error);
            self.tipsTopPadding = 0;
            [self showPoolnetworkView];
            self.tipsView.backgroundColor = self.view.backgroundColor;
            UIButton* btn = [[UIButton alloc] initWithFrame:self.tipsView.frame];
            btn.backgroundColor = BYColorClear;
            [btn addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchUpInside];
            [self.tipsView addSubview:btn];
        }else{
            addBtn.hidden = NO;
            if(!addressList || addressList.count == 0){
                [self.addressList removeAllObjects];
                [self updateUI];
                [self showTip];
            }else{
                self.addressTableView.hidden = NO;
                [self.addressList removeAllObjects];
                [self.addressList addObjectsFromArray:addressList];
                for (int i = 0 ; i < self.addressList.count; i++) {
                    BYAddress* data = addressList[i];
                    if (data.isdefault) {
                        [self.addressList exchangeObjectAtIndex:0 withObjectAtIndex:i];
                    }
                }
                [self hideTip];
                [self updateUI];
            }
            
        }
    }];
}

- (void)showTip
{
    _addressTableView.hidden = YES;
    addBtn.bottom = self.view.height - offset - (SCREEN_HEIGHT - self.view.height);
    addBtn.width = 180;
    addBtn.centerX = self.view.width / 2;
}

- (void)hideTip
{
    _addressTableView.hidden = NO;
    addBtn.bottom = self.view.height - 20;
    addBtn.width = self.view.width - 24;
    addBtn.centerX = self.view.width / 2;
}
- (void)updateUI
{
    [self.addressTableView reloadData];
}

#pragma mark -

- (IBAction)addNewAddress:(id)sender
{
    BYAddressDetailVC2* addNewAddressView = [[BYAddressDetailVC2 alloc] init];
    addNewAddressView.navigationItem.title = @"添加收货地址";
    addNewAddressView.delegate = self;
    addNewAddressView.orderService = self.orderService;
    if (_inPayProcessing) {
        addNewAddressView.popToVC = self.confirmOrderVC;
    }
    [self.navigationController pushViewController:addNewAddressView animated:YES];
}

- (void)needUpdate
{
    _needUpdate = YES;
}

#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 40;
    
    BYAddressCell *cell = (BYAddressCell *)self.prototypeCell;
    BYAddress* data =self.addressList[[indexPath section]];
//    cell.t.text = [self.tableData objectAtIndex:indexPath.row];
    cell.receiverLabel.text = [NSString stringWithFormat:@"%@    %@", data.receiver, data.phone];
    if ([data.cityName isEqualToString:@"市辖区"]||[data.cityName isEqualToString:@"县"]) {
        data.cityName = @"";
    }
    NSString* address = [NSString stringWithFormat:@"%@%@%@\n%@", data.provinceName, data.cityName, data.areaName, data.address];
    CGSize size = [address sizeWithFont:Font(12) maxSize:CGSizeMake(cell.width - 24, 1000)];
    cell.addressLabel.height = size.height;
    cell.addressLabel.text = address;
    CGSize newSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + newSize.height;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}
- (UIView*)tableView:(UITableView*)tableView
    viewForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 12)];
//    }
    UIView*view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 12)];
    return view;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    return view;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.addressList.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    BYAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    BYAddress* addressData = self.addressList[[indexPath section]];
    [cell update:addressData];
    return cell;
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    BYAddress* addressData = self.addressList[[indexPath section]];
    if (_inPayProcessing) {
        if (_selectBlock) {
            _selectBlock(addressData);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        BYAddressDetailVC2* detailView = [[BYAddressDetailVC2 alloc] init];
        detailView.address = addressData;
        detailView.orderService = self.orderService;
        detailView.isEditMode = YES;
        detailView.delegate = self;
        [self.navigationController pushViewController:detailView animated:YES];
    }
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [MBProgressHUD topShow:@"删除中..."];
        BYAddress* addressData = self.addressList[[indexPath section]];
        [_addressService deleteAddressByAddressId:addressData.addressId finish:^(BOOL success, BYError* error) {
            if(success){
                [MBProgressHUD topShowTmpMessage:@"删除成功"];
                [self updateData];
            }else{
                alertError(error);
            }
        }];
    }
}

@end
