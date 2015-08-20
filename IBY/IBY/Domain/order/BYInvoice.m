//
//  BYInvoice.m
//  IBY
//
//  Created by St on 15/1/20.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYInvoice.h"

@implementation BYInvoice

- (void)updateWIthIsNeedInvoice:(BOOL)isNeedInvoice invoice_type:(BOOL)invoice_type invoice_title_val:(NSString*)invoice_title_val
{
    _isNeedInvoice = isNeedInvoice;
    _invoice_title_val = invoice_title_val;
    _invoice_type = invoice_type;
}

@end
