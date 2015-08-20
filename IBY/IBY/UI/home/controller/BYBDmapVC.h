//
//  BYBDmapVC.h
//  IBY
//
//  Created by kangjian on 15/7/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseVC.h"
#import "BYNavVC.h"
#import <BaiduMapAPI/BMapKit.h>
@interface BYBDmapVC : BYBaseVC<BMKGeneralDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>

@end
BYNavVC* makeMapnav();