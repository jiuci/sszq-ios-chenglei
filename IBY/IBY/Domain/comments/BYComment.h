//
//  BYComment.h
//  IBY
//
//  Created by panshiyu on 14/11/11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYComment : NSObject

@property (nonatomic, strong) NSString* comment;
@property (nonatomic, assign) int comment_id; //评论id
@property (nonatomic, strong) NSNumber* rating; //评分
@property (nonatomic, strong) NSString* reply_comment; //评论内容
@property (nonatomic, strong) NSString* create_time; //发布时间
@property (nonatomic, strong) NSString* avatar_url; //用户头像
@property (nonatomic, strong) NSString* nickname; //用户昵称
@property (nonatomic, strong) NSString* sizdeName; //尺码信息
@end
