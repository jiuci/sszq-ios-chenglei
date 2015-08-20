//
//  BYGlassService.h
//  IBY
//
//  Created by St on 15/4/7.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBaseService.h"
@class BYFaceDataUnit;

@interface BYGlassService : BYBaseService

+ (void)fetchTryListByDesignId:(int)designId
                      needShow:(BOOL)needShow
                     faceWidth:(int)faceWidth
                        finish:(void(^)(NSArray* glassesList, BYError *error))finished;

- (NSArray*)nativeFacelist;
- (void)appendFace:(BYFaceDataUnit*)unit;
- (void)modifyFace:(BYFaceDataUnit*)unit;
- (BOOL)removeFace:(BYFaceDataUnit*)unit;
- (BOOL)isFaceCacheEmpty;

@end


