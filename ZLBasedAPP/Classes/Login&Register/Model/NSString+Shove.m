//
//  NSString+Shove.m
//  Shove
//
//  Created by  on 14-8-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import "NSString+Shove.h"

@implementation NSString (Shove)

/* 
 * 判断字符串是否为空白的
 */
- (BOOL)isBlank
{
    if ((self == nil) || (self.length == 0)) {
        return YES;
    }
    
    NSString *trimedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimedString length] == 0) {
        return YES;
    } else {
        return NO;
    }
    
    return YES;
}

/* 
 * 判断字符串是否为空
 */
- (BOOL)isEmpty
{
    return ((self.length == 0) || (self == nil) || ([self isKindOfClass:[NSNull class]]) );
}

/* 
 * 给字符串md5加密
 */
- (NSString*)md5
{
    const char *ptr = [self UTF8String];

    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

/**
 * 判断字符串是否是email格式
 */
- (BOOL)isEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/**
 * 判断字符串是否是手机号码格式
 */
- (BOOL)isPhone
{
    NSString *phoneRegex = @"^(1[2-9][0-9])\\d{8}$";
    NSPredicate *regextesPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [regextesPhone evaluateWithObject:self];
}

/**
 * 判断是否有两位小数点
 */
- (BOOL)isTwoDecimal
{
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:self];
}

@end
