//
//  DEMOMenuViewController.h
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "BYHomeVC.h"
#import "BYHomeInfo.h"
#import "BYHomeNavInfo.h"
#import "RESideMenu.h"
@interface BYLeftMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) BYHomeInfo * info;
@property (nonatomic, strong) BYHomeNavInfo *simpleNavInfo;
@property (nonatomic, strong) BYHomeInfoSimple *simpleInfo;
@property (nonatomic, assign) BOOL isLoading;
@property (strong, nonatomic) RESideMenu *reSideMenu;
@property (strong, nonatomic) BYHomeVC *homeVC;

//-(void)reloadNavData;
@end
