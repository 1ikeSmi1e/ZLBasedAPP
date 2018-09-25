//
//  PublicInstance.h
//  ShareCommunity
//
//  Created by dawe on 15/8/3.
//  Copyright (c) 2015年 sf.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SecurityUtil : NSObject


+(SecurityUtil *)securityutil;

//字典转NString，sort排序
- (NSString*) getArrayString:(NSDictionary*) paraDic;

//MD5加密
- (NSString*) getMD5sign:(NSString*) paraDic;

//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic;

#pragma mark - base64
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;
+ (NSString*)md5:(NSString*) str;
#pragma mark - AES加密
//将string转成带密码的data
+ (NSData*)encryptAESData:(NSString*)string;
//将带密码的data转成string
+ (NSString*)decryptAESData:(NSData*)data;

@end

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

@end
