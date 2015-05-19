//
//  BYPayUnknowVC.m
//  IBY
//
//  Created by panshiyu on 14/12/31.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYPayUnknowVC.h"
#import "BYPayFailVC.h"
#import "CommonFunc.h"
#import "BYPayService.h"
#import "BYPaySuccessVC.h"

@interface BYPayUnknowVC ()

@end

@implementation BYPayUnknowVC {
    BYPayPrepareInfo* _payResult;
    BYPayService* _payService;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.navigationItem.leftBarButtonItem = [BYBarButtonItem emptyBarItem];
    self.navigationItem.title = @"在线支付";
    _payService = [[BYPayService alloc] init];
}

- (id)initWithResult:(BYPayPrepareInfo*)payResult
{
    self = [super init];
    if (self) {
        _payResult = payResult;
    }
    return self;
}

- (IBAction)onRefreshPayStatus:(id)sender
{
    [self checkPayStatus];
}

- (IBAction)onReviewlater:(id)sender
{
    [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome params:nil];
    
}

- (void)checkPayStatus
{
    BYLog(@"getOrderPaymentStatus");

    [MBProgressHUD topShow:@"检查支付结果中"];
    NSString* decodeMergeId = [CommonFunc textFromBase64String:_payResult.mergeOrderId];
    runBlockAfterDelay(5, ^{
        [_payService getPayStatusWithpaycode:decodeMergeId finish:^(BYPayStatus status, BYError* error) {
            [MBProgressHUD topHide];
            
            if (error) {
                [UIAlertView bk_alertViewWithTitle:@"当前暂无网络，请稍后重试"];
                return ;
            }
            
            switch (status) {
                case BYPayStatusSuccess:{
                    BYPaySuccessVC* paySuccessVC = [[BYPaySuccessVC alloc] initWithResult:_payResult];
                    [self.navigationController pushViewController:paySuccessVC animated:YES];
                }
                    
                    break;
                case BYPayStatusFail:{
                    BYPayFailVC *payFailVC = [[BYPayFailVC alloc]initWithResult:_payResult];
                    [self.navigationController pushViewController:payFailVC animated:YES];
                }
                    
                    break;
                case BYPayStatusUnpay:
                    
                    break;
                default:
                    break;
            }
            
        }];
    });
}

@end
