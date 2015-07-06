//
//  NSStringExtension.h
//  IBY
//
//  Created by panshiyu on 14/11/7.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (helper)

//MD5一下
- (NSString*)generateMD5;

//encoding & decoding
- (NSString*)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
- (NSString*)URLEncodedString;
- (NSString*)URLEncodedStringForMweb;
- (NSString*)URLDecodedString;

// url params
- (NSDictionary*)parseURLParams;

///by des
- (NSString*)BYDESString;

//validator
- (BOOL)isBYcardID;
- (BOOL)isMobilePhoneNumber;
- (BOOL)isZipcode;
- (BOOL)isValidPassword;

//quick append
- (NSString*)append:(NSString*)str;
- (NSString*)appendNum:(int)num;

- (CGSize)sizeWithFont:(UIFont*)font maxSize:(CGSize)maxSize;

//remove html

- (NSString*)stripHtml;

//convert 185xxxxxxx to  "+86 185 xxx xxxx"
- (NSString*)chineseMobileFormat;

@end

NSString* IntToString(int a);