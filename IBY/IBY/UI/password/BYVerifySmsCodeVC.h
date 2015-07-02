//
//  BYEVerifycodeodeViewController.h
//  IBY
//
//  Created by coco on 14-9-11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYVerifySmsCodeVC : BYBaseVC<UITextFieldDelegate>
@property (strong, nonatomic) NSString* phone;
@property (nonatomic, copy) NSString* titleFromLastPage;
@end
