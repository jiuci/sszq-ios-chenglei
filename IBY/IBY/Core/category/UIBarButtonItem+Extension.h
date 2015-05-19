//
//  UIBarButtonItem+Extension.h
//  IBY
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 coco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYBarButtonItem.h"

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem*)barItemWithImgName:(NSString*)imageName
                           highImgName:(NSString*)highImageName
                                target:(id)target
                                action:(SEL)action;

+ (UIBarButtonItem*)barItemWithImgName:(NSString*)imageName
                           highImgName:(NSString*)highImageName
                               handler:(void (^)(id sender))handler;

+ (BYBarButtonItem*)barItemWithTitle:(NSString*)title
                             handler:(void (^)(id sender))handler;

+ (UIBarButtonItem*)barItemWithTitle:(NSString*)title
                              target:(id)target
                                 sel:(SEL)selector;

#pragma mark -

+ (UIBarButtonItem*)backBarItem:(void (^)(id sender))handler;

+ (UIBarButtonItem*)moreBarItem:(void (^)(id sender))handler;

+ (UIBarButtonItem*)emptyBarItem;

@end
