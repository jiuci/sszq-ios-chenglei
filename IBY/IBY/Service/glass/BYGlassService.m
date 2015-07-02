//
//  BYGlassService.m
//  IBY
//
//  Created by St on 15/4/7.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYGlassService.h"
#import "BYGlasses.h"
#import "BYFaceDataUnit.h"

@implementation BYGlassService

+ (void)fetchTryListByDesignId:(int)designId
                      needShow:(BOOL)needShow
                     faceWidth:(int)faceWidth
                        finish:(void (^)(NSArray* glassesList, BYError* error))finished
{

    NSString* url = @"product/glasses/tryList";
    NSDictionary* params = @{ @"designId" : @(designId),
        @"needShow" : @(needShow),
        @"faceWidth" : @(faceWidth) };
    [BYNetwork post:url
              params:params
        isCacheValid:YES
              finish:^(NSDictionary* data, BYError* error) {
                  if (error) {
                      finished(nil, error);
                  }
                  else {
                      finished([BYGlasses mtlObjectsWithKeyValueslist:data[@"tryList"]], nil);
                  }
              }];
}

static NSString* kNativeFacelist = @"com.biyao.cache.facelist";
- (NSArray*)nativeFacelist
{
    NSArray* datas = [self cacheForKey:kNativeFacelist];
    if (!datas || datas.count <= 0) {
        return @[];
    }

    NSArray* objs = [BYFaceDataUnit mtlObjectsWithKeyValueslist:datas];
    NSMutableArray* realObjs = [NSMutableArray array];
    for (BYFaceDataUnit* unit in objs) {
        if (unit.isValid) {
            [realObjs addObject:unit];
        }
    }

    return [realObjs copy];
}
- (void)appendFace:(BYFaceDataUnit*)unit
{
    if (!unit) {
        return;
    }

    if (!unit.isValid) {
        return;
    }
    NSMutableArray* willFacelist = [[self nativeFacelist] mutableCopy];
    [willFacelist insertObject:unit atIndex:0];

    if (willFacelist.count > 5) {
        [willFacelist removeLastObject];
    }

    NSArray* saveDatalist = [willFacelist bk_map:^id(BYFaceDataUnit* obj) {
        return [obj mtlJsonDict];
    }];
    [self setCache:saveDatalist forKey:kNativeFacelist];
}

- (void)modifyFace:(BYFaceDataUnit*)unit
{
    if (!unit) {
        return;
    }

    if (!unit.isValid) {
        return;
    }
    NSMutableArray* willFacelist = [[self nativeFacelist] mutableCopy];
    BYFaceDataUnit* dUnit = [willFacelist bk_match:^BOOL(BYFaceDataUnit* obj) {
        return [obj.imgPath2 isEqualToString:unit.imgPath2];
    }];
    if (!dUnit) {
        //没有找到要修改的项
        return;
    }
    CGPoint end = unit.lEye;
    CGPoint start = unit.rEye;
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    CGFloat unitDistance = sqrt((xDist * xDist) + (yDist * yDist));
    end = dUnit.lEye;
    start = dUnit.rEye;
    xDist = (end.x - start.x);
    yDist = (end.y - start.y);
    CGFloat dUnitDistance = sqrt((xDist * xDist) + (yDist * yDist));
    if (unit.distance > 100 && unit.distance < 180) {
        unit.distance = dUnit.distance * dUnitDistance / unitDistance;
    }
    else {
        unit.distance = unit.facePixels / unitDistance * 62;
    }

    NSUInteger index = [willFacelist indexOfObject:dUnit];
    [willFacelist replaceObjectAtIndex:index withObject:unit];

    NSArray* saveDatalist = [willFacelist bk_map:^id(BYFaceDataUnit* obj) {
        return [obj mtlJsonDict];
    }];
    [self setCache:saveDatalist forKey:kNativeFacelist];
}

- (BOOL)removeFace:(BYFaceDataUnit*)unit
{
    if (!unit) {
        return NO;
    }

    NSMutableArray* willFacelist = [[self nativeFacelist] mutableCopy];
    BYFaceDataUnit* dUnit = [willFacelist bk_match:^BOOL(BYFaceDataUnit* obj) {
        return [obj.imgPath2 isEqualToString:unit.imgPath2];
    }];
    if (!dUnit) {
        //没有找到要删除的项
        return NO;
    }
    [willFacelist removeObject:dUnit];
    runOnBackgroundQueue(^{
        [[NSFileManager defaultManager] removeItemAtPath:dUnit.imgPath2 error:nil];
    });

    NSArray* saveDatalist = [willFacelist bk_map:^id(BYFaceDataUnit* obj) {
        return [obj mtlJsonDict];
    }];
    [self setCache:saveDatalist forKey:kNativeFacelist];
    return YES;
}

- (BOOL)isFaceCacheEmpty
{
    NSArray* facelist = [self nativeFacelist];
    if (facelist && facelist.count > 0) {
        return NO;
    }
    return YES;
}

@end
