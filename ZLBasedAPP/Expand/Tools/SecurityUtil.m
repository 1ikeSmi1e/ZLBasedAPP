//
//  PublicInstance.m
//  ShareCommunity
//
//  Created by dawe on 15/8/3.
//  Copyright (c) 2015年 sf.Inc. All rights reserved.
//

#import "SecurityUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#include <unistd.h>
//#import "GTMBase64.h"
#define EncryptionKey         @"M1L4EHL68LBKE4YK"
@implementation SecurityUtil

+(SecurityUtil *)securityutil{
    static SecurityUtil *shareVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareVC = [[SecurityUtil alloc] init];
    });
    return shareVC;
}


+ (NSString*) md5:(NSString*) str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    NSMutableString *hash = [NSMutableString string];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++)
    {
        [hash appendFormat:@"%02X",result[i]];
    }
    return [hash lowercaseString];
}

- (NSString*) getArrayString:(NSDictionary*) paraDic{
    if (![paraDic isKindOfClass:[NSDictionary class]] || paraDic.allKeys.count<=0) {
        return @"";
    }
    NSMutableString *debugStr = [[NSMutableString alloc] initWithFormat:@"{"];
    NSArray *keyArr = paraDic.allKeys;
    NSArray *sortKey = [keyArr sortedArrayUsingSelector:@selector(compare:)];

    for (NSString *value in sortKey) {
        [debugStr appendFormat:@"\"%@\":\"%@\",",value,[paraDic objectForKey:value]];
    }
    [debugStr replaceCharactersInRange:NSMakeRange(debugStr.length-1, 1) withString:@"}"];
    return debugStr;
    
//    NSMutableArray *arrtemp = paraDic.allKeys.mutableCopy;
//    [arrtemp sortUsingSelector:@selector(compare:)];
//    NSMutableString *param_JsonString = [NSMutableString stringWithString:@"{"];
//    for (int i=0; i<arrtemp.count; i++) {
//        NSString *key = arrtemp[i];
//        NSString *strappend = [NSString stringWithFormat:@"\"%@\":\"%@\",", key, paraDic[key]];
//        [param_JsonString appendString:strappend];
//    }
//    [param_JsonString replaceCharactersInRange:NSMakeRange(param_JsonString.length-1, 1) withString:@"}"];
//    return param_JsonString;
}


- (NSString*) getMD5sign:(NSString*) paraDic{
    NSString *firstMD5 = [[self class] md5:paraDic];
    NSString *sign = firstMD5;
    return sign;
}

//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - base64
+ (NSString*)encodeBase64Data:(NSData *)data {
//    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data {
//    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

#pragma mark - AES加密
//将string转成带密码的data
+(NSData*)encryptAESData:(NSString*)string {
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES256EncryptWithKey:EncryptionKey];
    return encryptedData;
}

//将带密码的data转成string
+(NSString*)decryptAESData:(NSData*)data {
    //使用密码对data进行解密
    NSData *decryData = [data AES256DecryptWithKey:EncryptionKey];
    //将解了密码的nsdata转化为nsstring
    NSString *string = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    return string;
}


@end


@implementation NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key {//加密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)AES256DecryptWithKey:(NSString *)key {//解密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}
@end
