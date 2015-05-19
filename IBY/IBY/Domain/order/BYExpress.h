//
//  BYExpress.h
//  IBY
//
//  Created by panshiyu on 14/11/28.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYExpress : NSObject

@property (nonatomic,assign)int expressType_id;//快递号
@property (nonatomic,strong)NSString *expresstype_name;//快递名
@property (nonatomic,assign)double nextWeight;
@property (nonatomic,assign)double nextprice;
@property (nonatomic,assign)double price;
@property (nonatomic,assign)int supplierId;
@property (nonatomic,assign)double weight;
@property (nonatomic,assign)double actualExpressTotalPrice;

- (id)initWithDictionary:(NSDictionary *)data;

@end
