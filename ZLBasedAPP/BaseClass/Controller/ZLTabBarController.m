//
//  TabBarController.m
//  Created by 周利强 on 15/8/10.
//  Copyright (c) 2015年 周利强. All rights reserved.
//

#import "ZLTabBarController.h"
#import "FCounterViewController.h"
#import "FMineController.h"
#import "FHomeViewController.h"
#import "FLoginViewController.h"
#import "ZLTouTiaoNewsController.h"

@interface ZLTabBarController () < UITabBarControllerDelegate>


@end

@implementation ZLTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    FHomeViewController *home = [[FHomeViewController alloc] init];
    home.title = @"首页";
    ZLNavigationController *nav1 = [[ZLNavigationController alloc] initWithRootViewController:home];
    [self addChildViewController:nav1];

//    FCounterViewController *vender = [[FCounterViewController alloc] init];
//    vender.title = @"计算器";
//    ZLNavigationController *nav2 = [[ZLNavigationController alloc] initWithRootViewController:vender];
//    [self addChildViewController:nav2];

    
    ZLTouTiaoNewsController *TiaoNews = [[ZLTouTiaoNewsController alloc] init];
    TiaoNews.title = @"资讯";
    ZLNavigationController *nav4 = [[ZLNavigationController alloc] initWithRootViewController:TiaoNews];
    [self addChildViewController:nav4];
    
    FMineController *personal = [[FMineController alloc] init];
    personal.title = @"我的";
    ZLNavigationController *nav3 = [[ZLNavigationController alloc] initWithRootViewController:personal];
    [self addChildViewController:nav3];

    self.tabBar.tintColor = NavgationColor;
    if (isIOS10later) {
        self.tabBar.unselectedItemTintColor = [UIColor ys_darkGray];
    }
    UITabBarItem *tabbarItem0 = [self getBarItemWithTitle:@"首页" imageName:@"Tabbar_home_unselected"];
    nav1.tabBarItem = tabbarItem0;
//    UITabBarItem *tabbarItem1 = [self getBarItemWithTitle:@"投资计算" imageName:@"Tabbar_finance_unselected"];
//    nav2.tabBarItem = tabbarItem1;
    UITabBarItem *tabbarItem2 = [self getBarItemWithTitle:@"我的" imageName:@"Tabbar_my_unselected"];
    nav3.tabBarItem = tabbarItem2;

    UITabBarItem *tabbarItem3 = [self getBarItemWithTitle:@"资讯" imageName:@"Tabbar_News_unselected"];
    nav4.tabBarItem = tabbarItem3;
    self.delegate = self;

}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    NSLog(@"%s %@", __FUNCTION__, viewController.tabBarItem.title);
    //判断的是当前点击的tabBarItem的标题
    if ([viewController.tabBarItem.title isEqualToString:@"我的"] && ![[AppDefaultUtil sharedInstance]isLoginState]) {
        
//        如果未登录，则跳转登录界面
        FLoginViewController *loginView = [[FLoginViewController alloc] init];
        UINavigationController *loginNVC = [[UINavigationController alloc] initWithRootViewController:loginView];

        [((UINavigationController *)tabBarController.selectedViewController) presentViewController:loginNVC animated:YES completion:nil];
//
        return NO;
    }
    else{
        return YES;
    }
}


/*获取底部栏按钮*/
- (UITabBarItem *)getBarItemWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    UIImage *normalImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selectedImage = [[UIImage imageNamed:[imageName stringByReplacingOccurrencesOfString:@"unselected" withString:@"selected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//    UITabBarItem *tabbarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage tag:99];
    UITabBarItem *tabbarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    return tabbarItem;
}

@end
