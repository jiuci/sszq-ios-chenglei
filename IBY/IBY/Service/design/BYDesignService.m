
//
//  BYDesignService.m
//  IBY
//
//  Created by pan Shiyu on 14-8-27.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYDesignService.h"
#import "BYDesign.h"
#import "MJExtension.h"
#import "NSStringExtension.h"
#import "BYComponent.h"
#import "BYMaterial.h"
#import "BYModel.h"
#import "BYModelTreePoint.h"
#import "BYPartCategoryRelation.h"

@interface BYDesignService () {
    __block int count;
}

@end

@implementation BYDesignService

//分享免邮

- (void)checkShareByDesignId:(int)designId finish:(void (^)(BOOL))finished
{
    NSString* url = @"promotion/getpromotion4design";
    NSDictionary* params = @{ @"Design_id" : IntToString(designId) };

    _shareInfo = @{ @"title" : @"这是一件贴心小棉袄~",
                    @"desc" : @"哦哦哦哦哦，这个真的好好哦，分享免邮喽！~ aaaaaaaaaaaaaaaaaaaaaaaaaaaa  bnbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" };

    //data:{hasShare:1,desc:XXXX,title:XXXX, id:xxx}//1有分享活动0没有分享活动 //}	// id:分享免邮活动id

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(FALSE);
            return ;
        }
        if([data[@"hasShare"] intValue]== 1){
            _shareInfo = [NSDictionary dictionaryWithDictionary:data];
            finished(TRUE);
        }else{
            finished(FALSE);
        }

    }];
}

- (void)addShareRecordByDesignId:(int)designId shareChannel:(int)shareChannel promotionId:(int)promotionId finish:(void (^)(int))finished
{

    NSString* url = @"promotion/AddShareRecord";
    NSDictionary* params = @{ @"Design_id" : IntToString(designId),
                              @"Share_Channel" : IntToString(shareChannel),
                              @"Promotion_id" : IntToString(promotionId) };

    [BYNetwork post:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(0);
            return ;
        }
        finished([data[@"insertState"] intValue]);

    }];
}

//获取 商品详情页的 编辑数据

- (void)getStyleDesignfinish:(void (^)(NSDictionary*, BYError*))finished
{
    NSString* url = @"productstyle/getStyle4Design";

    NSMutableArray* subModelArray = [NSMutableArray array];
    if (_subModelList.count >= 2) {

        for (int i = 1; i < _subModelList.count; i++) {
            BYModel* model = _subModelList[i];
            [subModelArray addObject:@(model.model_id)];
        }
    }

    NSArray* sortedList = [subModelArray
        sortedArrayUsingComparator:^NSComparisonResult(id obj1,
                                                       id obj2) {
                               return [obj1 compare:obj2];
        }];

    NSMutableArray* mainCompArray = [NSMutableArray array];
    for (BYModel* obj in _subModelList) {
        if (obj) {
            for (BYComponent* comp in obj.componentList) {
                if (comp) {
                    NSDictionary* compDcit = @{ @"component_id" : @(comp.component_id),
                                                @"id" : @(comp.usedMaterial.category_id) };
                    [mainCompArray addObject:compDcit];
                }
            }
        }
    }

    NSDictionary* params = @{ @"modelid" : @(_mainModel.model_id),
                              @"subModelIds" : [sortedList jsonString],
                              @"mainCmpMtlTypes" : [mainCompArray jsonString]
    };

    [BYNetwork get:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        double price = [data[@"style"][@"price"]doubleValue];
        NSDictionary *showdata = @{@"title":_curDesign.designName,
                                   @"price":@(price),
                                   @"image":_imgUrls[0]};
        [_customerDesign setObject:@(price) forKey:@"price"];
        [_customerDesign setObject:IntToString([data[@"style"][@"styleId"]intValue]) forKey:@"style_id"];
        
        //TODO: checkpsy 这里把价格放在service里面的curDesign里了，有风险
        self.curDesign.price = data[@"style"][@"price"];
        
        finished(showdata,nil);
    }];
}

- (void)preloadMaskMapArrayWithDirectorypath:(NSString*)directorypath ImageIndex:(NSString*)imgIndexs IsPng:(BOOL)ispng Width:(int)width Height:(int)height finish:(void (^)(BOOL, BYError*))finished
{
    NSString* url = @"render/LoadMaskMap";
    NSDictionary* params = @{
        @"directorypath" : directorypath,
        @"imgindex" : imgIndexs,
        @"ispng" : @(ispng),
        @"width" : @(width),
        @"height" : @(height)
    };
    [BYNetwork post:url params:params isCacheValid:YES finish:^(NSDictionary* data, BYError* error) {
        if (error) {
            finished(NO, error);
            return;
        }
        
        finished(YES, nil);
    }];
}

- (NSString*)getCustomDesignJsonString
{
    NSString* jsonString = @"";
    @try {
        NSDictionary* saveData = [self getSaveData];
        NSDictionary* params = @{
            @"customerDesign" : saveData[@"customerDesign"],
            @"customerDesignData" : saveData[@"customerDesignData"],
            @"modelDetails" : saveData[@"modelDetails"],
            @"customerDesignDetails" : saveData[@"customerDesignDetails"],
            @"selectedWordInfoIds" : saveData[@"selectedWordInfoIds"],
            @"sigurationWords" : saveData[@"sigurationWords"]
        };
        [_customerDesign setObject:_imgUrls[6] forKey:@"img_url"];
        [_customerDesign setObject:@(1) forKey:@"status"]; //加入购物车时为1，保存为2
        [_customerDesign setObject:@"" forKey:@"design_name"];
        [_customerDesign setObject:@"" forKey:@"design_descption"];
        [_customerDesign setObject:@(_mainModel.model_id) forKey:@"model_id"];

        jsonString = [params jsonString];
    }
    @catch (NSException* exception)
    {
        BYLog(@"");
    }
    @finally
    {
        return jsonString;
    }
}

- (void)saveDesignDataWithStatus:(int)status title:(NSString*)title desc:(NSString*)desc
                          finish:(void (^)(int, BYError*))finished
{
    //
    title = [NSString stringWithFormat:@"%@%@", self.mainModel.model_name, @"鞋面"];

    [_customerDesign setObject:_imgUrls[6] forKey:@"img_url"];
    [_customerDesign setObject:@(status) forKey:@"status"]; //加入购物车时为1，保存为2
    [_customerDesign setObject:title forKey:@"design_name"];
    [_customerDesign setObject:desc forKey:@"design_descption"];
    [_customerDesign setObject:@(_mainModel.model_id) forKey:@"model_id"];

    NSDictionary* saveData = [self getSaveData];
    NSString* url = @"product/info/DesignSave";
    NSDictionary* params = @{
        @"customerDesign" : saveData[@"customerDesign"],
        @"customerDesignData" : saveData[@"customerDesignData"],
        @"modelDetails" : saveData[@"modelDetails"],
        @"customerDesignDetails" : saveData[@"customerDesignDetails"],
        @"selectedWordInfoIds" : saveData[@"selectedWordInfoIds"],
        @"sigurationWords" : saveData[@"sigurationWords"]
    };
    NSString* jsonString = [params jsonString];
    NSDictionary* params1 = @{ @"CustomerDesignInfo" : jsonString };

    [BYNetwork post:url
             params:params1
             finish:^(NSDictionary* data, BYError* error) {
               if (error || !data) {
                 finished(-1, error);
                 return;
               }

               finished([data[@"designid"] intValue], nil);
             }];
}

static double initTime;
- (void)loadMaskMapArrayWithDirectorypath:(NSString*)directorypath
                               ImageIndex:(NSString*)imgIndexs
                                    IsPng:(BOOL)ispng
                                    Width:(int)width
                                   Height:(int)height
                                   finish:(void (^)(BOOL, BYError*))finished
{
    NSString* url = @"render/LoadMaskMap";
    NSDictionary* params = @{
        @"directorypath" : directorypath,
        @"imgindex" : imgIndexs,
        @"ispng" : @(ispng),
        @"width" : @(width),
        @"height" : @(height)
    };

    initTime = [NSDate date].timeIntervalSince1970;
    BYLog(@"-------loadMask begin -------%f ", ([NSDate date].timeIntervalSince1970 - initTime));

    [BYNetwork post:url params:params isCacheValid:YES finish:^(NSDictionary* data, BYError* error) {
        BYLog(@"-------loadMask netdone -------%f ", ([NSDate date].timeIntervalSince1970 - initTime));
        if (error) {
            [_maskArray removeAllObjects];
            finished(NO, error);
        }else{
            _maskUrlString = data[@"maskurl"];
            if (data[@"maskmaparray"]) {
                [self updateMaskArray:data[@"maskmaparray"]
                                Width:width
                               Height:height];
                 finished(YES, nil);
            }else{
                finished(NO,[BYError errorWithDomain:@"com.biyao.loadmask" code:500 userInfo:nil]);
            }
        }
        BYLog(@"-------loadMask done -------%f ", ([NSDate date].timeIntervalSince1970 - initTime));
    }];
}

- (void)renderModelWithWidth:(int)width
                      Height:(int)height
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
                      models:(NSArray*)array
                      finish:(void (^)(BOOL, BYError*))finished
{

    NSString* url = @"render/DoRender";

    NSDictionary* params = @{
        @"width" : @(width),
        @"height" : @(height),
        @"camera_focus" : @(cameraFocus),
        @"isOutPutTransparentPNG" : @(isOutPutTransparentPNG),
        @"modelCategoryId" : @(modelCategoryId),
        @"FocalDistance" : @(FocalDistance),
        @"backgroundcolor" : @(backgroundcolor),
        @"hastopbottomview" : @(hastopbottomview),
        @"showLarge" : @(showLarge),
        @"outputImageNo" : @(outputImageNo),
        @"highQuality" : @(highQuality),
        @"loadMask" : @(loadMask), //@"renderShadow" : @(renderShadow),
        @"modelId" : @(modelId),
        @"models" : array
    };

    NSDictionary* params1 = @{ @"renderParam" : [params jsonString] };

    [BYNetwork post:url params:params1 isCacheValid:YES finish:^(NSDictionary* data, BYError* error) {
        if (error) {
            finished(NO, error);
            return;
        }
            
        // 更新不显示面的数据
        NSArray* notShowCompArray = data[@"result"][@"NotShowComponents"];
        [self updateNotShowComponents:notShowCompArray];
        
        //获取返回的图片数据----------
        [_imgUrls removeAllObjects];
        NSArray* imgArray = data[@"result"][@"Perspectives"];
        for (NSDictionary* obj in imgArray) {
            NSString* treatStr = obj[@"ImageUrl"];
            [_imgUrls addObject:treatStr];
        }
        self.curDesign.cutImgUrls = _imgUrls;
        
        //替换directoryPath
        _directoryPath = data[@"result"][@"MBPath"]; //modelPath

        //更新蒙版 与 面的对应关系
        if (!_maskCodeToCompArray) {
            _maskCodeToCompArray = [NSMutableArray array];
        }
        NSMutableArray* tempCompList = [NSMutableArray array];
        [tempCompList removeAllObjects];
        if (_subModelList.count > 1) {

            [_subModelList bk_each:^(BYModel* obj) {
                    [tempCompList addObjectsFromArray:obj.componentList];
            }];
        }
        
        initTime = [NSDate date].timeIntervalSince1970;
        //组织 新的pespective数据
        __block NSMutableArray* newPerspectives = [NSMutableArray array];
        NSArray *PerspectivesArray = data[@"result"][@"Perspectives"];
        NSArray* testArray = PerspectivesArray[0][@"ComponentMasks"];
        //材料渲染返回的 Perspectives 中的componentmasks 数组是空的   所以需要更新 Perspectives 中图片的数据
        if(testArray.count == 0){
            NSMutableArray* storeArray = [NSMutableArray array];
            NSArray* treatArray = [_perspectiveArray
                                   sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1,
                                                                                  NSDictionary* obj2) {
                                       return [obj1[@"Index"] compare:obj2[@"Index"]];
                                   }];
            
            [treatArray enumerateObjectsUsingBlock:^(NSMutableDictionary* obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary* newSingleCompDict = [NSMutableDictionary dictionary];
                [newSingleCompDict setObject:obj[@"ComponentMasks"] forKey:@"ComponentMasks"];
                [newSingleCompDict setObject:_imgUrls[idx] forKey:@"ImageUrl"];
                [newSingleCompDict setObject:obj[@"Index"] forKey:@"Index"];
                [storeArray addObject:newSingleCompDict];
            }];
            [_perspectiveArray removeAllObjects];
            _perspectiveArray = [NSMutableArray arrayWithArray:storeArray];
        }else{   //部件渲染返回的 Perspectives 中的componentmasks 数组不为空
            [_perspectiveArray removeAllObjects];
            _perspectiveArray = [NSMutableArray arrayWithArray:PerspectivesArray];
        }
        //TODO: cst  这样写太乱了 还是放回到 saveData 的获取 方法当中
        //根据 _perspectiveArray  更新 designData中的渲染数据  为了save时使用
        if (_perspectiveArray) {
            NSArray* sortedList = [_perspectiveArray
                                   sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1,
                                                                                  NSDictionary* obj2) {
                                       return [obj1[@"Index"] compare:obj2[@"Index"]];
                                   }];

            if (sortedList) {
                NSArray* resultArray =
                [sortedList bk_map:^id(NSDictionary* obj) {
                    NSMutableDictionary* newIndexData = [NSMutableDictionary dictionary];
                    [newIndexData setObject:obj[@"Index"] forKey:@"index"];
                    [newIndexData setObject:obj[@"ImageUrl"] forKey:@"imageUrl"];
                    NSMutableDictionary* newComponentMasks = [NSMutableDictionary dictionary];
                    NSArray* componentMasks = obj[@"ComponentMasks"];
                    NSMutableDictionary* compDcit = [NSMutableDictionary dictionary];
                    [componentMasks enumerateObjectsUsingBlock:^(NSDictionary* singleFace, NSUInteger idx, BOOL *stop) {
                        
                        int maskcode = [singleFace[@"MaskCode"] intValue];
                        //[compDcit setObject:singleFace[@"ComponentName"] forKey:IntToString(maskcode)];
                        [tempCompList bk_each:^(BYComponent* comp) {
                            if([comp.component_name isEqualToString:singleFace[@"ComponentName"]]){
                                [compDcit setObject:@(comp.component_id) forKey:IntToString(maskcode)];
                                
                                
                                [newComponentMasks setObject:@{@"ComponentName":comp.component_name,
                                                               @"CustomeName":comp.customname,
                                                               @"ComponentId":@(comp.component_id),
                                                               @"MaskCode":@(maskcode),
                                                               @"ModelId":@(comp.model_id)}
                                                      forKey:IntToString((int)(idx+1))];
                            }
                        }];
                    }];
                    [newIndexData setObject:newComponentMasks forKey:@"componentMasks"];
                    [newPerspectives addObject:newIndexData];
                    return compDcit;
                }];
                [_maskCodeToCompArray removeAllObjects];
                _maskCodeToCompArray = [NSMutableArray arrayWithArray:resultArray];
            }
            
        }
        //把新的pespective赋给customerDesignData
        if(data[@"result"][@"MBPath"] && ![data[@"result"][@"MBPath"] isEqualToString:@""]){
            [_customerDesignData setObject:data[@"result"][@"modelPath"] forKey:@"image_file_path"];
            [_customerDesignData setObject:data[@"result"][@"MBPath"] forKey:@"subset_file_path"];
            [_customerDesignData setObject:data[@"result"][@"MBPath"] forKey:@"directory_path"];
            [_customerDesignData setObject:data[@"result"][@"modelPath"] forKey:@"last_render_directory_path"];
        }
        [_customerDesignData setObject:newPerspectives forKey:@"perspectives"];
        
        BYLog(@"-------_customerDesignData netdone -------%f ", ([NSDate date].timeIntervalSince1970 - initTime));
        
        runOnMainQueue(^{
            finished(YES, nil);
        });

    }];
}

- (void)renderWithModelId:(int)modelId
              modelCateId:(int)modelCategoryId
                 loadMask:(BOOL)loadMask
                   models:(NSArray*)dict
         hastopbottomview:(BOOL)hastopbottomview
                   finish:(void (^)(BOOL success, BYError* error))finished
{
    [self renderModelWithWidth:800
                        Height:600
                   CameraFocus:0
        isOutPutTransparentPNG:FALSE
               modelCategoryId:modelCategoryId
                 FocalDistance:1.0
               Hackgroundcolor:0
              Hastopbottomview:hastopbottomview
                     showLarge:FALSE
                 OutputImageNo:8
                   highQuality:FALSE
                      loadMask:loadMask
                  renderShadow:0
                       modelId:modelId
                        models:dict
                        finish:finished];
}

- (NSMutableArray*)treatImage:(NSArray*)imgArray
{
    //TODO: psy 这部分代码需要修改
    NSMutableArray* resultArray = [NSMutableArray array];
    if ([BYNetwork sharedNetwork].currentMode == BYNetModeDev || [BYNetwork sharedNetwork].currentMode == BYNetModeTest) {
        for (int i = 0; i < imgArray.count; i++) {
            NSString* formerStr = imgArray[i];
            NSString* treatStr = [formerStr stringByReplacingOccurrencesOfString:@"img.biyao.com" withString:@"192.168.99.60:88"];
            resultArray[i] = treatStr;
        }
    }
    else if ([[BYNetwork alloc] init].currentMode == BYNetModeOnline || [[BYNetwork alloc] init].currentMode == BYNetModePreview) {
        resultArray = [NSMutableArray arrayWithArray:imgArray];
    }

    return resultArray;
}

- (void)fetchProductListByPageSize:(NSNumber*)pageSize
                           pageNum:(NSNumber*)pageNum
                            finish:(void (^)(NSArray* productList,
                                             BYError* error))finished
{
    NSString* url = @"product/ProductList/ProductHomeList";
    NSDictionary* param = @{ @"pageSize" : pageSize,
                             @"pageNo" : pageNum
    };

    [BYNetwork get:url
              params:param
        isCacheValid:NO
              finish:^(NSDictionary* data, BYError* error) {
                  if (error || !data[@"productList"][@"ContentList"]) {
                    finished(nil, error);
                    return;
                  }

                  NSArray *arrList = data[@"productList"][@"ContentList"];
                  NSArray *designlist =
                      [BYDesign objectArrayWithKeyValuesArray:arrList];
                  
                  finished(designlist, nil);
              }];
}

//单品页的数据
- (void)fetchDesignDetail:(int)designId
                   finish:(void (^)(BYDesign* aDesign, BYError* error))finished
{
    NSString* url = @"product/info/DesignShowServerlet";
    NSDictionary* param = @{ @"design_id" : @(designId) };

    [BYNetwork get:url
            params:param
            finish:^(NSDictionary* data, BYError* error) {
              if (error || !data[@"designDataDTO"]) {
                finished(nil, error);
                return;
              }
                
            _directoryPath = data[@"customerDesignData"][@"subset_file_path"];
            
            _curDesign = [BYDesign mtlObjectWithKeyValues:data[@"designDataDTO"]];
            [_curDesign updateDetails:data];
            _curDesign.supplier_id = [data[@"modelInfo"][@"supplier_id"] intValue];
              finished(_curDesign, nil);
            }];
}

//编辑器的数据
- (void)fetchDesignDataByDesignId:(int)designId
                           finish:(void (^)(BOOL, BYError*))finished
{
    NSString* url = @"product/info/DesignData";
    NSDictionary* param = @{ @"design_id" : @(designId) };

    [BYNetwork get:url params:param isCacheValid:YES finish:^(NSDictionary* data, BYError* error) {
        if (error || !data[@"designDataDTO"]) {
            finished(NO, error);
            return;
        }
        
        _directoryPath = data[@"customerDesignData"][@"subset_file_path"];
        
        if (!_curDesign) {
            self.curDesign = [BYDesign mtlObjectWithKeyValues:data[@"designDataDTO"]];
        }
        
        initTime = [NSDate date].timeIntervalSince1970;
        //初始化渲染的数据
        [self updateDesignInfo:data];
        
        self.curDesign.cutImgUrls = _imgUrls;
        
        if (data[@"bookTurn"]) {
            self.curDesign.bookTurnInfo = [[BYBookTurnInfo alloc] initWithDict:data[@"bookTurn"]];
        }else{
            self.curDesign.bookTurnInfo = nil;
        }
        
        //更新不显示的面的数据
        NSArray* notShowCompArray = data[@"NotShowComponents"];
        [self updateNotShowComponents:notShowCompArray];
        
        if (!_perspectiveArray) {
            _perspectiveArray = [NSMutableArray array];
        }
        [_perspectiveArray removeAllObjects];
        //更新蒙版和 面的关系数组
        if (!_maskCodeToCompArray) {
            _maskCodeToCompArray = [NSMutableArray array];
        }
        [_maskCodeToCompArray removeAllObjects];
        NSString* perspectives = data[@"customerDesignData"][@"perspectives"];
        if (perspectives) {
            
            NSData* data = [perspectives dataUsingEncoding:NSUTF8StringEncoding];
            NSArray* picInfos =
            [NSJSONSerialization JSONObjectWithData:data
                                            options:NSJSONReadingAllowFragments
                                              error:nil];
            NSArray* sortedList = [picInfos
                                   sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1,
                                                                                  NSDictionary* obj2) {
                                       return [obj1[@"index"] compare:obj2[@"index"]];
                                   }];
            NSMutableArray* tempCompList = [NSMutableArray array];
            [tempCompList removeAllObjects];
            if(_subModelList.count > 1){
                
                [_subModelList bk_each:^(BYModel* obj) {
                    [tempCompList addObjectsFromArray:obj.componentList];
                }];
            }
            
            NSArray* resultArray =
            [sortedList bk_map:^id(NSDictionary* obj) {
                NSMutableDictionary* singleCompDict = [NSMutableDictionary dictionary];
                NSMutableArray* ComponentMasksArray = [NSMutableArray array];
                
                NSDictionary* componentMasks = obj[@"componentMasks"];
                NSMutableDictionary* compDcit = [NSMutableDictionary dictionary];
                [componentMasks bk_each:^(NSString* key, NSDictionary* obj) {
                    int maskcode = [obj[@"MaskCode"] intValue];
                    //[compDcit setObject:obj[@"ComponentName"] forKey:IntToString(maskcode)];
                    [tempCompList bk_each:^(BYComponent* comp) {
                        if([comp.component_name isEqualToString:obj[@"ComponentName"]]){
                            [compDcit setObject:@(comp.component_id) forKey:IntToString(maskcode)];
                            [ComponentMasksArray addObject:@{@"ComponentName":comp.component_name,
                                                            @"MaskCode":@(maskcode),
                                                            @"ModelId":@(comp.model_id)}];
                        }
                    }];
                    
                }];
                [singleCompDict setObject:ComponentMasksArray forKey:@"ComponentMasks"];
                [singleCompDict setObject:obj[@"index"] forKey:@"Index"];
                [singleCompDict setObject:obj[@"imageUrl"] forKey:@"ImageUrl"];
                
                [_perspectiveArray addObject:singleCompDict];
                
                return compDcit;
            }];
            _maskCodeToCompArray = [NSMutableArray arrayWithArray:resultArray];
        }
        
        BYLog(@"updateDesignData ---   %f",[NSDate date].timeIntervalSince1970 - initTime);
        finished(YES, nil);
    }];
}

- (void)fetchMyDesignListByCategoryId:(NSNumber*)categoryId
                             pageSize:(int)pageSize
                              pageNum:(int)pageNum
                               finish:(void (^)(NSArray* designList,
                                                BYError* error))finished
{
    NSString* url = @"mycenter/getmydesign2";
    NSDictionary* param = @{
        @"categoryId" : categoryId,
        @"pageNo" : @(pageNum),
        @"pageSize" : @(pageSize)
    };
    [BYNetwork post:url
             params:param
             finish:^(NSDictionary* data, BYError* error) {
               if (error || !data[@"list"]) {
                 finished(nil, error);
                 return;
               }

               NSArray *arrList = data[@"list"];
               NSMutableArray *resultlist = [NSMutableArray arrayWithCapacity:arrList.count];
               [arrList bk_each:^(NSDictionary *obj) {
                   BYDesign *design = [[BYDesign alloc] initWithMyDesignDict:obj];
                   if (design) {
                     [resultlist addObject:design];
                   }
               }];

               finished([resultlist copy], nil);
             }];
}

- (void)deleteMydesignWithDesignId:(int)designId
                            finish:(void (^)(BOOL, BYError*))finished
{
    NSString* url = @"mycenter/deletemydesign";
    NSDictionary* param = @{ @"design_id" : @(designId) };

    [BYNetwork get:url
            params:param
            finish:^(NSDictionary* data, BYError* error) {
              if (error || !data) {
                finished(NO, error);
              } else {
                finished(YES, nil);
              }
            }];
}

- (NSDictionary*)getSaveData
{
    @try {
        //_subModelList第一个是mainModel
        NSMutableArray* subModelArray = [NSMutableArray array];
        if (_subModelList.count >= 2) {

            for (int i = 1; i < _subModelList.count; i++) {
                BYModel* model = _subModelList[i];
                [subModelArray addObject:@(model.model_id)];
            }
        }

        NSArray* sortedList = [subModelArray
            sortedArrayUsingComparator:^NSComparisonResult(id obj1,
                                                           id obj2) {
                                   return [obj1 compare:obj2];
            }];
        __block NSString* subModelString = @"";
        if (sortedList.count > 0) {
            subModelString = IntToString([sortedList[0] intValue]);
            [sortedList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                if(idx > 0){
                    subModelString = [NSString stringWithFormat:@"%@,%@", subModelString,IntToString([obj intValue])];
                }
            }];
        }
        [_customerDesign setValue:subModelString forKey:@"sub_model_info"];

        NSMutableArray* modelDetails = [NSMutableArray array];
        NSMutableDictionary* mainModelDetail = [@{
            @"createby" : @"",
            @"createtime" : @"", //[NSDate date]
            @"id" : @(_mainModel.model_id),
            @"mainModel" : @(true),
            @"model_id" : @(_mainModel.model_id),
            @"price" : @(_mainModel.model_price),
            @"updatetime" : @"",
            @"updateby" : @"",
        } mutableCopy];
        if (_customerDesign) {
            mainModelDetail[@"design_id"] = _customerDesign[@"design_id"];
            if (_curDesign.designId == [_customerDesign[@"design_id"] intValue]) {
                BYLog(@"+++++++++++++++");
            }
            else {
                BYLog(@"---------------");
            }
        }
        else {
            BYLog(@"&&&&&&&&&&&&&&&&");
        }
        [modelDetails addObject:mainModelDetail];
        for (BYModel* obj in _subModelList) {
            // TODO:  id 不知道是什么意思  createTime , updateTime , createby , updateBy
            // ?
            if (obj.model_id != _mainModel.model_id) {
                NSDictionary* modelDetail = @{
                    @"createby" : @"",
                    @"createtime" : @"",
                    @"design_id" : _customerDesign[@"design_id"],
                    @"id" : @(obj.model_id),
                    @"mainModel" : @(false),
                    @"model_id" : @(obj.model_id),
                    @"price" : @(obj.model_price),
                    @"updatetime" : @"",
                    @"updateby" : @"",
                };
                [modelDetails addObject:modelDetail];
            }
        }

        NSMutableArray* customerDesignDetails = [NSMutableArray array];
        for (BYModel* obj in _subModelList) {
            for (BYComponent* comp in obj.componentList) {
                if (comp.usedMaterial) {
                    NSDictionary* designDetail = @{
                        @"additional_info" : @"",
                        @"component_id" : @(comp.component_id),
                        @"createtime" : @"",
                        @"design_id" : _customerDesign[@"design_id"],
                        @"detail_id" : @(0), //  不清楚如何获取detail_id
                        @"material_id" : @(comp.usedMaterial.material_id),
                        @"material_source_price" : @(comp.usedMaterial.material_source_price),
                        @"material_texture_id" : @(comp.usedMaterial.material_texture_id),
                        @"material_unit" : comp.usedMaterial.material_unit,
                        @"material_unit_percent" : @(comp.usedMaterial.material_unit_percent),
                        @"price" : @(0),
                    };
                    [customerDesignDetails addObject:designDetail];
                }
            }
        }

        NSDictionary* data = @{
            @"customerDesign" : _customerDesign,
            @"customerDesignData" : _customerDesignData,
            @"modelDetails" : modelDetails,
            @"customerDesignDetails" : customerDesignDetails,
            @"selectedWordInfoIds" : [NSArray array],
            @"sigurationWords" : [NSArray array],
        };
        return data;
    }
    @catch (NSException* exception)
    {
        return nil;
        BYLog(@"");
    }
    @finally
    {
        BYLog(@"");
    }
}

#pragma mark -

- (void)updateNotShowComponents:(NSArray*)compArray
{
    if (!_NotShowCompsMap) {
        _NotShowCompsMap = [NSMutableDictionary dictionary];
    }
    [_NotShowCompsMap removeAllObjects];
    [compArray bk_each:^(id obj) {
        [_NotShowCompsMap setObject:@"NotShow" forKey:[NSString stringWithFormat:@"%@",obj]];
    }];
}

- (void)setupMaskCodeToCompArray:(NSArray*)sortedList
{
    if (!_maskCodeToCompArray) {
        _maskCodeToCompArray = [NSMutableArray array];
    }
    [_maskCodeToCompArray removeAllObjects];

    if (sortedList) {

        NSArray* resultArray =
            [sortedList bk_map:^id(NSDictionary* obj) {
            
            NSDictionary* componentMasks = obj[@"componentMasks"];
                NSMutableDictionary* compDcit = [NSMutableDictionary dictionary];
                [componentMasks bk_each:^(NSString* key, NSDictionary* obj) {
                    int maskcode = [obj[@"MaskCode"] intValue];
                    [compDcit setObject:obj[@"ComponentName"] forKey:IntToString(maskcode)];
                }];
            return compDcit;
            }];
        _maskCodeToCompArray = [NSMutableArray arrayWithArray:resultArray];
    }
}

- (void)updateMaskArray:(NSArray*)maskArray
                  Width:(int)width
                 Height:(int)height
{
    //先按照ImgIndex 进行排序
    NSArray* sortedList = [maskArray
        sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1,
                                                       NSDictionary* obj2) {
                               return [obj1[@"ImgIndex"] compare:obj2[@"ImgIndex"]];
        }];

    int suitHeight = height / 4;
    int suitWidth = width / 4;
    _maskArray = [NSMutableArray array];
    [_maskArray removeAllObjects];
    for (int i = 0; i < sortedList.count; i++) {
        NSDictionary* getDict = sortedList[i];
        NSArray* Subsets = getDict[@"Subsets"];
        NSMutableArray* totalArray = [NSMutableArray array];
        for (int i = 0; i < (suitHeight); i++) {
            NSMutableArray* minorArray = [NSMutableArray array];
            for (int k = 0; k < (suitWidth); k++) {
                [minorArray addObject:Subsets[i * suitWidth + k]];
            }
            [totalArray addObject:minorArray];
        }

        [_maskArray addObject:totalArray];
    }
}

- (void)updateDesignInfo:(NSDictionary*)dict
{
    [self resetStatus];
    [self setImageUrls:dict];
    //初始化design的数据，提供一些编辑器所需要的工具
    [self setDesignData:dict];
    [self setupMainModel:dict];
    [self setupMap:dict];
    [self setSubModels:dict];
    [self setupMaterialData:dict];
    [self buildTree];

    NSMutableArray* willShowPartlist = [NSMutableArray array];
    [_partMap.allValues enumerateObjectsUsingBlock:^(BYPartCategoryRelation* obj, NSUInteger idx, BOOL* stop) {
        if ([obj.modelList count] > 1) {
            [willShowPartlist addObject:obj];
        }else{
            BYLog(@"%d part will not show coz modelList.count<=1", obj.id);
        }
    }];

    _displayPartlist = [_partMap.allValues sortedArrayUsingComparator:^NSComparisonResult(
                                                                          BYPartCategoryRelation* obj1,
                                                                          BYPartCategoryRelation* obj2) {
        return obj1.priority > obj2.priority;
    }];

    //普通型的 面+组件模型全部属于主模型   拼插型的 子模型可能包含
    //多个面或者子模型
    [_componentMap bk_each:^(id key, BYComponent* obj) {
      BYModel *model = _modelMap[IntToString(obj.model_id)];
      if (model) {
        [model.componentList addObject:obj];
      }
    }];
    [_modelMap bk_each:^(NSString* key, BYModel* obj) {
      BYModelTreePoint *mtp = _modelTreeMap[IntToString(obj.category_tree_id)];
      if (mtp) {
        [mtp.modelList addObject:obj];
      }
    }];
}

- (void)setImageUrls:(NSDictionary*)dict
{
    if (dict[@"customerDesignData"][@"perspectives"]) {
        NSString* perspectives = dict[@"customerDesignData"][@"perspectives"];
        NSData* data = [perspectives dataUsingEncoding:NSUTF8StringEncoding];
        NSArray* picInfos =
            [NSJSONSerialization JSONObjectWithData:data
                                            options:NSJSONReadingAllowFragments
                                              error:nil];
        NSArray* sortedList = [picInfos
            sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1,
                                                           NSDictionary* obj2) {
            return [obj1[@"index"] compare:obj2[@"index"]];
            }];

        ;
        NSArray* resultArray =
            [sortedList bk_map:^id(NSDictionary* obj) { return obj[@"imageUrl"]; }];
        _imgUrls = [NSMutableArray arrayWithArray:resultArray];
        _imgUrls = [self treatImage:_imgUrls];
    }
}

- (void)setDesignData:(NSDictionary*)dict
{
    _customerDesign = [NSMutableDictionary dictionary];
    if (dict[@"designDataDTO"]) {
        NSDictionary* temp = @{
            @"creation_time" : dict[@"designDataDTO"][@"creation_time"],
            @"customer_id" : dict[@"designDataDTO"][@"customer_id"],
            @"customer_type" : dict[@"designDataDTO"][@"customer_type"],
            @"designVersion" : @"",
            @"design_category_id" : dict[@"designDataDTO"][@"design_category_id"],
            @"design_code" : dict[@"designDataDTO"][@"design_code"],
            @"design_descption" : dict[@"designDataDTO"][@"design_descption"],
            @"design_id" : dict[@"designDataDTO"][@"design_id"],
            @"design_id_tem" : @(0), //没有这个字段
            @"design_name" : @"你好sitong",
            @"detail_image_num" : @(0), //没有这个字段
            @"image_cut" : @(false),
            @"image_height" : dict[@"designDataDTO"][@"image_height"],
            @"image_url_218" : dict[@"designDataDTO"][@"image_url_218"],
            @"image_url_50" : dict[@"designDataDTO"][@"image_url_50"],
            @"image_width" : dict[@"designDataDTO"][@"image_width"],
            @"img_background_color" : dict[@"designDataDTO"][@"img_background_color"],
            @"img_url" : dict[@"designDataDTO"][@"img_url"],
            @"istopmost" : dict[@"designDataDTO"][@"istopmost"],
            @"last_modified_time" : dict[@"designDataDTO"][@"last_modified_time"],
            @"memo" : @"",
            @"model_id" : dict[@"modelDesigninfro"][@"model_id"],
            @"offline_type" : dict[@"designDataDTO"][@"offline_type"],
            @"price" : dict[@"designDataDTO"][@"price"],
            @"reference_design_id" : dict[@"designDataDTO"][@"design_id"],
            @"shelf_status" : @(1), // 没有这个字段
            @"show_img_index" : dict[@"designDataDTO"][@"show_img_index"],
            @"small_image_width" : dict[@"designDataDTO"][@"small_image_width"],
            @"small_image_height" : dict[@"designDataDTO"][@"small_image_height"],
            @"sort_number" : dict[@"designDataDTO"][@"sort_number"],
            @"status" : dict[@"designDataDTO"][@"status"], //加入购物车时为1，保存为2
            @"style_id" : dict[@"designDataDTO"][@"style_id"],
            @"sub_model_info" :
                dict[@"designDataDTO"][@"sub_model_info"], // save时需要修改
            @"topsort" : @(0), //  没有 topsort这个字段
            @"visit_code" : dict[@"designDataDTO"][@"visit_code"],

        };
        _customerDesign = [NSMutableDictionary dictionaryWithDictionary:temp];
    }

    _customerDesignData = [NSMutableDictionary dictionary];
    if (dict[@"customerDesignData"]) {
        NSDictionary* temp = @{
            @"create_time" : dict[@"customerDesignData"][@"create_time"],
            @"design_id" : dict[@"customerDesignData"][@"design_id"],
            @"directory_path" : dict[@"customerDesignData"][@"directory_path"],
            @"extension_data" : dict[@"customerDesignData"][@"extension_data"],
            @"id" : dict[@"customerDesignData"][@"id"],
            @"image_file_path" : dict[@"customerDesignData"][@"image_file_path"],
            @"last_render_directory_path" : dict[@"customerDesignData"][@"last_render_directory_path"],
            @"perspectiveObjs" : dict[@"customerDesignData"][@"perspectiveObjs"],
            @"perspectives" : dict[@"customerDesignData"][@"perspectives"], //需要修改
            @"subset_file_path" : dict[@"customerDesignData"][@"subset_file_path"],
        };
        _customerDesignData = [NSMutableDictionary dictionaryWithDictionary:temp];
    }
}

- (void)setSubModels:(NSDictionary*)dict
{
    _subModelList = [NSMutableArray array];
    [_subModelList addObject:_mainModel];
    NSString* modelsString = dict[@"designDataDTO"][@"sub_model_info"];
    NSArray* stringList = [modelsString componentsSeparatedByString:@","];
    for (NSString* subModelString in stringList) {
        [_modelMap bk_each:^(id key, BYModel* obj) {
        if ([subModelString isEqualToString:key]) {
          [_subModelList addObject:obj];
          return;
        }
        }];
    };
}

- (void)resetStatus
{
    [_modelMap removeAllObjects];
    [_componentMap removeAllObjects];
    [_partMap removeAllObjects];
    [_modelTreeMap removeAllObjects];
    _displayPartlist = nil;
    _subModelList = nil;
    _customerDesign = nil;
}

#pragma mark -

- (NSArray*)displayComponentlist
{
    NSMutableArray* willlist = [NSMutableArray array];
    for (BYModel* model in _subModelList) {
        for (BYComponent* comp in model.componentList) {
            if (self.NotShowCompsMap[IntToString(comp.component_id)]) {
                BYLog(@"%d will not show coz NotShowCompsMap", comp.component_id);
                continue;
            }

            if (comp.materialList.count <= 1) {
                BYLog(@"%d will not show coz materialList.count <=  1", comp.component_id);
                continue;
            }

            [willlist addObject:comp];
        }
    }
    return [willlist copy];
}

#pragma mark - init things

- (void)buildTree
{
    //根据 rootId去寻找对应的主模型,root是自己手动创建的
    _root = [[BYModelTreePoint alloc] init];
    _root.tree_id = _mainModel.category_tree_id;
    _root.parent_id = _mainModel.parent_id;
    [_modelTreeMap setValue:_root forKey:[@(_root.tree_id) stringValue]];

    [_modelTreeMap bk_each:^(NSString* key, BYModelTreePoint* obj) {
      //全部设置成childmodel

      BYModelTreePoint *parentTree = _modelTreeMap[IntToString(obj.parent_id)];
      if (parentTree) {
        [parentTree.childList addObject:obj];
        obj.parent = parentTree;
      }
    }];
}

- (void)setupMainModel:(NSDictionary*)data
{
    _mainModel = [BYModel mtlObjectWithKeyValues:data[@"modelInfo"]];
    if (_mainModel) {
        [self.modelMap setValue:_mainModel
                         forKey:[@(_mainModel.model_id) stringValue]];
        _isComplexDesign = ((_mainModel.model_style == 1) ? false : true);
    }
}

- (void)setupMap:(NSDictionary*)data
{
    NSArray* treeInfoData = data[@"modelTreeInfos"];
    [treeInfoData bk_each:^(NSDictionary* obj) {
      BYModelTreePoint *treePoint = [BYModelTreePoint objectWithKeyValues:obj];
      [self.modelTreeMap setValue:treePoint
                           forKey:IntToString(treePoint.tree_id)];
    }];

    NSArray* modelsData = data[@"childmodelList"];
    [modelsData bk_each:^(NSDictionary* obj) {
      BYModel *model = [BYModel mtlObjectWithKeyValues:obj];
      [self.modelMap setValue:model forKey:IntToString(model.model_id)];
    }];
    NSArray* partsData = data[@"PartCategoryRelations"];
    [partsData bk_each:^(NSDictionary* obj) {
      BYPartCategoryRelation *partRelation =
          [BYPartCategoryRelation objectWithKeyValues:obj];
      [self.partMap setValue:partRelation forKey:IntToString(partRelation.id)];
    }];

    NSArray* componentsData = data[@"modelComponentList"];
    [componentsData bk_each:^(NSDictionary* obj) {
      BYComponent *component = [BYComponent objectWithKeyValues:obj];
      if (![component.customname isEqualToString:@""]) {
        [self.componentMap setValue:component
                             forKey:IntToString(component.component_id)];
      }
    }];
}

- (void)setupMaterialData:(NSDictionary*)data
{
    /**
   * MaterialDataInfo和UsedMaterials都可能是有重复的
   * 服务端返回的是不同的component面对应的材料信息，所以即便是同一个材料，也返回了多个，so，如果用material做map，就会丢信息
   */
    NSArray* materialsData = data[@"MaterialDataInfo"];
    [materialsData bk_each:^(NSDictionary* obj) {
      BYMaterial *material = [BYMaterial objectWithKeyValues:obj];
      BYComponent *comp =
          self.componentMap[[@(material.component_id) stringValue]];
      [comp.materialList addObject:material];
    }];

    // Component当前使用的材料
    NSArray* usedMaterialsData = data[@"UsedMaterials"];
    [usedMaterialsData bk_each:^(NSDictionary* obj) {
      BYMaterial *material = [BYMaterial objectWithKeyValues:obj];
      BYComponent *comp =
          self.componentMap[[@(material.component_id) stringValue]];
      //BYLog(@"usedMate  ==  %d , comp_id = %d", material.material_id,comp.component_id);
      BYMaterial *sameOne = [comp.materialList bk_match:^BOOL(BYMaterial *obj) {
          return obj.material_id == material.material_id;
      }];
      if (sameOne) {
        comp.usedMaterial = material;
      } else {
          if ([comp.materialList count] > 0) {
              comp.usedMaterial = comp.materialList[0];
          }else{
              BYLog(@"data error, comp has no materialList");
              
              [iConsole warn:@"designId(%d)的面(%d-%@-%@)的材料列表为空",self.curDesign.designId,comp.component_id,comp.component_name,comp.customname];
              
          }
        
      }
    }];
}

- (id)init
{
    self = [super init];
    if (self) {
        _mainModel = [[BYModel alloc] init];
        _modelMap = [NSMutableDictionary dictionary];
        _componentMap = [NSMutableDictionary dictionary];
        _partMap = [NSMutableDictionary dictionary];
        _modelTreeMap = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (void)preloadDetails:(NSString*)designIds
{
    if (!designIds || designIds.length < 1) {
        return;
    }

    NSArray* ids = [designIds componentsSeparatedByString:@","];

    NSString* url = @"product/info/DesignShowServerlet";
    [ids enumerateObjectsUsingBlock:^(NSString* did, NSUInteger idx, BOOL* stop) {
        if (did && did.length > 0) {
            [BYNetwork get:url
                    params:@{@"design_id":did}
                    finish:^(NSDictionary* data, BYError* error) {
                        
                    }];
        }

    }];
}

@end
