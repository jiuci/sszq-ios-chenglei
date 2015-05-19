//
//  BYInvoice.h
//  IBY
//
//  Created by St on 15/1/20.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYInvoice : NSObject

@property (nonatomic, assign) BOOL isNeedInvoice;
@property (nonatomic, assign) int invoice_type;
@property (nonatomic, strong) NSString* invoice_title_val;

- (void)updateWIthIsNeedInvoice:(BOOL)isNeedInvoice invoice_type:(BOOL)invoice_type invoice_title_val:(NSString*)invoice_title_val;

@end
