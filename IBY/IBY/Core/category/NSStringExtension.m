//
//  NSStringExtension.m
//  IBY
//
//  Created by panshiyu on 14/11/7.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "NSStringExtension.h"
#import "CommonFunc.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (URLEncoding)

- (NSString*)generateMD5
{
    // Create pointer to the string as UTF8
    const char* ptr = [self UTF8String];

    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);

    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", md5Buffer[i]];

    return output;
}

- (NSString*)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
        (CFStringRef)self,
        NULL,
        (CFStringRef) @"!*'\"();:@&=+$,/?%#[]% ",
        CFStringConvertNSStringEncodingToEncoding(encoding)));
}
- (BOOL)isBYcardID
{
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"^[\\d\\*]{,10}$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    if (1 == numberOfMatches) {
        return YES;
    }
    return NO;
}
- (BOOL)isMobilePhoneNumber
{
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"^1[\\d\\*]{10}$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    if (1 == numberOfMatches) {
        return YES;
    }
    return NO;
}

- (NSString*)chineseMobileFormat
{
    if (![self isMobilePhoneNumber]) {
        return nil;
    }
    NSMutableString* str = [@"+86 " mutableCopy];
    [str appendString:self];
    [str insertString:@" " atIndex:7]; //第7个位置插入空格
    [str insertString:@" " atIndex:12];
    return [str copy];
}

- (BOOL)isZipcode
{

    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{6}$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    if (1 == numberOfMatches) {
        return YES;
    }
    return NO;
}

- (BOOL)isValidPassword
{
    if (self.length < 6 || self.length > 32) {
        return NO;
    }

    int matchCount = 0;

    //判断是否包含数字
    NSString* regex1 = @".*[0-9]+.*";
    NSPredicate* pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    BOOL isMatch1 = [pred1 evaluateWithObject:self];
    if (isMatch1) {
        matchCount++;
    }

    //判断是否包含小写字母
    NSString* regex2 = @".*[a-z]+.*";
    NSPredicate* pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    BOOL isMatch2 = [pred2 evaluateWithObject:self];
    if (isMatch2) {
        matchCount++;
    }

    //判断是否包含大写字母
    NSString* regex3 = @".*[A-Z]+.*";
    NSPredicate* pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex3];
    BOOL isMatch3 = [pred3 evaluateWithObject:self];
    if (isMatch3) {
        matchCount++;
    }

    //判断是否包含符号
    NSString* regex4 = @".*[\\W\\_]+.*";
    NSPredicate* pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex4];
    BOOL isMatch4 = [pred4 evaluateWithObject:self];
    if (isMatch4) {
        matchCount++;
    }

    //不要太简单啦
    return (matchCount > 1);
}

- (CGSize)sizeWithFont:(UIFont*)font maxSize:(CGSize)maxSize
{
    return [self boundingRectWithSize:maxSize
                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                           attributes:@{ NSFontAttributeName : font }
                              context:nil]
        .size;
}

- (NSString*)append:(NSString*)str
{
    if (!str) {
        str = @"";
    }

    return [NSString stringWithFormat:@"%@%@", self, str];
}

- (NSString*)appendNum:(int)num
{
    return [NSString stringWithFormat:@"%@%d", self, num];
}

#pragma mark -

- (NSDictionary*)parseURLParams
{
    NSString* query = [self copy];
    NSRange range = [query rangeOfString:@"?"];
    if (range.length > 0) {
        query = [query substringFromIndex:range.location + 1];
    }
    NSArray* pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    for (NSString* pair in pairs) {
        NSArray* kv = [pair componentsSeparatedByString:@"="];
        if ([kv isKindOfClass:[NSArray class]] && kv.count == 2) {
            NSString* val =
                [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:kv[0]];
        }
    }
    return [params copy];
}

#pragma mark -

- (NSString*)URLEncodedString
{

    return [self stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];

    //    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    //    CFStringRef str = (__bridge CFStringRef)self;
    //    CFStringEncoding encoding = kCFStringEncodingUTF8;
    //    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));

    //    NSString *newCountryString =[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    return newCountryString;
}

- (NSString*)URLDecodedString
{
    CFStringRef result = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
    NSString* tmpResult = CFBridgingRelease(result);
    return tmpResult;
}

- (NSString*)BYDESString
{
    return [CommonFunc encryptUseDES:self key:BYDES_EncryptionKey iv:BYDES_EncryptionIV];
}

#pragma mark - trimhtml

- (NSString*)stripHtml
{
    NSRange r;
    NSString* s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end

NSString* IntToString(int a)
{
    return [@(a) stringValue];
}
