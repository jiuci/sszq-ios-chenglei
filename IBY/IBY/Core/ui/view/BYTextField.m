//
//  BYTextField.m
//  IBY
//
//  Created by panshiyu on 14/12/30.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYTextField.h"
#import <TPKeyboardAvoidingScrollView.h>

@implementation BYTextField

#pragma mark -

- (UIScrollView*)contentScrollview
{
    UIResponder* next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIScrollView class]]) {
            return (UIScrollView*)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}

#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit
{
    self.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;

    _autoFocusWhenEditing = YES;

    //    __weak BYTextField* wself = self;
    //    self.bk_shouldBeginEditingBlock = ^(UITextField* txtField) {
    //        UIScrollView *contentView = [wself contentScrollview];
    //        if (contentView) {
    //            [contentView TPKeyboardAvoiding_scrollToActiveTextField];
    //        }
    //        return YES;
    //    };
}

#pragma mark - custom bounds

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = CGRectMake(_insets.left, _insets.top, bounds.size.width - _insets.left - _insets.right, bounds.size.height - _insets.top - _insets.bottom);
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = CGRectMake(_insets.left, _insets.top, bounds.size.width - _insets.left - _insets.right, bounds.size.height - _insets.top - _insets.bottom);
    return rect;
}

//- (CGRect)leftViewRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(_leftViewOffsetX, (self.height - self.leftView.height) / 2, self.leftView.width, self.leftView.height);
//}

@end

BYTextField* makeDefaultTextField(NSString* placeholder, UIFont* font, UIColor* color, NSString* bgIcon)
{
    BYTextField* textField = [[BYTextField alloc] init];
    textField.placeholder = placeholder;
    textField.textColor = color;
    textField.font = font;
    if (bgIcon) {
        textField.background = [[UIImage imageNamed:bgIcon] resizableImage];
    }
    
    textField.insets = UIEdgeInsetsMake(0, 7, 0, 7);
    textField.borderStyle = UITextBorderStyleNone;
    return textField;
}
