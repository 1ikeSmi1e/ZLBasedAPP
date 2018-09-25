//
//  UIView+YGCExtension.h
//
//  Created by Young on 15/9/2.
//  Copyright (c) 2015年 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YGCExtension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;


@property (nonatomic, assign) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic, assign) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic, assign) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, assign) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic, assign) CGSize  size;        ///< Shortcut for frame.size.



/** 从xib中创建一个控件 */
+ (instancetype)viewFromXib;

/** 
 * 获取到父视图
 * subView 想要获取哪个视图的父视图(一般传self)
 * parentViewClass 传父视图的类型（如[UISCrollview Class]）
 * return id
 */
- (id)GetParentViewBySubView:(UIView *)subView parentViewClass:(Class)parentViewClass;

/**
 * 获取到父视图的控制器
 * subView 想要获取哪个视图的父视图的控制器(一般传self)
 * parentViewControllerClass 传父视图的类型（如[UIViewController Class]）
 * return id
 */
- (id)GetParentViewControllerBySubView:(UIView *)subView ParentViewControllerClass:(Class)parentViewControllerClass;

//递归查找子视图
- (UIView *)findViewWithClassName:(NSString *)aName;


@end
