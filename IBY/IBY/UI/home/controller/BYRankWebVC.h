//
//  BYRankWebVC.h
//  IBY
//
//  Created by chenglei on 15/12/2.
//  Copyright © 2015年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"
#import "BYMutiSwitch.h"


@interface BYRankWebVC : BYBaseVC

@property (nonatomic, strong) BYMutiSwitch *mutiSwitch;

+ (instancetype)sharedRankWebVC;



@end
