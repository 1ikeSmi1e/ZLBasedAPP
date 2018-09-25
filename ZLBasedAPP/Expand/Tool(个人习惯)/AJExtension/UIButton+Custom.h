//
//  UIButton+Custom.h
//  MobilePaymentOS
//
//  Created by admin on 2018/4/18.
//  Copyright © 2018年 yinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Custom)

@end
// 圆角
@interface AJCornerCircle : UIButton
@end
// 边界线
@interface AJBorderBtn : AJCornerCircle
@end
// 勾选框
@interface CheckBoxBtn : UIButton
@end

// 有圆角 + 阴影 + 斜角渐变色效果的按钮
@interface ShadowCornerBtn : UIButton
@end

// 左边图片右边文字的
@interface AJLeftImgBtn : UIButton
@end

@interface AJRightImgBtn : AJCornerCircle
@end

@interface AJBottomTitleBtn : UIButton

@end
