//
//  BYImageView.h
//  IBY
//
//  Created by panShiyu on 14-9-15.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BYImageViewTapDelegate;
@interface BYImageView : UIImageView
@property (nonatomic,weak)id<BYImageViewTapDelegate> tapDelegate;
@property (nonatomic,strong)NSString * jumpURL;
@property (nonatomic,assign)int categoryId;
- (void)setImageUrl:(NSString*)url;
- (void)setImageWithUrl:(NSString*)url placeholderName:(NSString*)placeholder;
- (void)setImageWithUrl:(NSString*)url placeholderName:(NSString*)placeholder finish:(void (^)(UIImage* image))finished;
- (void)onImagetap:(id)sender;

@end

@protocol BYImageViewTapDelegate<NSObject>
@optional

- (void)onImagetap:(BYImageView*)sender;

@end