//
//  BYDesign.h
//  IBY
//
//  Created by coco on 14-9-11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYBaseDomain.h"
#import "BYBookTurnInfo.h"
@class BYEditingData;
@class BYModel;

@interface BYDesign : BYBaseDomain

@property (nonatomic, assign) int designId;
@property (nonatomic, assign) int productionTime;
@property (nonatomic, copy) NSString* designName;
@property (nonatomic, copy) NSString* createTime;
@property (nonatomic, assign) int categoryId;
@property (nonatomic, copy) NSString* categoryName;
@property (nonatomic, assign) int designCategoryId;
@property (nonatomic, assign) int styleId;

@property (nonatomic, strong) BYBookTurnInfo* bookTurnInfo;

@property (nonatomic, copy) NSString* designDetails; //图文详情的 链接

@property (nonatomic, assign) int customerId;
@property (nonatomic, copy) NSString* desc;

@property (nonatomic, strong) NSNumber* price;

@property (nonatomic, copy) NSString* imageUrl;

@property (nonatomic, assign) int supplier_id; //商家的ID
//详细信息
@property (nonatomic, strong) NSArray* sizeList;
@property (nonatomic, strong) NSDictionary* displaySizeMap;
@property (nonatomic, strong) NSArray* refDesignList;
//@property (nonatomic, strong) NSDictionary *modelInfo;
@property (nonatomic, strong) BYModel* modelInfo;
//  显示图片的信息
@property (nonatomic, strong) NSMutableArray* cutImgUrls; //显示图片的信息

//商家服务
@property (nonatomic, strong) NSArray* policyArray;

//我的作品集使用
- (id)initWithMyDesignDict:(NSDictionary*)dict;

//更新详细信息使用
- (void)updateDetails:(NSDictionary*)dict;

@end

@interface BYDesignSize : NSObject
@property (nonatomic, assign) int sizeId;
@property (nonatomic, copy) NSString* goods_size;
@property (nonatomic, copy) NSString* sizeName;

@end
