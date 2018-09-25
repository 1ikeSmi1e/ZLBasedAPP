//
//  BaseViewController.m
//  SP2P_9
//
//  Created by Jerry on 15/9/22.
//  Copyright © 2015年 EIMS. All rights reserved.
//  所有控制器的基类

#import "ZLBaseViewController.h"

@interface ZLBaseViewController ()
@end

@implementation ZLBaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //取消手势返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    //背景颜色
    self.view.backgroundColor = AJGrayBackgroundColor;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.view endEditing:YES];
}

//这个方法会在用 KVC 方法赋值但 key 不存在时由系统调用
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    [SVProgressHUD showImage:nil status:key];
}



#pragma  mark - 没有网络或者请求数据出错时展示的view
- (void)showNoDataView
{
    for (UIView *subV in self.view.subviews) {
        
        if ([subV isKindOfClass:[NoDataView class]]) {
            
            return;
        }
    }
    NoDataView *view = [[NoDataView alloc] initWithFrame:CGRectMake(0, 64, MSWIDTH, MSHIGHT) delegate:self];
    [self.view addSubview:view];
}

- (void)hideNoDataView
{
    for (UIView *subV in self.view.subviews) {
        
        if ([subV isKindOfClass:[NoDataView class]]) {
            
            [subV removeFromSuperview];
            break;
        }
    }
}

- (UIViewController *)lastControllerAtNavPop
{
    NSInteger idx = [self.navigationController.viewControllers indexOfObject:self];
    
    return [self.navigationController.viewControllers objectAtIndex:idx-1];
}

@end
//@end
