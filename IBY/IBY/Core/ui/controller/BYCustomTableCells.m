//
//  BYCustomTableCells.m
//  IBY
//
//  Created by panshiyu on 14/12/29.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYCustomTableCells.h"

@implementation BYEmptyTableCell

- (void)setItem:(BYTableItem*)item
{
    super.item = item;
    self.showBottomLine = NO;
}

@end

BYTableItem* emptyItem(int height)
{
    return makeCodeTbItem(@"BYEmptyTableCell", height, nil, nil);
}