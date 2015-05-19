//
//  BYComponent.h
//  IBY
//
//  Created by St on 14/11/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYMaterial;
@interface BYComponent : NSObject

@property (nonatomic, assign) int component_id;
@property (nonatomic, assign) int model_id;
@property (nonatomic, assign) int component_order;
@property (nonatomic, assign) int component_type;
@property (nonatomic, assign) int component_status;
@property (nonatomic, copy) NSString* component_name; //面替换，用这个
@property (nonatomic, copy) NSString* customname; //用户自定义的面的信息

@property (nonatomic, strong) NSMutableArray* materialList; //绑定的材料列表
@property (nonatomic, strong) BYMaterial* usedMaterial; //选中的材料

//public ArrayList<ComponentCraft>craftList=new ArrayList<ComponentCraft>();//签字工艺列表
//public ArrayList<ComponentMask>maskList=new ArrayList<ComponentMask>();//蒙版列表
//public ArrayList<ComponentPaintConfig>paintConfigList=new ArrayList<ComponentPaintConfig>();
////签名贴图配置列表
////哪里搞了签名
//public ArrayList<SignMapInfo>signMapInfoList=new ArrayList<SignMapInfo>();//签名贴图信息列表

-(NSArray*)displayMaterialList;

@end
