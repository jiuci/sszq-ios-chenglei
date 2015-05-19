//
//  BYPayFailVC.m
//  IBY
//
//  Created by St on 14/12/1.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYPayFailVC.h"
#import "BYPayService.h"
#import "CommonFunc.h"
#import "BYPayVC.h"

@interface BYPayFailVC ()

@end

@implementation BYPayFailVC {
    BYPayPrepareInfo* _result;
}

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
    self.navigationItem.title = @"在线支付";
    //self.navigationItem.leftBarButtonItem = [BYBarButtonItem emptyBarItem];
}

- (IBAction)onOrder:(id)sender
{
//    BYMyOrderDetailVC* orderDetailView = [[BYMyOrderDetailVC alloc] initWithOrderId:_result.orderId];
//    [self.navigationController pushViewController:orderDetailView animated:YES];
    
    NSString* jumpURL = [NSString stringWithFormat:@"http://m.biyao.com/order/orderdl?orderId=%@",_result.orderId];
    NSDictionary* params = @{@"JumpURL":jumpURL};
    [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome params:params];
}

- (IBAction)onRePay:(id)sender
{
    NSString* base64String = [CommonFunc base64StringFromText:_result.orderId];
    BYPayVC* repayVC = [[BYPayVC alloc] initWithOrderId:base64String];
    [self.navigationController pushViewController:repayVC animated:YES];
}

@end
