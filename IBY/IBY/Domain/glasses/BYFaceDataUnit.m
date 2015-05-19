//
//  BYFaceDataUnit.m
//  IBY
//
//  Created by St on 15/3/30.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYFaceDataUnit.h"

@interface BYFaceDataUnit ()  <NSKeyedArchiverDelegate , NSKeyedUnarchiverDelegate>

@property (nonatomic , strong)NSString* mainPath;

@end

@implementation BYFaceDataUnit

- (id)init{
    self = [super init];
    if(self){
        NSArray* documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentPath = documents[0];
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-DD-HH-mm-ss"];
        NSString* currentTime = [formatter stringFromDate:[NSDate date]];
        _mainPath = [documentPath stringByAppendingPathComponent:currentTime];
        if(![[NSFileManager defaultManager] fileExistsAtPath:_mainPath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:_mainPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        _imgPath1 = nil;
        _imgPath2 = nil;
        _step1Finishied = NO;
        _step2Finishied = NO;
    }
    return self;
}

- (void)setImg1:(UIImage *)img distance:(float)dist{
    
    _distance = dist;
    
    NSData* imgData = UIImageJPEGRepresentation(img, 1.0);
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-DD-HH-mm-ss"];
    NSString* currentTime = [formatter stringFromDate:[NSDate date]];
    _imgPath1 = [_mainPath stringByAppendingPathComponent:currentTime];
    
    [[NSFileManager defaultManager] createFileAtPath:_imgPath1 contents:imgData attributes:nil];
}

- (void)setImg2:(UIImage *)img{
    
    NSData* imgData = UIImageJPEGRepresentation(img, 1.0);
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-DD-HH-mm-ss"];
    NSString* currentTime = [formatter stringFromDate:[NSDate date]];
    _imgPath2 = [_mainPath stringByAppendingPathComponent:currentTime];
    
    [[NSFileManager defaultManager] createFileAtPath:_imgPath2 contents:imgData attributes:nil];
}

- (UIImage*)getImg2{
    
    NSData* data = [[NSFileManager defaultManager] contentsAtPath:_imgPath2];
    UIImage* img = [UIImage imageWithData:data];
    
    return img;
}


-(id)initWithCoder: (NSCoder*)coder
{
    if(self= [super init])
    {
        self.imgPath1=[coder decodeObjectForKey:@"imgPath1"];
        self.imgPath2=[coder decodeObjectForKey:@"imgPath2"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_imgPath1 forKey:@"imgPath1"];
    [coder encodeObject:_imgPath2 forKey:@"imgPath2"];
}

- (BOOL)isValid {
    if (_imgPath2.length > 0 && [self getImg2] != nil) {
        return YES;
    }
    return NO;
}

-(float)distance
{
    if (_distance > 100 && _distance < 180) {
        return _distance;
    }
    CGPoint end = _lEye;
    CGPoint start = _rEye;
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    CGFloat unitDistance = sqrt((xDist * xDist) + (yDist * yDist));
    if (_facePixels > 0) {
        float faceWidth = _facePixels / unitDistance * 62;
        _distance = faceWidth;
        if ( _distance > 100 && _distance < 180) {
            return _distance;
        }
    }
    _distance = 62/.45;
    return 62/.45;
}

@end
