//
//  BYTextField.h
//  IBY
//
//  Created by panshiyu on 14/12/30.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets insets;

//@property (nonatomic, assign) BOOL autoToNextField;
@property (nonatomic, assign) BOOL autoFocusWhenEditing;//default is YES,如无须，请手动设置为NO

@end

BYTextField* makeDefaultTextField(NSString* placeholder, UIFont* font, UIColor* color, NSString* bgIcon);
