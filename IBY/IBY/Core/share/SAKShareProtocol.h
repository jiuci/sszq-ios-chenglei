//
//  SAKShareProtocol.h
//  SAKShareKit
//
//  Created by psy on 13-12-30.
//  Copyright (c) 2013年 psy. All rights reserved.
//

typedef enum {
    //oauth2
    SAKShareMediaSinaWeibo = 1 << 0,
    SAKShareMediaQzone = 1 << 1,
    SAKShareMediaQQWeibo = 1 << 2,
    //app
    SAKShareMediaSMS = 1 << 3,
    SAKShareMediaWeixin = 1 << 4,
    SAKShareMediaWeixinFriends = 1 << 5,
    SAKShareMediaQQClient = 1 << 6,
    SAKShareMediaAll = ~0,
} SAKShareMedia;

typedef enum {
    SAKShareMediaAvailable,
    SAKShareMediaNotAvailable,
    SAKShareMediaCanNotShare,
} SAKShareMediaAvailability;

#define kSAKShareErrorDomain @"SAKShareErrorDomain"

enum SAKShareErrorCode {
    SAKShareErrorCancelled,
    SAKShareErrorUnknown,
    SAKOAuth2ErrorNetworkError,
};

//分享单元信息
@protocol SAKSharerProcotol <NSObject>
@property (nonatomic, assign) SAKShareMedia shareMedia;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, copy) NSString* detailURLString;
@property (nonatomic, strong) UIImage* thumbImage;
@property (nonatomic, copy) NSString* thumbURL;
@property (nonatomic, copy) NSString* summary; //qzone专用

@end

typedef void (^SAKWillShareBlock)();
typedef void (^SAKDidShareBlock)(NSError* error);

@protocol SAKShareMediaProtocol <NSObject>
- (SAKShareMediaAvailability)isAvailable;
- (void)share:(id<SAKSharerProcotol>)sharer from:(UIViewController*)fromVC willShare:(SAKWillShareBlock)willBlock didShare:(SAKDidShareBlock)finishBlock;
@optional
- (void)handleOpenURL:(NSURL*)url didShare:(SAKDidShareBlock)finishBlock;
@end
