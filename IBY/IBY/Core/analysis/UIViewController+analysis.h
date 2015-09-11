//
//  UIViewController+analysis.h
//  gannicus
//
//  Created by psy on 13-12-11.
//  Copyright (c) 2013年 bbk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (analysis)

@property (nonatomic,readonly) NSString *pageName;
@property (nonatomic,copy) NSMutableDictionary *pageParameter;

@end
