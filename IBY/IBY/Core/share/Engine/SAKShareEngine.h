//
//  MTShareEngine.h
//  iMeituan
//
//  Created by psy on 13-7-4.
//  Copyright (c) 2013年 Meituan.com. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SAKShareProtocol.h"
#import "SAKShareConfig.h"

@interface SAKShareEngine : NSObject

//设置配置文件，开启分享模块
+ (void)enableShareWithConfig:(SAKShareConfig *)config;

//是否存在
+ (SAKShareMediaAvailability)isShareMediaAvailable:(SAKShareMedia)shareMedia;

//中文名称
+ (NSString *)shareMediaName:(SAKShareMedia)media;

//获取分享通道
+ (id<SAKShareMediaProtocol> )pipeByMedia:(SAKShareMedia)media;

//是否可以handle住这个url
+ (BOOL)isCapableOfURL:(NSURL *)url;

//处理分享到qq、微信的回调(微信支付也会走这里)
+ (void)handleOpenURL:(NSURL *)url didShare:(SAKDidShareBlock)finishBlock;

//分享某一个media
+ (void)share:(id<SAKSharerProcotol>)sharer
         from:(UIViewController *)fromVC
    willShare:(SAKWillShareBlock)willBlock
     didShare:(SAKDidShareBlock)finishBlock;

@end
