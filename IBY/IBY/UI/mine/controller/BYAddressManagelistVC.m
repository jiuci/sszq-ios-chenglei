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

static NSString* cellID = @"BYAddressCell";

@interface BYAddressManagelistVC () <BYAddressDetailDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView* addressTableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) NSMutableArray* addressList;

@end

@implementation BYAddressManagelistVC {
    BYAddressService* _addressService;
    BOOL _needUpdate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"地址管理";

    _addressService = [[BYAddressService alloc] init];
    _addressList = [NSMutableArray array];

    self.addressTableView.delegate = self;
    self.addressTableView.dataSource = self;
    self.addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.addressTableView.sectionFooterHeight = 12;
    
    [_addButton setImage:[[UIImage imageNamed:@"icon_addaddress"] resizableImage] forState:UIControlStateNormal];
    [_addButton setImageEdgeInsets:UIEdgeInsetsMake(9, 90, 9, 90)];
    [_addButton setTitle:@"添加新地址" forState:UIControlStateNormal];
    

    UINib* nib = [UINib nibWithNibName:@"BYAddressCell" bundle:nil];
    [self.addressTableView registerNib:nib forCellReuseIdentifier:cellID];

    _needUpdate = YES;

    self.tipsTopPadding = 70;
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
    [MBProgressHUD topShow:@""];
    [_addressService fetchAddressList:^(NSArray* addressList, BYError* error) {
        [MBProgressHUD topHide];
        if(error){
            [self showPoolnetworkView];
        }else{
            if(!addressList || addressList.count == 0){
                [self.addressList removeAllObjects];
                [self updateUI];
                [self showTipsView:@"您还没有设置地址信息" icon:nil];
            }else{
                [self.addressList removeAllObjects];
                [self.addressList addObjectsFromArray:addressList];
                [self updateUI];
            }
            
        }
    }];
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

- (UIView*)tableView:(UITableView*)tableView
    viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 12)];
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
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

//- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    return 90;
//}

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

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BYAddress* addressData = self.addressList[[indexPath section]];
        [_addressService deleteAddressByAddressId:addressData.addressId finish:^(BYError* error) {
            if(error){
                [MBProgressHUD topShowTmpMessage:@"删除失败"];
            }else{
                [MBProgressHUD topShowTmpMessage:@"删除成功"];
                [self updateData];
            }
        }];
    }
}

@end
