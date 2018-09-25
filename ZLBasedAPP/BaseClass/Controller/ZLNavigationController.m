//
//  FNavigationController.m
//  微金在线
//
//  Created by 首控微金财富 on 2017/5/15.
//  Copyright © 2017年 zhouli. All rights reserved.
//

#import "ZLNavigationController.h"

@interface ZLNavigationController ()

@end

@implementation ZLNavigationController

+ (void)initialize
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.hidden = YES;
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    [super setNavigationBarHidden:YES];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    [super setNavigationBarHidden:YES animated:animated];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    
    return self.topViewController;
}

//- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    NSArray *popedControllers = [super popToViewController:viewController animated:animated];
//    
////    DLOG(@"popedControllers =----- %@", popedControllers);// 略过了RegisterViewController、ForgetKeyController控制器,需要告知，已出栈，需移除_timer;
////    DLOG(@"subControllers =----- %@", self.viewControllers);
//    
//    for (UIViewController *popVC in popedControllers) {
//        
//        if ([popVC isKindOfClass:objc_getClass("RegisterViewController")] || [popVC isKindOfClass:objc_getClass("ForgetKeyController")] ) {
//            
//            [popVC viewDidDisappear:NO];
//        }
//    }
//    return popedControllers;
//}

//- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
//{
//    NSArray *popedControllers = [super popToRootViewControllerAnimated:animated];
//
////    DLOG(@"popedControllers =----- %@", popedControllers);// 略过了RegisterViewController、ForgetKeyController控制器,需要告知，已出栈，需移除_timer;
////    DLOG(@"subControllers =----- %@", self.viewControllers);
//
//    for (UIViewController *popVC in popedControllers) {
//
//        if ([popVC isKindOfClass:objc_getClass("RegisterViewController")] || [popVC isKindOfClass:objc_getClass("ForgetKeyController")] ) {
//
//            [popVC viewDidDisappear:NO];
//        }
//    }
//
//    return popedControllers;
//}
@end
