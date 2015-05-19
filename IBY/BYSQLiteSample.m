//
//  BYSQLiteSample.m
//  IBY
//
//  Created by panshiyu on 14-10-18.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYSQLiteSample.h"

@implementation BYSQLiteSample

@end

//
///** 数据库实例 */
//static FMDatabase *_db;
//
//+ (void)initialize
//{
//    // 1.获得数据库文件的路径
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *filename = [doc stringByAppendingPathComponent:@"product.sqlite"];
//    
//    // 2.得到数据库
//    _db = [FMDatabase databaseWithPath:filename];
//    
//    // 3.打开数据库
//    if ([_db open]) {
//        // 4.创表
//        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_home_products (id integer PRIMARY KEY AUTOINCREMENT, product_idstr text NOT NULL, product_dict blob NOT NULL);"];
//        if (result) {
//            BYLog(@"成功创表");
//        } else {
//            BYLog(@"创表失败");
//        }
//    }
//}
//
//- (void)saveHomeStatusDictArray:(NSArray *)productDictArray
//{
//    for (NSDictionary *productDict in productDictArray) {
//        // 把statusDict字典对象序列化成NSData二进制数据
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:productDict];
//        [_db executeUpdate:@"INSERT INTO t_home_products ( product_idstr, product_dict) VALUES ( ?, ?);",productDict[@"design_id"], data];
//    }
//}
//
//- (NSArray *)cachedHomeProduct
//{
//    // 创建数组缓存商品数据
//    NSMutableArray *products = [NSMutableArray array];
//    
//    // 根据请求参数查询数据
//    FMResultSet *resultSet = nil;
//    
//    resultSet = [_db executeQuery:@"SELECT * FROM t_home_products;"];
//    // 遍历查询结果
//    while (resultSet.next) {
//        NSData *statusDictData = [resultSet objectForColumnName:@"product_dict"];
//        NSDictionary *statusDict = [NSKeyedUnarchiver unarchiveObjectWithData:statusDictData];
//        // 字典转模型
//        BYDesign *product = [BYDesign objectWithKeyValues:statusDict];
//        // 添加模型到数组中
//        [products addObject:product];
//    }
//    return products;
//}
//
//- (void)fetchProductListByPageSize:(NSNumber *)pageSize pageNum:(NSNumber *)pageNum finish:(void (^)(NSArray *productList,BYError *error))finished{
//    
//    NSString *url = @"product/ProductList/ProductHomeList";
//    NSDictionary *param = @{@"pageSize":pageSize ,@"pageNo":pageNum};
//    
//    [BYNetwork get:url params:param finish:^(NSDictionary *data, BYError *error) {
//        
//        NSArray *arrList = data[@"productList"][@"ContentList"];
//        //        [self saveHomeStatusDictArray:arrList];
//        
//        NSArray *modelList = [BYDesign objectArrayWithKeyValuesArray:arrList];
//        finished(modelList,nil);
//        
//    }];
//    
//    //    NSArray *cachedHomeProduct = [self cachedHomeProduct];
//    //    if (cachedHomeProduct.count != 0) {//有缓存，从缓存中取
//    //        if(finished){
//    //            finished(cachedHomeProduct,nil);
//    //        }
//    //    }else {//没有缓存，重新下载
//    //        NSString *url = @"product/ProductList/ProductHomeList";
//    //        NSDictionary *param = @{@"pageSize":pageSize ,@"pageNo":pageNum};
//    //
//    //        [BYNetworkget:url params:param finish:^(NSDictionary *data, BYError *error) {
//    //
//    //            NSArray *arrList = data[@"productList"][@"ContentList"];
//    //            [self saveHomeStatusDictArray:arrList];
//    //
//    //            NSArray *modelList = [BYProduct objectArrayWithKeyValuesArray:arrList];
//    //            finished(modelList,nil);
//    //            
//    //        }];
//    //    }
//}
//@end

