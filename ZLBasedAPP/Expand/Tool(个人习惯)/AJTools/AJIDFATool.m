//
//  AJIDFATool.m
//  微金在线
//
//  Created by 首控微金财富 on 2017/9/22.
//  Copyright © 2017年 zhouli. All rights reserved.
//

#import "AJIDFATool.h"
#import <AdSupport/AdSupport.h>
#import "Macros_AJ.h"

@implementation AJIDFATool

+ (void)uploadIDFA{

    BOOL enabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    if (!enabled) return;

    NSString *idfa = [self getIDFA];
    if(!idfa) return;
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"identify"] = idfa;
    para[@"name"] = @"ios_wjzx";
//    [[NetController sharedNetController] getWithUrl:action_uploadIDFA parameters:para finish:^(NSError *error, WJResponse *responseObject) {
//        // 不做任何处理
//    }];
}

+ (void)deleteIDFASave
{
    NSString * const KEY_USERNAME_PASSWORD = @"com.danson.zzzz.usernamepassword";
    //测试用 清除keychain中的内容
    [self delete:KEY_USERNAME_PASSWORD];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_USERNAME_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
///**
// 从钥匙串中检查上传标志，有这个标志则不重新上传
// @return 之前是否过
// */
//+ (BOOL)checkLastUpload
//{
//    return NO;
//}

+ (NSString *)getIDFA{
    
    //定义存入keychain中的账号 也就是一个标识 表示是某个app存储的内容   bundle id就好
    NSString * const KEY_USERNAME_PASSWORD = @"com.danson.zzzz.usernamepassword";
    NSString * const KEY_PASSWORD = @"com.danson.zzzz.password";
    //测试用 清除keychain中的内容
//    [self delete:KEY_USERNAME_PASSWORD];
    
    //读取账号中保存的内容
    BOOL isUpload = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_USERNAME_PASSWORD];
    if(isUpload) return nil;
    
    NSMutableDictionary *readUserPwd = (NSMutableDictionary *)[self load:KEY_USERNAME_PASSWORD];

    //NSLog(@"keychain------><>%@",readUserPwd);
    if (!readUserPwd) {
        //如果为空 说明是第一次安装 做存储操作
//        NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *identifierStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionaryWithObject:identifierStr forKey:KEY_PASSWORD];
        [self save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KEY_USERNAME_PASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return identifierStr;
        
    }else{
        return nil;
        return [readUserPwd objectForKey:KEY_PASSWORD];
    }
}

//储存
+ (void)save:(NSString *)service data:(id)data {
    
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            
            service, (__bridge id)kSecAttrService,
            
            service, (__bridge id)kSecAttrAccount,
            
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            
            nil];
}

//取出
+ (id)load:(NSString *)service {
    
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        
        @try {
            
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
            
        } @catch (NSException *e) {
            
            DLOG(@"Unarchive of %@ failed: %@", service, e);
            
        } @finally {
            
        }
    }
    if (keyData)
        CFRelease(keyData);
    
    return ret;
}

//删除
+ (void)delete:(NSString *)service {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}
@end
