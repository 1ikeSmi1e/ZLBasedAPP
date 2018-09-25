//
//  ReLogin.h
//  SP2P_9
//
//  Created by md005 on 15/10/20.
//  Copyright © 2015年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReLogin : NSObject


/**
 请求接口，服务器返回登录超时信息是弹框提示

 @param viewController 当前控制器
 */
+ (void) oldOutTheTimeRelogin:(UIViewController *)viewController;


//+ (void) outTheTimeRelogin:(UIViewController *)viewController;


/**
 不弹框直接去登录的方法
检测登录方法判断appdelegate里面的userinfo是否为空
 @param viewController 当前控制器
 */
+ (void) goLogin:(UIViewController *)viewController;

@end
