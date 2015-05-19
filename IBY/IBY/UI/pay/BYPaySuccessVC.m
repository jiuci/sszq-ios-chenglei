//
//  BYPaySuccessVC.m
//  IBY
//
//  Created by St on 14/12/1.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYPaySuccessVC.h"
#import "BYPayService.h"
#import "CommonFunc.h"
#import "BYNavVC.h"
#import "BYHomeVC.h"
#import "BYAppDelegate.h"
#import "TTTAttributedLabel.h"

@interface BYPaySuccessVC () {
    __weak IBOutlet UILabel* amountLabel;
    __weak IBOutlet UILabel* nameAndPhoneLabel;
    __weak IBOutlet TTTAttributedLabel* addressLabel;
    BYPayPrepareInfo* _result;
}

@end

@implementation BYPaySuccessVC

- (id)initWithResult:(BYPayPrepareInfo*)payResult
{
    self = [super init];
    if (self) {
        _result = payResult;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationItem.leftBarButtonItem = [BYBarButtonItem emptyBarItem];
    self.navigationItem.title = @"在线支付";
    addressLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    [self updatePayresult];
}

- (IBAction)onOrder:(id)sender
{
//    BYMyOrderDetailVC* orderDetailView = [[BYMyOrderDetailVC alloc] initWithOrderId:_result.orderId];
    //orderDetailView.orderId = _result.orderId;
//    [self.navigationController pushViewController:orderDetailView animated:YES];

    NSString* jumpURL = [NSString stringWithFormat:@"http://m.biyao.com/order/orderdl?orderId=%@",_result.orderId];
    NSDictionary* params = @{@"JumpURL":jumpURL};
    [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome params:params];
}

- (IBAction)onContinueBuy:(id)sender
{
    [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome params:nil];
}

- (void)updatePayresult
{
    amountLabel.text = [@(_result.totalPrice) rmbString];
    NSString* nameAndPhoneStr = [NSString stringWithFormat:@"%@  %@", _result.receiverName, _result.receiverPhoneNumber];
    nameAndPhoneLabel.text = nameAndPhoneStr;
    addressLabel.text = _result.receiverAddress;
}

@end
