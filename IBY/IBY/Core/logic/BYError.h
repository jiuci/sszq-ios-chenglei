//
//  BYError.h
//  IBY
//
//  Created by panShiyu on 14-9-10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BYErrorTypeNetFail = 901,
    BYErrorTypeNetExpired = 902,
    BYErrorTypeDomainWrongFormat = 903,
    BYErrorTypeTokenInvalid = 200000,
    BYErrorTypeNotExist = 200006,

} BYErrorType;

//enum {
//    BYNetworkErrorUnknown,
//    BYNetworkErrorCancelled,
//    BYNetworkErrorHTTP3xxError,
//    BYNetworkErrorHTTP4xxError,
//    BYNetworkErrorHTTP5xxError,
//    BYNetworkErrorCannotDecodeContentData
//};

/*
 * @[@"未知错误",
 * @"操作取消",
 * @"HTTP-重定向",
 * @"HTTP-请求的资源出错",
 * @"HTTP-服务器错误",
 * @"无法连接网络"]
 */

@interface BYError : NSError

@property (nonatomic, assign) int byErrorCode;

- (NSString*)msgWithDefault:(NSString*)des;

@end
