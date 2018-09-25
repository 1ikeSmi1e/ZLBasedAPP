//
//  NavBar.h
//  SP2P_9
//
//  Created by md005 on 15/11/30.
//  Copyright © 2015年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavBarDelegate <NSObject>

@optional
-(void)backItemClick;
-(void)nextItemClick;

@end

@interface NavBar : UIView

/** 左侧button*/
@property (nonatomic,strong, readonly)  UIButton *leftBtn;
/**  右侧button*/
@property (nonatomic,strong, readonly)  UIButton *rightBtn;
@property (nonatomic,weak)id <NavBarDelegate>delegate;
@property (nonatomic, assign) BOOL typeWhite;
@property (nonatomic, assign) BOOL leftBtnHiden;


- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title WithleftName:(NSString *)leftName WithRightName:(NSString *)rightName;


/**
 初始化导航栏，frame值默认

 @param title    标题
 @param leftName 左边返回按钮标题
 @param rightName 右边按钮文字
 @return 导航栏
 */
- (id)initWithTitle:(NSString *)title leftName:(NSString *)leftName rightName:(NSString *)rightName delegate:(id<NavBarDelegate>)delegate;
@end
