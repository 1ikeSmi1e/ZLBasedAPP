//
//  YGCTradeWindow.h
//  DaGangCheng
//
//  Created by zhoubaitong on 16/3/9.
//  Copyright © 2016年 zhoubaitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGCTradeWindow : UIWindow

/** windows */
@property (nonatomic, strong) UIWindow *keyWD;

//@property (nonatomic, weak) UIView *bgView;

+ (instancetype)shareWindow;

/** 释放控制器显示 */
+ (void)showWithVc:(UIViewController *)showVc;
/** 释放控制器隐藏 */
+ (void)hide;

/** 传入一个控制器, 把它全屏modal出来 */
- (void)presentFullScreenWithVc:(UIViewController *)vc;

/** 存储控制器隐藏 */
- (void)hideNoDellocVc;
/** 存储控制器显示 */
- (void)showNoDellocVc;
/** 存储控制器无动画显示 */
- (void)showNoDellocVcNoAnima;

/** 返回keyWindow高度<显示的部分高度> */
+ (CGFloat)getWindowHeight;
/** 获取保存的keyWindow */
- (UIWindow *)getKeyWindow;

/** 是否正在显示 */
+ (BOOL)isShow;

@end
