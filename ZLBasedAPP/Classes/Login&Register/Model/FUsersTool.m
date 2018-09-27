//
//  FUsersTool.m
//  ftool
//
//  Created by apple on 2018/6/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FUsersTool.h"
#import "NSString+encryptDES.h"

#define KEY_DefaultUser @"FkDefaultUser" //默认用户

#define KEY_UserList @"FkUserList" //用户列表

#define KEY_Name @"name"
#define KEY_Pwd  @"pwd"


@implementation FUsersTool

//保存一个默认账号
+(void)setDefaultUser{
//    NSString *DESkey = @"fdsa )(";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *desPwd = [NSString encrypt3DES:defNamePass key:DESkey]; //密码加密保存
    NSDictionary *defUser = [NSDictionary dictionaryWithObjectsAndKeys:defName,KEY_Name, desPwd, KEY_Pwd, nil];
    [defaults setObject:defUser forKey:KEY_DefaultUser];
    
    NSMutableArray *userList = [NSMutableArray arrayWithObjects:defUser, nil];
    [defaults setObject:userList forKey:KEY_UserList]; //保存默认用户到列表中
}

//登录 密码要加密
+(BOOL) loginUser:(NSString *)name andPassword:(NSString *)desPwd{
//    NSDictionary *defaultUser = [[NSUserDefaults standardUserDefaults] dictionaryForKey:KEY_DefaultUser];
//    if([[defaultUser objectForKey:KEY_Name] isEqualToString:name] && [[defaultUser objectForKey:KEY_Pwd] isEqualToString:desPwd]) return YES;
    
    NSMutableArray *userList = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:KEY_UserList];
    for(NSDictionary *item in userList){
//        NSLog(@"item = %@", item);
        if ([[item objectForKey:KEY_Name] isEqualToString:name] && [[item objectForKey:KEY_Pwd] isEqualToString:desPwd]) {
            return YES;
        }
    }

    return NO;
}

//注册用户到列表中  密码要加
+(BOOL) registUser:(NSString *)name andPassword:(NSString *)desPwd{
    if([self isExsits:name]){
        NSLog(@"用户已存在： %@",name);
    }else {
        NSMutableArray *userList = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:KEY_UserList];
        NSDictionary *regUser = [NSDictionary dictionaryWithObjectsAndKeys:name,KEY_Name,desPwd, KEY_Pwd, nil];
        [userList addObject:regUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

//修改注册用户到列表中  密码
+(void)modifyPwdWithUser:(NSString *)name password:(NSString *)desPwd{
    
    NSMutableArray *userList = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:KEY_UserList];
    for(NSDictionary *item in userList){
        //        NSLog(@"item = %@", item);
        if ([[item objectForKey:KEY_Name] isEqualToString:name]) {
            [userList removeObject:item];
            
            NSDictionary *regUser = [NSDictionary dictionaryWithObjectsAndKeys:name,KEY_Name,desPwd, KEY_Pwd, nil];
            [userList addObject:regUser];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ShowLightMessage(@"密码修改成功!");
        }
    }
}

//用户是否已存在
+(BOOL) isExsits:(NSString *)username{
    NSMutableArray *userList = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:KEY_UserList];
    for(NSDictionary *item in userList){
//        NSLog(@"exsit.item = %@", item);
        if ([[item objectForKey:KEY_Name] isEqualToString:username]) {
            return YES;
        }
    }
    return NO;
}

@end
