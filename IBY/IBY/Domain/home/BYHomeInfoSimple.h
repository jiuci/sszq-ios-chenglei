//
//  BYHomeInfoSimple.h
//  IBY
//
//  Created by kangjian on 15/8/19.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYHomeInfoSimple : NSObject
@property(nonatomic, strong)NSString * imagePath;
@property(nonatomic, strong)NSString * link;
@property(nonatomic, strong)NSString * title;
@property(nonatomic, assign)int categoryID;
@property(nonatomic, assign)int type;
@property(nonatomic, assign)int height;
@property(nonatomic, assign)int width;

- (BOOL)isValid;
@end
