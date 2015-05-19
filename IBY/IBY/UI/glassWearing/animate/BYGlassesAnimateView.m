//
//  BYGlassesAnimateView.m
//  IBY
//
//  Created by panshiyu on 15/5/8.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYGlassesAnimateView.h"

@implementation BYGlassesAnimateView{
    UIImageView* _faceView;
}

+ (instancetype)AnimateView {
    return [[self alloc] initWithFrame:BYRectMake(0, 0, 110, 110)];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _faceView = [[UIImageView alloc] initWithFrame:BYRectMake(0, 0, self.width, self.height)];
        NSMutableArray * imageArray = [NSMutableArray array];
        for (int i = 0; i < 23; i++) {
            NSString *filePath1 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"IMG000%.2d",i] ofType:@"jpg"];
            UIImage * image = [UIImage imageWithContentsOfFile:filePath1];
            [imageArray addObject:image];
        }
        _faceView.animationImages = imageArray;
        _faceView.animationDuration = 3.5;
        [self addSubview:_faceView];
        self.clipsToBounds = YES;
        [self resetStatus];
        
    }
    return self;
}

- (void)startAnimating {
    [self stopAnimating];
}

- (void)stopAnimating {
    [self resetStatus];
}


#pragma mark - 

- (void)resetStatus{
//    _faceView1.hidden = NO;
    [_faceView startAnimating];
}

@end
