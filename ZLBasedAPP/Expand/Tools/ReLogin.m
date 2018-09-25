//
//  ReLogin.m
//  SP2P_9
//
//  Created by md005 on 15/10/20.
//  Copyright © 2015年 EIMS. All rights reserved.
//

#import "ReLogin.h"
//#import "LoginViewController.h"
//#import "NavigationController.h"
//#import "AppDefaultUtil.h"
//#import "GestureLockViewController.h"

@interface ReLogin()//<HTTPClientDelegate>
//@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation ReLogin

//- (NetWorkClient *)requestClient{
//	if (!_requestClient) {
//		_requestClient = [[NetWorkClient alloc] init];
//		_requestClient.delegate = self;
//	}
//	return _requestClient;
//}
//


+ (void)oldOutTheTimeRelogin:(UIViewController *)viewController;
{

}

//登录超时调用方法
+ (void)outTheTimeRelogin:(UIViewController *)viewController{

//    GestureViewWindow *kwin = [GestureViewWindow sharedInstance];
//   //kwin.delegate = self;
//	[kwin show];
//    return;
//    LoginViewController *loginView = [[LoginViewController alloc] init];
//    MyNavigationController *loginNVC = [[MyNavigationController alloc] initWithRootViewController:loginView];
//    if ([AppDefaultUtilisLoginState]) {
//        loginView.backType = LoginTimeOut;
//    }
//    [viewController presentViewController:loginNVC animated:YES completion:nil];
}

//未登录调用方法
+ (void)goLogin:(UIViewController *)viewController 
{
//    // 一般情况下，点击返回或者登陆成功都是退下导航栏控制器，但是在未登录点击个人中心的情况下需要返回首页
//    UserModel *user = [UserModel userFrom_NSUserDefaults];
//    NSString *gesturesPassword = [AppDefaultUtil getGesturesPasswordWithAccount:user.phone];
//    if (!user.isCloseGesture && gesturesPassword.length > 0) {
//
//        GestureLockViewController *loginView = [[GestureLockViewController alloc] init];
//        loginView.backType = 250;
//        NavigationController *loginNVC = [[NavigationController alloc] initWithRootViewController:loginView];
//        [viewController presentViewController:loginNVC animated:YES completion:nil];
//    }else{
//
//        LoginViewController *loginView = [[LoginViewController alloc] init];
//        NavigationController *loginNVC = [[NavigationController alloc] initWithRootViewController:loginView];
//        [viewController presentViewController:loginNVC animated:YES completion:nil];
//    }
}


@end
