//
//  BYEditService.m
//  IBY
//
//  Created by St on 14-11-3.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYEditService.h"

@implementation BYEditService

- (void)fetchDesignDataWithDesignId:(NSString*)designId finish:(void (^)(NSDictionary*, BYError*))finished
{
    NSString* url = @"product/info/DesignData";
    NSDictionary* params = @{ @"design_id" : designId };
    
    [BYNetwork get:url params:params finish:^(NSDictionary* data, BYError* error) {
        if(error ){
            finished(nil,error);
        }
        finished(data,nil);
    }];
}

@end
