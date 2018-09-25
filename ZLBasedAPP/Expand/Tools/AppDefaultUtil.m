//
//  AppDefaultUtil.m
//  SP2P_7
//
//  Created by  on 14+9+30.
//  Copyright (c) 201 EIMS. All rights reserved.
//

#import "AppDefaultUtil.h"

#define KEY_FIRST_LANCHER @"FirstLancher" // 记录用户是否第一次登陆，YES为是，NO为否

#define KEY_USER_ID @"UserId" // 用户Id

#define KEY_USER_NAME @"UserName" // 用户昵称

#define KEY_PHONE_NUM @"PhoneNum" // 手机号

#define KEY_PASSWORD @"Password" // 密码

#define NO_KEY_PASSWORD @"noPassword" // 密码(没有加密)

#define KEY_HEARD_IMAGE @"HeardImage" //头像

#define KEY_GESTURES_PASSWORD @"GesturesPassword" //手势密码

#define KEY_REMEBER_USER @"RemeberUser" //  记住用户
#define KEY_LOGSTATE @"logState" //  登录状态

static NSString * const Key_EmailAdress = @"EmailAdress";
@implementation AppDefaultUtil

static NSUserDefaults *defaults;
+ (void)load
{
    defaults = [NSUserDefaults standardUserDefaults];
}


+ (instancetype)sharedInstance {
    
    static AppDefaultUtil *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AppDefaultUtil alloc] init];
    });
    
    return _sharedClient;
}

// 手机号
-(void) setPhoneNum:(NSString *)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:KEY_PHONE_NUM];
    [defaults synchronize];
}

+ (void)setEmailAdress:(NSString *)emailAdress
{
    [defaults setObject:emailAdress forKey:Key_EmailAdress];
    [defaults synchronize];
}
+ (NSString *)getEmailAdress
{
    return [defaults objectForKey:Key_EmailAdress];
}


// 设置当前的登录状态
- (void)setLoginState:(BOOL)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:KEY_LOGSTATE];
    [defaults synchronize];
}

// 获取当前的登录状态
-(BOOL) isLoginState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:KEY_LOGSTATE];
}


// 密码 (des 加密后)
-(void) setPassword:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:KEY_PASSWORD];
    [defaults synchronize];
}



@end
