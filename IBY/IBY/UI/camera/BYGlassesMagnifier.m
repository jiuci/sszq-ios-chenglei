//
//  BYGlassesMagnifier.m
//  IBY
//
//  Created by kangjian on 15/5/18.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYGlassesMagnifier.h"

#import "UIImage+Resize.h"

@implementation BYGlassesMagnifier


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scale = 2.0;
        //self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.transform = CGAffineTransformMakeScale(1.0,-1.0);
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect newRect = CGRectMake(_location.x - self.size.width/2, _location.y - self.size.width/2, self.size.width, self.size.height);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(_baseIMG.CGImage, newRect);
    CGFloat width = CGImageGetWidth(subImageRef)*_scale;
    CGRect smallBounds = CGRectMake(-width/4, -width/4, width, width);
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextDrawImage(context, smallBounds, subImageRef);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.size.width/2, 0);
    CGContextAddLineToPoint(context, self.size.width/2, self.size.height);
    CGContextMoveToPoint(context, 0, self.size.height/2);
    CGContextAddLineToPoint(context, self.size.width, self.size.height/2);
    CGContextStrokePath(context);
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
}
-(void)setLocation:(CGPoint)location
{
    _location = location;
    [self setNeedsDisplay];
}
-(void)setScale:(float)scale
{
    _scale = scale;
    [self setNeedsDisplay];
}
@end
