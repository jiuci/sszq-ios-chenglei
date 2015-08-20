//
//  BYTableCell.m
//  IBY
//
//  Created by panshiyu on 14/12/29.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYTableCell.h"
#import "Masonry.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BYTableItem

+ (id)itemWithCellClassName:(NSString*)cellClassName
{
    BYTableItem* item = [[self alloc] init];
    item.cellClassName = cellClassName;
    return item;
}

+ (id)itemWithCellNibName:(NSString*)cellNibName
{
    BYTableItem* item = [[self alloc] init];
    item.cellNibName = cellNibName;
    return item;
}

- (id)init
{
    self = [super init];
    if (self) {
        _cellHeight = 44;
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return self;
}

@end

@implementation BYTableCell

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] description]];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        self.showBottomLine = YES;
        self.showRightArrow = NO;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];

    self.showBottomLine = YES;
    self.showRightArrow = NO;
}

- (void)setShowRightArrow:(BOOL)showRightArrow
{
    if (showRightArrow) {
        [self.contentView bringSubviewToFront:self.arrowView];
        _arrowView.hidden = NO;
    }
    else {
        _arrowView.hidden = YES;
    }
    [self setNeedsDisplay];
}

- (void)setShowBottomLine:(BOOL)showBottomLine
{
    if (showBottomLine) {
        [self.contentView bringSubviewToFront:self.bottomLine];
        _bottomLine.hidden = NO;
    }
    else {
        _bottomLine.hidden = YES;
    }
    [self setNeedsDisplay];
}

- (UIImageView*)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = makeSepline();
        [self.contentView addSubview:_bottomLine];

        [_bottomLine mas_makeConstraints:^(MASConstraintMaker* make) {
            make.width.equalTo(self.mas_width);
            make.height.equalTo(@1);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return _bottomLine;
}

- (UIImageView*)arrowView
{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_right"]];
        [self addSubview:_arrowView];

        [_arrowView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.size.equalTo(_arrowView);
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).with.offset(12);
        }];
    }
    return _arrowView;
}

@end

#pragma mark -

BYTableItem* makeCodeTbItem(NSString* cellClassName, CGFloat height, id data, BYTbviewTapBlock blk)
{
    BYTableItem* item = [BYTableItem itemWithCellClassName:cellClassName];
    item.cellHeight = height;
    item.cellData = data;
    item.tapBlock = blk;
    return item;
}

BYTableItem* makeNibTbItem(NSString* cellNibName, CGFloat height, id data, BYTbviewTapBlock blk)
{
    BYTableItem* item = [BYTableItem itemWithCellNibName:cellNibName];
    item.cellHeight = height;
    item.cellData = data;
    item.tapBlock = blk;
    return item;
}

BYTableItem* makeCodeTbItemWithHeightBlk(NSString* cellClassName, BYTbCellHeightBlock cellHeightBlk, id data, BYTbviewTapBlock blk)
{
    BYTableItem* item = [BYTableItem itemWithCellClassName:cellClassName];
    item.cellHeightBlock = cellHeightBlk;
    item.cellData = data;
    item.tapBlock = blk;
    return item;
}

BYTableItem* makeNibTbItemWithHeightBlk(NSString* cellNibName, BYTbCellHeightBlock cellHeightBlk, id data, BYTbviewTapBlock blk)
{
    BYTableItem* item = [BYTableItem itemWithCellNibName:cellNibName];
    item.cellHeightBlock = cellHeightBlk;
    item.cellData = data;
    item.tapBlock = blk;
    return item;
}
