//
//  BaseViewController.h
//  SP2P_9
//
//  Created by Jerry on 15/9/22.
//  Copyright © 2015年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLNavBar.h"
#import "NoDataView.h"

typedef enum : NSUInteger {
    BackType_PopToRoot = 10,
    BackType_PopToLast,
    BackType_dissmiss,
    BackType_Home,
    BackType_gestureLoginForgetGestureSetGestureBack // 特殊,忘记手势密码，在登录后设置手势密码点返回，不要设置为关闭手势密码
} BackType; // 控制器—返回类型

@class NetWorkClient;
@interface ZLBaseViewController : UIViewController<NavBarDelegate, NoDataViewDelegate>



@property (nonatomic, strong) NetWorkClient *requestClient;

/*! @abstract 每个导航条都是自定义view，系统的被隐藏了
 */
@property (nonatomic, weak)    ZLNavBar *navBar;
- (void)showNoDataView;
- (void)hideNoDataView;

/**
 获取在navcontroller栈里面上一个控制器
 */
- (UIViewController *)lastControllerAtNavPop;


@end


