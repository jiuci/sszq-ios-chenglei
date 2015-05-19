//
//  BYNetwork.h
//  IBY
//
//  Created by coco on 14-9-10.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYSingleton.h"

@class BYError;

typedef enum {

    BYNetModeDev = 0,
    BYNetModeTest = 1,
    BYNetModePreview = 2,
    BYNetModeOnline = 3,
} BYNetMode;

@interface BYNetwork : NSObject
@property (nonatomic, assign) BYNetMode currentMode;
@property (nonatomic, copy) NSString* currentBaseUrl;

+ (instancetype)sharedNetwork;

+ (void)switchToMode:(BYNetMode)mode;

+ (void)get:(NSString*)url
     params:(NSDictionary*)params
     finish:(void (^)(NSDictionary* data, BYError* error))finish;

+ (void)post:(NSString*)url
      params:(NSDictionary*)params
      finish:(void (^)(NSDictionary* data, BYError* error))finish;

+ (void)get:(NSString*)url
          params:(NSDictionary*)params
    isCacheValid:(BOOL)isCacheValid
          finish:(void (^)(NSDictionary* data, BYError* error))finish;

+ (void)post:(NSString*)url
          params:(NSDictionary*)params
    isCacheValid:(BOOL)isCacheValid
          finish:(void (^)(NSDictionary* data, BYError* error))finish;

+ (void)postByBaseUrl:(NSString*)baseUrl
               suffix:(NSString*)suffix
               params:(NSDictionary*)params
               finish:(void (^)(NSDictionary* data, NSError* error))finish;


@end
