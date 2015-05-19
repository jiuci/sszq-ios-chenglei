//
//  BYShareCenter.h
//  IBY
//
//  Created by panshiyu on 15/1/20.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYShareSheet.h"

@class BYDesign;

@interface BYShareCenter : NSObject

+ (instancetype)shareCenter;

- (void)shareDesign:(BYDesign*)design fromVC:(UIViewController*)fromVC;

- (void)shareDesign:(BYDesign*)design title:(NSString*)title desc:(NSString*)desc fromVC:(UIViewController*)fromVC action:(actionBlock)actionBlk;


- (void)shareFromWebBymedia:(int)index
                      title:(NSString*)title
                    content:(NSString*)content
                     imgUrl:(NSString*)imgUrl
                        url:(NSString*)url
                     fromVC:(UIViewController*)fromVC;

@end
