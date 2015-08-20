//
//  BYTableCell.h
//  IBY
//
//  Created by panshiyu on 14/12/29.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@class BYTableItem, BYTableCell;

typedef void (^BYTbviewTapBlock)(UITableView* tbview, NSIndexPath* indexPath, BYTableItem* item, BYTableCell* cell);
typedef CGFloat (^BYTbCellHeightBlock)(BYTableItem* item);

//cellClassName 和 cellNibName不可以都为空
@interface BYTableItem : NSObject {
    NSString* _cellClassName;
    NSString* _cellNibName;
    Class _cellClass;
    CGFloat _cellHeight;
    SEL _selectAction;
}
@property (nonatomic, copy) NSString* cellClassName;
@property (nonatomic, copy) NSString* cellNibName;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) BYTbviewTapBlock tapBlock;
@property (nonatomic, strong) id cellData;
@property (nonatomic, copy) BYTbCellHeightBlock cellHeightBlock;
@property (nonatomic, strong) NSMutableDictionary* cacheDict;

+ (id)itemWithCellClassName:(NSString*)cellClassName;
+ (id)itemWithCellNibName:(NSString*)cellNibName;

@end

@interface BYTableCell : UITableViewCell
//一般用不到
@property (nonatomic, strong) UIImageView* arrowView;
@property (nonatomic, strong) UIImageView* bottomLine;

@property (nonatomic, assign) BOOL showRightArrow;
@property (nonatomic, assign) BOOL showBottomLine;
@property (nonatomic, strong) BYTableItem* item; //set方法去做UI更新
@end

#pragma mark - quick tools

BYTableItem* makeCodeTbItem(NSString* cellClassName, CGFloat height, id data, BYTbviewTapBlock blk);
BYTableItem* makeNibTbItem(NSString* cellNibName, CGFloat height, id data, BYTbviewTapBlock blk);
BYTableItem* makeCodeTbItemWithHeightBlk(NSString* cellClassName, BYTbCellHeightBlock cellHeightBlk, id data, BYTbviewTapBlock blk);
BYTableItem* makeNibTbItemWithHeightBlk(NSString* cellNibName, BYTbCellHeightBlock cellHeightBlk, id data, BYTbviewTapBlock blk);
