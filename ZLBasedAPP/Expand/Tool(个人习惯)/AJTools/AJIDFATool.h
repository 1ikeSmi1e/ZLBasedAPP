//
//  AJIDFATool.h
//  微金在线
//
//  Created by 首控微金财富 on 2017/9/22.
//  Copyright © 2017年 zhouli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJIDFATool : NSObject


/**
 上传IDFA至服务器
 */
+ (void)uploadIDFA;


/**
 清除钥匙串存储
 */
+ (void)deleteIDFASave;

+ (NSString *)getIDFA;
@end
