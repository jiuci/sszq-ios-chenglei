//
//  BYIMPassWordEngine.m
//  IBY
//
//  Created by forbertl on 15/10/13.
//  Copyright © 2015年 com.biyao. All rights reserved.
//

#import "BYIMPassWordEngine.h"

@implementation BYIMPassWordEngine
+ (void)loadpassword:(void (^)(NSString * password, BYError* error))finished
{
    NSString* url = @"/minisite/query/v1";
    
    [BYNetwork post:url params:nil finish:^(NSDictionary* data, BYError* error) {
        if(error){
            finished(nil,error);
            return ;
        }
        NSLog(@"%@",data);
       
        finished(nil,nil);
    }];

}
@end
