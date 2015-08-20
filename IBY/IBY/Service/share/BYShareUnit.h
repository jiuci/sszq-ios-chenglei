//
//  SAKShareUnit.h
//  IBY
//
//  Created by panshiyu on 15/1/20.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAKShareKit.h"
@interface BYShareUnit : NSObject<SAKSharerProcotol>

@property (nonatomic, assign) SAKShareMedia shareMedia;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *detailURLString;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, copy) NSString *thumbURL;

@property (nonatomic, copy) NSString *summary;

@property (nonatomic, strong) UIImage *logoImage;

+ (id)shareUnitByMedia:(SAKShareMedia)media
                 title:(NSString *)title
               content:(NSString *)content
             detailURL:(NSString *)detailURL
            thumbImage:(UIImage *)thumbImage
              thumbURL:(NSString *)thumbURL
                  logo:(UIImage *)logoImage;

@end
