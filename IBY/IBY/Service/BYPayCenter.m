//
//  BYPayCenter.m
//  IBY
//
//  Created by panshiyu on 15/1/28.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYPayCenter.h"

#import <AlipaySDK/AlipaySDK.h>

#import "BYPaySuccessVC.h"
#import "BYPayFailVC.h"
#import "BYPayUnknowVC.h"

#import "BYWebPayVC.h"

#import "CommonUtil.h"
#import "CommonFunc.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface BYPayCenter () <BYWebPayDelegate>

@property (nonatomic, strong) BYPayService* payService;

@property (nonatomic, weak) UIViewController* fromVC;
@property (nonatomic, assign) BOOL hasGotPayResult;

@end

static int retryTimes;

@implementation BYPayCenter

+ (instancetype)payCenter
{
    static BYPayCenter* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _payService = [[BYPayService alloc] init];
    }

    return self;
}

- (void)payByPrepareInfo:(BYPayPrepareInfo*)info
                  method:(BYPayMethod)method
                  fromVC:(UIViewController*)fromVC
{
    _fromVC = fromVC;
    _preInfo = info;
    _payMethod = method;

    NSString* IPstr = [CommonUtil getIPAddress:YES];
    [MBProgressHUD topShow:@"请求支付中"];
    
    [_payService fetchPayDataWithOrderpaycode:_preInfo.mergeOrderId totalprice:_preInfo.totalPrice paytype:method ip:IPstr bankType:0 finish:^(NSDictionary* data, BYError* error) {
        if(error || !data){
            alertError(error);
        }else{
            [MBProgressHUD topHide];
            
            _hasGotPayResult = NO;
            
            switch (method) {
                case BYPayMethodZhifubao:{
                    [[AlipaySDK defaultService] payOrder:data[@"orderStr"] fromScheme:BYAPP_SCHEMA callback:^(NSDictionary *resultDic) {
                        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                            [self preCheckPayStatus];
                        }
                    }];
                }
                    break;
                case BYPayMethodCaifutong:{
                    _preInfo.tokenId = data[@"token_id"];
                    _preInfo.callBackUrl = data[@"callbackurl"];
                    
                    NSString *urlString = [NSString stringWithFormat:@"https://www.tenpay.com/app/mpay/mp_gate.cgi?token_id=%@",_preInfo.tokenId];
                    
                    BYWebPayVC *caifutongView = [[BYWebPayVC alloc] initWithURL:[NSURL URLWithString:urlString]];
                    caifutongView.webPayDelegate = self;
                    caifutongView.navigationItem.title = @"财付通支付";
                    [_fromVC.navigationController pushViewController:caifutongView animated:YES];
                }
                    break;
                case BYPayMethodWeixin:{
                    
                    //调用微信支付
                    PayReq *payRequest = [[PayReq alloc] init];
                    payRequest.partnerId = data[@"partnerid"];
                    payRequest.prepayId = data[@"prepayid"];
                    payRequest.package = data[@"package"];
                    payRequest.nonceStr = data[@"noncestr"];
                    
//                    NSNumber *timeNum = data[@"timestamp"];
//                    UInt32 time = (UInt32)[timeNum longLongValue];
//                    UInt32 time = [timeNum intValue];
                    
                    NSNumber *timeNum = data[@"timestamp"];
                    UInt32 time = [timeNum unsignedIntValue];
                    
                    payRequest.timeStamp = time;
                    payRequest.sign = data[@"sign"];
                    
                    //TODO: 微信支付需要测试
                    [WXApi sendReq:payRequest];
                    
                }
                default:
                    break;
            }
        }
    }];
}

- (void)didWebPayFinished
{
    [self preCheckPayStatus];
}

#pragma mark -

- (void)preCheckPayStatus
{
    if (_hasGotPayResult) {
        return;
    }
    
    _hasGotPayResult = YES;

    [MBProgressHUD topShow:@"检查支付结果中"];
    
    BYLog(@"---开始检查支付");

    retryTimes = 4;
    NSString* decodeMergeId = [CommonFunc textFromBase64String:_preInfo.mergeOrderId];
    [self checkPayStatusWithDecodeMergeId:decodeMergeId];
}

- (void)checkPayStatusWithDecodeMergeId:(NSString*)decodeMergeId
{
    [_payService getPayStatusWithpaycode:decodeMergeId finish:^(BYPayStatus status, BYError* error) {
        
        BYLog(@"---检查支付中 %d",retryTimes);
        retryTimes --;
        
        
        if (!error && status == BYPayStatusSuccess) {
            [self goSuccessPage];
        }
        else if (!error && status == BYPayStatusFail) {
            [self goFailPage];
        }
        else if(retryTimes > 0) {
            BYLog(@"---检查没成，再来一次 %d",retryTimes);
            
            runBlockAfterDelay(3, ^{
                [self checkPayStatusWithDecodeMergeId:decodeMergeId];
            });
        }else{
            BYLog(@"---检查出问题 %d",retryTimes);
            
            [self goUnknowPage];
        }
    }];
}

- (void)goUnknowPage
{
    [MBProgressHUD topHide];
    BYPayUnknowVC* payFailVC = [[BYPayUnknowVC alloc] initWithResult:_preInfo];
    [self.fromVC.navigationController pushViewController:payFailVC animated:YES];
}

- (void)goSuccessPage
{
    [MBProgressHUD topHide];
    BYPaySuccessVC* paySuccessVC = [[BYPaySuccessVC alloc] initWithResult:_preInfo];
    [self.fromVC.navigationController pushViewController:paySuccessVC animated:YES];
}

- (void)goFailPage
{
    [MBProgressHUD topHide];
    BYPayFailVC* payFailVC = [[BYPayFailVC alloc] initWithResult:_preInfo];
    [self.fromVC.navigationController pushViewController:payFailVC animated:YES];
}

#pragma mark - test

- (NSString*)generateTradeNO
{
    static int kNumber = 15;

    NSString* sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString* resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString* oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
