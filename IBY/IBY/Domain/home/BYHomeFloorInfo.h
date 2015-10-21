//
//  BYHomeFloorInfo.h
//  IBY
//
//  Created by 张经兰 on 15/10/21.
//  Copyright © 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYHomeFloorInfo : NSObject
@property(nonatomic, copy)NSString * title;
@property(nonatomic, copy)NSString * subtitle;
@property(nonatomic, copy)NSString * imgtitle;
@property(nonatomic, copy)NSString * adname;

@property(nonatomic, assign)int floor;
@property(nonatomic, strong)NSArray * adsArray;

@end
