//
//  BYPayVC.m
//  IBY
//
//  Created by St on 14/11/27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYPayVC.h"
#import "IPAdress.h"
#import "BYPayService.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "CommonFunc.h"
#import "BYPaySuccessVC.h"
#import "BYPayFailVC.h"
#import "BYPayUnknowVC.h"
#import "CommonUtil.h"
#import "TTTAttributedLabel.h"

#import "BYPayCenter.h"
#import <AlipaySDK/AlipaySDK.h>

static NSString* cellId = @"BYPayApproachCell";

@interface BYPayVC () <WXApiDelegate>

@property (weak, nonatomic) IBOutlet UILabel* amountLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel* addressLabel;

@property (weak, nonatomic) IBOutlet UIView* detailView;

@property (nonatomic, strong) NSString* orderId;
@property (nonatomic, strong) BYPayService* payService;
@property (nonatomic, strong) BYPayPrepareInfo* payResult;

@end

@implementation BYPayVC
- (id)initWithOrderId:(NSString*)orderId //这里的orderId是 base64位加密 后的id
{
    self = [super init];
    if (self) {
        _orderId = orderId;
        _payService = [[BYPayService alloc] init];
        _payResult = [[BYPayPrepareInfo alloc] init];
        _payResult.orderId = [CommonFunc textFromBase64String:orderId];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"在线支付";

    _addressLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    [self updatePrePayData];
    
}

// 获取预支付相关数据
- (void)updatePrePayData
{
    [_payService fetchPayCodeWithOrderId:_orderId finish:^(BYPayPrepareInfo* result, BYError* error) {
        if(error || !result){
            [MBProgressHUD topShowTmpMessage:@"请求结算出现错误"];
        }else{
            _payResult = result;
            _payResult.orderId = [CommonFunc textFromBase64String:_orderId];
        }
        [self updateUI];
    }];
}

- (void)updateUI
{
    _amountLabel.text = [@(_payResult.totalPrice) rmbString];
    if (_payResult) {
        _addressLabel.text = [NSString stringWithFormat:@"%@  %@  %@", _payResult.receiverName, _payResult.receiverPhoneNumber, _payResult.receiverAddress];
    }
    else {
        _addressLabel.text = nil;
    }
    //    NSString* nameAndPhoneStr = [NSString stringWithFormat:@"%@  %@", _payResult.receiverName, _payResult.receiverPhoneNumber];
    //    _nameAndPhoneLabel.text = nameAndPhoneStr;

    CGFloat itemTop = _detailView.bottom + 32;

    if ([WXApi isWXAppInstalled]) {
        BYPayTypeCell* weixinCell = [BYPayTypeCell cellWithTitle:@""
                                                            icon:@"icon_pay_weixin"
                                                            desc:@""
                                                          target:self
                                                             sel:@selector(onWeixin)];
        weixinCell.top = itemTop;
        itemTop += weixinCell.height;
        [self.view addSubview:weixinCell];
    }

    BYPayTypeCell* zhifubaoCell = [BYPayTypeCell cellWithTitle:@""
                                                          icon:@"icon_pay_zhifubao"
                                                          desc:@""
                                                        target:self
                                                           sel:@selector(onZhifubao)];

    zhifubaoCell.top = itemTop;
    itemTop += zhifubaoCell.height;
    [self.view addSubview:zhifubaoCell];

    BYPayTypeCell* caifutongCell = [BYPayTypeCell cellWithTitle:@""
                                                           icon:@"icon_pay_caifutong"
                                                           desc:@""
                                                         target:self
                                                            sel:@selector(onCaifutong)];

    caifutongCell.top = itemTop;
    [self.view addSubview:caifutongCell];
}

#pragma mark -

- (void)onZhifubao
{
    [[BYPayCenter payCenter] payByPrepareInfo:_payResult
                                       method:BYPayMethodZhifubao
                                       fromVC:self];
}

- (void)onCaifutong
{
    [[BYPayCenter payCenter] payByPrepareInfo:_payResult
                                       method:BYPayMethodCaifutong
                                       fromVC:self];
}

- (void)onWeixin
{
    [[BYPayCenter payCenter] payByPrepareInfo:_payResult
                                       method:BYPayMethodWeixin
                                       fromVC:self];
    
}

@end

@implementation BYPayTypeCell {
    UIImageView* _iconView;
    UILabel* _titleLabel;
    UILabel* _descLabel;
}

+ (instancetype)cellWithTitle:(NSString*)title
                         icon:(NSString*)icon
                         desc:(NSString*)desc
                       target:(id)target
                          sel:(SEL)selector
{
    BYPayTypeCell* cell = [[self alloc] initWithFrame:BYRectMake(0, 0, SCREEN_WIDTH, 44)];
    [cell addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [cell updateByTitle:title icon:icon desc:desc];
    return cell;
}

- (void)updateByTitle:(NSString*)title
                 icon:(NSString*)icon
                 desc:(NSString*)desc
{
    _iconView.image = [UIImage imageNamed:icon];
    _titleLabel.text = title;
    _descLabel.text = desc;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _iconView = [[UIImageView alloc] initWithFrame:BYRectMake(12, 0, 100, 32)];
        _iconView.centerY = self.height / 2;
        [self addSubview:_iconView];

        _titleLabel = [UILabel labelWithFrame:BYRectMake(_iconView.right + 12, 0, 67, self.height) font:Font(14) andTextColor:BYColor333];
        [self addSubview:_titleLabel];

        _descLabel = [UILabel labelWithFrame:BYRectMake(_titleLabel.right, 0, 200, self.height) font:Font(12) andTextColor:BYColor999];
        [self addSubview:_descLabel];

        self.showRightArrow = YES;
        self.showBottomLine = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
