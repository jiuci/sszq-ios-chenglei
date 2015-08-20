//
//  BYShareSheet.h
//  IBY
//
//  Created by panshiyu on 14/11/20.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYBasePopoverView.h"
typedef void (^actionBlock)(int channelType);
@interface BYShareSheet : BYBasePopoverView

@property (nonatomic, copy) actionBlock actionBlk;

@property (nonatomic, copy) NSString* imgPath;
@property (nonatomic, assign) int designId;
@property (nonatomic, strong) UIImage* image;

@property (nonatomic, weak) UIViewController* fromVC;
- (void)addTopViewWithTitle:(NSString*)title desc:(NSString*)desc;

@end

@interface BYShareCell : UIView

+ (instancetype)cellWithTitle:(NSString*)title
                         icon:(NSString*)icon
                       target:(id)target
                          sel:(SEL)sel
                          tag:(int)tag;

@end
