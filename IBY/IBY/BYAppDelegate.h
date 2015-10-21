//
//  BYAppDelegate.h
//  IBY
//
//  Created by pan Shiyu on 14-8-26.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYTabBarVC;
@class BYNavVC;
@class BYHomeVC;
@class BYLoginVC;
@class RESideMenu;
@interface BYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;
@property (strong, nonatomic) BYNavVC* homeNav;
@property (strong, nonatomic) BYHomeVC* homeVC;
@property (strong, nonatomic) NSString* activeVC;
@property (strong, nonatomic) RESideMenu* reSideMenu;
@end
