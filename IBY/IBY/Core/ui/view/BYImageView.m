//
//  BYImageView.m
//  IBY
//
//  Created by panShiyu on 14-9-15.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYImageView.h"
#import "UIImageView+WebCache.h"
#import "BYCommonWebVC.h"
@implementation BYImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageUrl:(NSString*)url
{
    if (!url || [url isKindOfClass:[NSNull class]]) {
        BYLog(@"error image");
        return;
    }

    [self setImageWithUrl:url placeholderName:@"icon_placeholder"];
}

- (void)setImageWithUrl:(NSString*)url placeholderName:(NSString*)placeholder
{
    if (!url || [url isKindOfClass:[NSNull class]]) {
        BYLog(@"error image");
        return;
    }

    if (placeholder) {
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholder]];
    }
    else {
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageDelayPlaceholder];
    }
}

- (void)setImageWithUrl:(NSString*)url placeholderName:(NSString*)placeholder finish:(void (^)(UIImage* image))finished
{
    if (!url || [url isKindOfClass:[NSNull class]]) {
        BYLog(@"error image");
        return;
    }

    UIImage* placeHolder = placeholder ? [UIImage imageNamed:placeholder] : nil;

    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolder options:placeHolder ? 0 : SDWebImageDelayPlaceholder completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, NSURL* imageURL) {
        finished(image);
    }];
}
- (void)onImagetap:(id)sender;
{
    JumpToWebBlk(self.jumpURL, nil);
}
@end
