//
//  BYPushCenter.m
//  IBY
//
//  Created by panshiyu on 15/2/15.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYPushCenter.h"
#import "BYPushUnit.h"

@implementation BYPushCenter

+ (instancetype)sharedPushCenter
{
    static BYPushCenter* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)handleRemoteInfoWithApplication:(UIApplication*)application userinfo:(NSDictionary*)userInfo
{
    BYPushUnit* unit = [BYPushUnit unitWithRemoteInfo:userInfo];
    if (!unit) {
        return;
    }

    //所有的数据监测在pushCenter内部就做完，让portal可以放心大胆的用
    if (application.applicationState == UIApplicationStateInactive) {
        //opened from a push notification when the app was on background
        switch (unit.type) {
        case BYPushTypeDesignDetail: {
            if (unit.pushParams[@"did"]) {
                NSString* designDetailUrl = [NSString stringWithFormat:@"%@%d",BYURL_M_DetailDesign,[unit.pushParams[@"did"] intValue]];
                NSDictionary* params = @{@"JumpURL":designDetailUrl};
                [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome params:params];
//                [[BYPortalCenter sharedPortalCenter] portTo:BYPortalDesignDetail params:unit.pushParams];
            }
        } break;
        case BYPushTypeMWeb: {
            if (unit.pushParams[@"url"]) {
                NSDictionary* params = @{@"JumpURL":unit.pushParams[@"url"]};
                [[BYPortalCenter sharedPortalCenter] portTo:BYPortalHome params:params];
            }
        } break;
        default:
            break;
        }
    }
    else if (application.applicationState == UIApplicationStateActive) {
        // a push notification when the app is running. So that you can display an alert and push in any view
        if (unit.message) {
            alertPushSimplely(unit.message);
        }
    }
}

@end
