//
//  UIColor+custom.h
//  MobilePaymentOS
//
//  Created by admin on 2018/4/18.
//  Copyright © 2018年 yinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(R, G, B)    [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:1.0]
// 白色字体颜色值
#define AJWhiteColor [UIColor whiteColor]
// 淡灰色背景颜色
#define AJGrayBackgroundColor [UIColor groupTableViewBackgroundColor]
#define NavgationColor  RGB(255,102,0)
#define GARYCOL [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0f]
#define BACKGRACOL [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1.0f]
#define TITLEGRAYCOL [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0f]

@interface UIColor (custom)

+ (instancetype)ys_black;
+ (instancetype)ys_darkGray;
+ (instancetype)ys_lightGray;
+ (instancetype)ys_blue;
+ (instancetype)ys_lightBlue;
+ (instancetype)ys_grayLine;// 灰色分割线
+ (instancetype)ys_grayBorder;// 灰色边框
+ (instancetype)ys_orange;// 橙色字体
+ (instancetype)ys_lightOrange;// 浅橙色字体颜色值（进度条末端）
+ (instancetype)ys_red;
+ (instancetype)ys_enable;
+ (instancetype)ys_green;

/** 颜色转换 IOS中十六进制的颜色转换为UIColor **/
+ (UIColor *) colorWithHexString: (NSString *)color;

/** 给图片设置颜色 **/
+ (UIImage *)imageWithColor:(UIColor *)color;
@end


@interface UIColor (RGBValues)

- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;

- (UIColor *)darkerColor;
- (UIColor *)lighterColor;
- (BOOL)isLighterColor;
- (BOOL)isClearColor;
@end
