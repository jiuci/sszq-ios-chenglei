//
//  UIBarButtonItem+Extension.m
//  IBY
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 coco. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (UIBarButtonItem*)barItemWithImgName:(NSString*)imageName
                           highImgName:(NSString*)highImageName
                                target:(id)target
                                action:(SEL)action
{
    UIButton* button = [UIButton buttonWithNormalIconName:imageName hlIconName:highImageName];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem*)barItemWithImgName:(NSString*)imageName
                           highImgName:(NSString*)highImageName
                               handler:(void (^)(id sender))handler
{
    UIButton* button = [UIButton buttonWithNormalIconName:imageName hlIconName:highImageName];
    if (handler) {
        [button bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem*)barItemWithTitle:(NSString*)title
                             handler:(void (^)(id sender))handler
{
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;

    NSDictionary* attributes = @{ NSFontAttributeName : Font(16) };
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    btn.width = rect.size.width > 70 ? rect.size.width : 70;
    //    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_nav"] resizableImage] forState:UIControlStateNormal];
    if (handler) {
        [btn bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    }

    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem*)barItemWithTitle:(NSString*)title
                              target:(id)target
                                 sel:(SEL)selector
{
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_nav"] resizableImage] forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark -

+ (UIBarButtonItem*)emptyBarItem
{
    return [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]];
}

+ (UIBarButtonItem*)backBarItem:(void (^)(id sender))handler
{
    UIButton* button = [UIButton buttonWithNormalIconName:@"btn_nav_back" hlIconName:@"btn_nav_back"];
    if (handler) {
        [button bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem*)moreBarItem:(void (^)(id sender))handler
{
    UIButton* btn = [[UIButton alloc] init];
    btn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0); //top, left, bottom, right
    [btn setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    btn.size = CGSizeMake(btn.currentImage.size.width, btn.currentImage.size.height + 20);
    [btn bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
