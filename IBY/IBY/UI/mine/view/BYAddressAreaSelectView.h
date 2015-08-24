//
//  BYAddressAreaSelectView.h
//  IBY
//
//  Created by St on 15/1/7.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBasePopoverView.h"
@class BYProvince;
@class BYCity;
@class BYArea;

typedef void (^dimissBlock)();
typedef void (^saveBlock)(BYProvince* province, BYCity* city, BYArea* area);

typedef enum {
    BYAddressTypeProvince = 0,
    BYAddressTypeCity = 1,
    BYAddressTypeArea = 2,

} BYAddressType;

@interface BYAddressAreaSelectView : BYBasePopoverView

@property (nonatomic, copy) saveBlock saveBlk;
@property (nonatomic, assign) BOOL hasData;
- (void)updateData:(BYProvince*)province city:(BYCity*)city area:(BYArea*)area;
- (void)showInfoByMark:(int)mark;
@end
