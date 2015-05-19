//
//  BYTabBarVC.m
//  IBY
//
//  Created by coco on 14-9-11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYTabBarVC.h"
#import "BYNavVC.h"

@interface BYTabBarVC () <UITabBarControllerDelegate>
@property (nonatomic, strong) BYNavVC* bookNav;
@end

@implementation BYTabBarVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.delegate = self;

    self.tabBar.translucent = YES;
    self.tabBar.backgroundColor = BYColorClear;

    self.tabBar.backgroundImage = [[UIImage imageNamed:@"bg_tabbar"] resizableImage];
    //    [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage imageNamed:@"bg_tab"] resizableImage]];

    [self setupViewControllers];
}

- (UIViewController*)currentVC
{
    UIViewController* topVC = [(BYNavVC*)self.selectedViewController topViewController];

    if (topVC.presentedViewController) {
        return topVC.presentedViewController;
    }
    else {
        return topVC;
    }
}

- (BOOL)tabBarController:(BYTabBarVC*)tabBarController shouldSelectViewController:(UIViewController*)viewController
{
    if (viewController == self.bookNav && ![BYAppCenter sharedAppCenter].isLogin) {
        [[BYAppCenter sharedAppCenter] runAfterLoginFromVC:tabBarController.currentVC withBlk:^{
            [[BYPortalCenter sharedPortalCenter]portTo:BYPortalBook];
        }];
        return NO;
    }
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - NJTabBarDelegate
- (void)tabBarDidSelectBtnFrom:(NSInteger)from to:(NSInteger)to
{
    // 切换子控制器
    self.selectedIndex = to;
}

#pragma mark -私有方法

- (void)setupViewControllers
{
    _homeVC = [[BYHomeVC alloc] init];
    [self addChlildVc:_homeVC tabbarTitle:@"主页" navTitle:@"" icon:@"icon_home" highlightIcon:@"icon_home_highlight"];

    _cartVC = [[BYWebCartVC alloc] init];
    [self addChlildVc:_cartVC tabbarTitle:@"购物车" navTitle:@"购物车" icon:@"icon_cart" highlightIcon:@"icon_cart_highlight"];

    _bookVC = [[BYBookVC alloc] init];
    _bookNav = [self addChlildVc:_bookVC tabbarTitle:@"我的预约" navTitle:@"我的预约" icon:@"icon_book" highlightIcon:@"icon_book_highlight"];

    _mineVC = [[BYMineVC alloc] init];
    [self addChlildVc:_mineVC tabbarTitle:@"我的必要" navTitle:@"我的必要" icon:@"icon_mine" highlightIcon:@"icon_mine_highlight"];
}

- (BYNavVC*)addChlildVc:(UIViewController*)childVc
            tabbarTitle:(NSString*)title
               navTitle:(NSString*)navigationTitle
                   icon:(NSString*)iconName
          highlightIcon:(NSString*)highlightIconName
{
    BYNavVC* nav = [BYNavVC nav:childVc title:navigationTitle];
    UIImage* normalImage = [[UIImage imageNamed:iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    UIImage* selectImage = [[UIImage imageNamed:iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage* selectImage = [[UIImage imageNamed:highlightIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem* baritem = [[UITabBarItem alloc] initWithTitle:title
                                                          image:normalImage
                                                  selectedImage:selectImage];

    [baritem setTitleTextAttributes:@{
        NSForegroundColorAttributeName : BYColorb768,
        NSFontAttributeName : Font(12)
    }
                           forState:UIControlStateSelected];

    [baritem setTitleTextAttributes:@{ NSForegroundColorAttributeName : BYColor333,
                                       NSFontAttributeName : Font(12)
    }
                           forState:UIControlStateNormal];

    baritem.titlePositionAdjustment = UIOffsetMake(0, -4);
    baritem.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);

    childVc.tabBarItem = baritem;

    [self addChildViewController:nav];

    return nav;
}

@end
