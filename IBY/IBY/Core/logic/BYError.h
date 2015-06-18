//
//  BYError.h
//  IBY
//
//  Created by panShiyu on 14-9-10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

//API返回的错误码
typedef enum {
    BYNetErrorNetFail = 901,
    BYNetErrorNetExpired = 902,
    BYNetErrorDomainWrongFormat = 903,
    BYNetErrorTokenInvalid = 200000,
    BYNetErrorNotExist = 200006,
} BYNetError;

//自定义的错误码
typedef enum {
    BYFuErrorCannotUnknow = 0,
    BYFuErrorInvalidParameter = 10000,//发送API请求之前，参数错误
    BYFuErrorCannotDecode = 100001,//解码失败
    BYFuErrorCannotSerialized = 100003,//序列化成对应的数据结构失败，有可能是某个字段不合法
    BYFuErrorCannotRunAPI = 100004,//由于部分条件不符合，API请求不可发送
}BYFuError;

@interface BYError : NSError

@property (nonatomic, assign) int byErrorCode;
@property (nonatomic, copy)NSString *byErrorMsg;
@property (nonatomic,copy)NSString *byDomain;

- (NSString*)netMessage;
- (NSString*)msgWithPlaceholder:(NSString*)defaultMessage;

@end

//以原有的error为基准，自定义error
extern BYError* makeCustomError(BYFuError type,NSString* domain,NSString *desc,NSError*originError);

//解析不合法的error
extern BYError* makeNetDecodeError(BYError* err);

//把一个通用的NSError转化成BYError
extern BYError* makeNetError(NSError* e);

//把一个map转化成对应的error
extern BYError* makeTransferNetError(NSDictionary* eDict);
