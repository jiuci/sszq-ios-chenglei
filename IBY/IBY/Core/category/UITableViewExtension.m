//
//  UITableViewExtension.m
//  IBY
//
//  Created by pan Shiyu on 14/11/11.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "UITableViewExtension.h"
#import "TPKeyboardAvoidingTableView.h"

@implementation UITableView (helper)

+ (instancetype)tableViewWithFrame:(CGRect)frame delegete:(id)delegate
{
    UITableView* tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    //    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.delegate = delegate;
    tableView.dataSource = delegate;

    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    tableView.showsVerticalScrollIndicator = NO;
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    return tableView;
}

+ (instancetype)tableViewWithFrame:(CGRect)frame delegete:(id)delegate reuseClass:(Class)reuseClass reuseId:(NSString*)reuseId
{
    UITableView* tableView = [self tableViewWithFrame:frame delegete:delegate];
    [tableView registerClass:reuseClass forCellReuseIdentifier:reuseId];
    return tableView;
}

+ (instancetype)tableViewWithFrame:(CGRect)frame delegete:(id)delegate reuseNib:(UINib*)reuseNib reuseId:(NSString*)reuseId
{
    UITableView* tableView = [self tableViewWithFrame:frame delegete:delegate];
    [tableView registerNib:reuseNib forCellReuseIdentifier:reuseId];
    return tableView;
}

@end
