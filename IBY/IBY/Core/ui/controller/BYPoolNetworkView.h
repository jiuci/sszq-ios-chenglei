//
//  BYPoolNetworkView.h
//  IBY
//
//  Created by panshiyu on 15/1/4.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYPoolNetworkView : UIView
+ (instancetype)poolNetworkView;
@end

@interface BYEmptyView : UIView
@property (nonatomic, assign) CGFloat contentBottom;
+ (instancetype)emptyviewWithIcon:(NSString*)icon
                             tips:(NSString*)tips;
@end


