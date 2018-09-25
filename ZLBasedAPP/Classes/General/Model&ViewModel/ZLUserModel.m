//
//  UserModel.m
//  dawe
//
//  Created by dawe on 16-8-12.
//  Copyright (c) 2016年 dawe. All rights reserved.
//

#import "ZLUserModel.h"
#import "AppDefaultUtil.h"
#import "AJExtension.h"
#import "Macros_AJ.h"

static NSString *const UserDefaultKey_userModel = @"userModel";

@implementation ZLUserModel

static NSUserDefaults *defaults;



+ (void)load
{
    defaults = [NSUserDefaults standardUserDefaults];
}


+ (ZLUserModel *)sharedUser
{
//    static UserModel *userModel_p = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        userModel_p = [[UserModel alloc] init];
//    });
    return AppDelegateInstance.userInfo;
}

@end


@implementation ZLUserModel(Archiver)

- (void)saveTo_NSUserDefaults
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey:UserDefaultKey_userModel];
    [defaults synchronize];
}

+ (instancetype)userFrom_NSUserDefaults
{
    NSData *userData = [defaults objectForKey:UserDefaultKey_userModel];
    if (!userData) return nil;
    ZLUserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    return user;
}

+ (void)clearUser
{
    [defaults removeObjectForKey:UserDefaultKey_userModel];
    [defaults synchronize];
}
//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        Class c = self.class;
        // 截取类和父类的成员变量
        while (c && c != [NSObject class]) {
            unsigned int count = 0;
            Ivar *ivars = class_copyIvarList(c, &count);
            for (int i = 0; i < count; i++) {
                
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
                id value = [aDecoder decodeObjectForKey:key];
                if (value) {
                    [self setValue:value forKey:key];
                }
            }
            // 获得c的父类
            c = [c superclass];
            free(ivars);
        }
    }
    return self;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    Class c = self.class;
    // 截取类和父类的成员变量
    while (c && c != [NSObject class]) {
        unsigned int count = 0;
        
        Ivar *ivars = class_copyIvarList(c, &count);
        
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            id value = [self valueForKey:key];
            
            [aCoder encodeObject:value forKey:key];
        }
        c = [c superclass];
        // 释放内存
        free(ivars);
    }
}
@end
