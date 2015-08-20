//
//  BYModel.h
//  IBY
//
//  Created by St on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYModel : BYBaseDomain

@property (nonatomic, assign) int category_tree_id;
@property (nonatomic, assign) BOOL isUsed;
@property (nonatomic, assign) int model_id;
@property (nonatomic, assign) int model_part_id; //哪个部件，用来标识  鞋底、饰品等
@property (nonatomic, assign) int model_style;
@property (nonatomic, assign) int parent_id;
@property (nonatomic, assign) int model_category_id;
@property (nonatomic, assign) float model_price;
@property (nonatomic, copy) NSString* model_image_url;
@property (nonatomic, copy) NSString* descriptionUrl;
@property (nonatomic, copy) NSString* model_name;
@property (nonatomic, strong) NSMutableArray* componentList; //面的列表
@property (nonatomic, strong) NSArray* childModelList; //拼插，双重list，比如此model是衬衫，里面有一个口袋list和一个拉链list
@property (nonatomic, strong) NSArray* usedChildModelList; //拼插，双重list，比如此model是衬衫，里面有一个口袋list和一个拉链list
@property (nonatomic, strong) BYModel* parentModel;
//@property (nonatomic, assign) int supplier_id;//商家的ID

- (NSArray*)displayComponentList; //用于展示的面的列表，过滤了不可用的面

@end
