//
//  BYCartParams.h
//  IBY
//
//  Created by panshiyu on 14-10-17.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

//designId	是	long	原样例编号	params
//supplierId	是	int	商家编号	params
//modelId	是	int	模型编号	params
//num	是	int	订购数量	params
//payStatus	是	int	购买方式:0加入购物车 1立即购买	params
//sizeName	否	string	尺码	params
//callback	否	string		params
//uid	否	int		header
//token	否	string		header

//dzvist	否	string

//f_code	否	string	F码

//CustomerDesignInfo	是	JSONArray	样例信息(保存样例，且用于)	params

@interface BYCartParamsAdd : NSObject
@property (nonatomic, assign) int designId; //隐患
@property (nonatomic, assign) int supplierId;
@property (nonatomic, assign) int modelId;
@property (nonatomic, assign) int num;
@property (nonatomic, assign) int payStatus; //购买方式 0加入购物车 1立即购买
@property (nonatomic, copy) NSString* sizeName; //同size

@property (nonatomic, copy) NSString* fCode;
@property (nonatomic, copy) NSString* customDesignInfo;

+ (instancetype)defaultCartAddParams;

- (BOOL)isValid;

@end