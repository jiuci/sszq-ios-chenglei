//
//  WeixinEngine.h
//  SAKShareKit
//
//  Created by psy on 14-1-2.
//  Copyright (c) 2014年 psy. All rights reserved.
//

#import "SAKPipeBase.h"
#import "WXApi.h"

@interface SAKPipeWeixin : SAKPipeBase<WXApiDelegate> {
    BOOL _isOpenFromWeixin;
}

@property (nonatomic, assign) BOOL isOpenFromWeixin;
@property (nonatomic, assign) BOOL gotResponse;

@end
