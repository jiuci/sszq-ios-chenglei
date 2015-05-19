//
//  BaseShareEngine.m
//  SAKShareKit
//
//  Created by psy on 14-1-2.
//  Copyright (c) 2014年 psy. All rights reserved.
//

#import "SAKPipeBase.h"
#import "SAKShareConfig.h"

//static NSString * SimpleJSONString(NSDictionary *parameters) {
//    NSError *error = nil;
//    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
//    if (!error) {
//        return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
//    } else {
//        return nil;
//    }
//}

static NSString* stringFromObject(id object)
{
    return [NSString stringWithFormat:@"%@", object];
}

static NSString* objectEncode(id object)
{
    NSString* string = stringFromObject(object);
    return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

static NSString* SimpleStringFromParams(NSDictionary* params)
{
    NSMutableArray* mutableQueryStringComponents = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        if (key != [NSNull null] && obj != [NSNull null]) {
            [mutableQueryStringComponents addObject:[NSString stringWithFormat:@"%@=%@", objectEncode(key), objectEncode(obj)]];
        }
    }];
    return [mutableQueryStringComponents componentsJoinedByString:@"&"];
}

@implementation SAKPipeBase

- (SAKShareMediaAvailability)isAvailable
{
    return SAKShareMediaNotAvailable;
}

- (void)share:(id<SAKSharerProcotol>)sharer from:(UIViewController*)fromVC willShare:(SAKWillShareBlock)willBlock didShare:(SAKDidShareBlock)finishBlock
{
}

#pragma mark - net

- (NSOperationQueue*)netQueue
{
    static NSOperationQueue* netqueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netqueue = [[NSOperationQueue alloc] init];
    });
    return netqueue;
}

- (void)getPath:(NSString*)path
         params:(NSDictionary*)params
         finish:(void (^)(NSDictionary* result, NSError* error))finish
{
    if (params) {
        path = [path stringByAppendingFormat:@"?%@", SimpleStringFromParams(params)];
    }

    NSURL* url = [NSURL URLWithString:path];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[self netQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError) {
                               id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               if (result && [result isKindOfClass:[NSDictionary class]]) {
                                   finish(result, nil);
                               } else {
                                   finish(nil, connectionError);
                               }
                           }];
}

- (void)postPath:(NSString*)path
          params:(NSDictionary*)params
          finish:(void (^)(NSDictionary* result, NSError* error))finish
{
    NSURL* url = [NSURL URLWithString:path];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:10];
    request.HTTPMethod = @"POST";
    NSString* preferredLanguageCodes = [[NSLocale preferredLanguages] componentsJoinedByString:@", "];
    request.allHTTPHeaderFields = @{ @"Accept-Language" : [NSString stringWithFormat:@"%@, en-us;q=0.8", preferredLanguageCodes] };

    request.HTTPBody = [SimpleStringFromParams(params) dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[self netQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError) {
                               id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               if (result && [result isKindOfClass:[NSDictionary class]]) {
                                   finish(result, nil);
                               } else {
                                   finish(nil, connectionError);
                               }
                           }];
}

@end
