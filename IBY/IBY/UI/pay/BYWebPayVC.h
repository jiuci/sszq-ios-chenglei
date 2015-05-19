//
//  BYCaifutongVC.h
//  IBY
//
//  Created by St on 14/11/28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseWebVC.h"

@protocol BYWebPayDelegate <NSObject>

- (void)didWebPayFinished;

@end

@interface BYWebPayVC : BYBaseWebVC
@property (nonatomic, weak) id<BYWebPayDelegate> webPayDelegate;
@end
