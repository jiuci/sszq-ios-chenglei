//
//  BYGlassSampleView.m
//  IBY
//
//  Created by St on 15/4/7.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYGlassSampleView.h"
#import "BYImageView.h"
#import "BYGlasses.h"

@interface BYGlassSampleView ()

@property (nonatomic , strong) BYImageView*  imageView;

@property (nonatomic , strong) UIImageView*  frameImageView;

@property (nonatomic , strong) UIImageView*  selectedImageView;

@end

@implementation BYGlassSampleView


- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    _imageView = [[BYImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    
    [_imageView setImageUrl:_glassesUnit.smallImgURL];
    [self addSubview:_imageView];
    
//    _frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//    _frameImageView.image = [[UIImage imageNamed:@"camera_frame_selected"] resizableImage];
//    _frameImageView.hidden = YES;
//    [self addSubview:_frameImageView];
    
    _selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    _selectedImageView.image = [[UIImage imageNamed:@"camera_icon_selected"] resizableImage];
    _selectedImageView.right = self.width - 4;
    _selectedImageView.top = 4;
    _selectedImageView.hidden = YES;
    [self addSubview:_selectedImageView];
    
    [self addTapAction:@selector(selected) target:self];
}


- (void)cancelSelected{
    _frameImageView.hidden = YES;
    _selectedImageView.hidden = YES;
}

- (void)selected{
    if(!_parentVC){
        return;
    }
    [_parentVC selectedGlass:self];
    _selectedImageView.hidden = NO;
}

@end
