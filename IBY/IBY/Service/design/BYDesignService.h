//
//  BYDesignService.h
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"

#define kMASK_WIDTH 800
#define kMASK_HEIGHT 600

@class BYDesign;
@class BYModelTreePoint;
@class BYModel;
@protocol BYDesignServiceDelegate <NSObject>
- (void)updateImageArray;

@end

@interface BYDesignService : BYBaseService

//分享免邮 info
@property (nonatomic, strong) NSDictionary* shareInfo;

//限购信息
@property (nonatomic, assign) BOOL canBuy;
@property (nonatomic, strong) NSDictionary* limitResult;

@property (nonatomic, assign) id<BYDesignServiceDelegate> delegate;
@property (nonatomic, strong) BYDesign* curDesign;

@property (nonatomic, strong) NSMutableArray* perspectiveArray;
@property (nonatomic, strong) NSMutableDictionary* customerDesign;
@property (nonatomic, strong) NSMutableDictionary* customerDesignData;

//主模型、模型 、 面 、材质 、part 、 树
@property (nonatomic, strong) BYModelTreePoint* root;
@property (nonatomic, strong) BYModel* mainModel;
@property (nonatomic, assign) BOOL isComplexDesign; //model_style 1 为普通型  model_style 2 为 拼插型
@property (nonatomic, strong) NSMutableArray* imgUrls;
@property (nonatomic, strong) NSArray* aboveImgUrls;
@property (nonatomic, strong) NSMutableDictionary* modelMap;
@property (nonatomic, strong) NSMutableDictionary* componentMap;
@property (nonatomic, strong) NSMutableDictionary* partMap;
@property (nonatomic, strong) NSMutableDictionary* modelTreeMap;
@property (nonatomic, strong) NSMutableDictionary* designReferenceMap;
@property (nonatomic, strong) NSArray* displayPartlist;
@property (nonatomic, strong) NSMutableArray* subModelList;

//数据关系
@property (nonatomic, strong) NSMutableDictionary* NotShowCompsMap;
@property (nonatomic, strong) NSMutableArray* maskCodeToCompArray;

// 蒙板数组
@property (nonatomic, strong) NSMutableArray* maskArray;
@property (nonatomic, strong) NSString* maskUrlString;
@property (nonatomic, strong) NSString* directoryPath;

- (NSArray*)displayComponentlist;
- (NSString*)getCustomDesignJsonString; //购物车用来存储的时候使用的

//int 	品类id，0表示全部

- (void)getStyleDesignfinish:(void (^)(NSDictionary* dict, BYError* error))finished;

- (void)saveDesignDataWithStatus:(int)status title:(NSString*)title desc:(NSString*)desc finish:(void (^)(int designId, BYError* error))finished;

- (void)preloadMaskMapArrayWithDirectorypath:(NSString*)directorypath
                                  ImageIndex:(NSString*)imgIndexs
                                       IsPng:(BOOL)ispng
                                       Width:(int)width
                                      Height:(int)height
                                      finish:(void (^)(BOOL success, BYError* error))finished;

- (void)fetchDesignDataByDesignId:(int)designId finish:(void (^)(BOOL success, BYError* error))finished;

- (void)fetchProductListByPageSize:(NSNumber*)pageSize
                           pageNum:(NSNumber*)pageNum
                            finish:(void (^)(NSArray* productList, BYError* error))finished;

- (void)fetchMyDesignListByCategoryId:(NSNumber*)categoryId
                             pageSize:(int)pageSize
                              pageNum:(int)pageNum
                               finish:(void (^)(NSArray* designList, BYError* error))finished;

// delete my designs
- (void)deleteMydesignWithDesignId:(int)designId finish:(void (^)(BOOL success, BYError* error))finished;

- (void)fetchDesignDetail:(int)designId
                   finish:(void (^)(BYDesign* design, BYError* error))finished;

- (void)loadMaskMapArrayWithDirectorypath:(NSString*)directorypath
                               ImageIndex:(NSString*)imgIndexs
                                    IsPng:(BOOL)ispng
                                    Width:(int)width
                                   Height:(int)height
                                   finish:(void (^)(BOOL success, BYError* error))finished;

- (void)renderModelWithWidth:(int)width Height:(int)height
                 CameraFocus:(int)cameraFocus
      isOutPutTransparentPNG:(BOOL)isOutPutTransparentPNG
             modelCategoryId:(int)modelCategoryId
               FocalDistance:(float)FocalDistance
             Hackgroundcolor:(int)backgroundcolor
            Hastopbottomview:(BOOL)hastopbottomview
                   showLarge:(BOOL)showLarge
               OutputImageNo:(int)outputImageNo
                 highQuality:(BOOL)highQuality
                    loadMask:(BOOL)loadMask
                renderShadow:(int)renderShadow
                     modelId:(int)modelId
                      models:(NSArray*)dict
                      finish:(void (^)(BOOL success, BYError* error))finished;

- (void)renderWithModelId:(int)modelId
              modelCateId:(int)modelCategoryId
                 loadMask:(BOOL)loadMask
                   models:(NSArray*)dict
         hastopbottomview:(BOOL)hastopbottomview
                   finish:(void (^)(BOOL success, BYError* error))finished;

- (NSDictionary*)getSaveData;

//分享免邮 接口
- (void)checkShareByDesignId:(int)designId finish:(void (^)(BOOL hasShare))finished;

- (void)addShareRecordByDesignId:(int)designId shareChannel:(int)shareChannel promotionId:(int)promotionId finish:(void (^)(int insertState))finished;

#pragma mark -

+ (void)preloadDetails:(NSString*)designIds;

@end
