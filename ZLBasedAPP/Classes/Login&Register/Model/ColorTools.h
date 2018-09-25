//
//  ColorTools.h
//  EnterpriseWeb
//
//  Created by 李小斌 on 14-5-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>


//设置RGB颜色值
#define SETCOLOR(R,G,B,A)	[UIColor colorWithRed:(CGFloat)R/255 green:(CGFloat)G/255 blue:(CGFloat)B/255 alpha:A]

#define KColor  [ColorTools colorWithHexString:@"#195a9c"]
// 每个View背景色值
#define KblackgroundColor  [ColorTools colorWithHexString:@"#f0f0f0"]
// 登录框 边框色值
#define KlayerBorder  [ColorTools colorWithHexString:@"#d9d9d9"]
//绿色颜色值
#define GreenColor [ColorTools colorWithHexString:@"#0096E5"]//#18b15f//#38a3b0
//粉红颜色值
#define PinkColor  [ColorTools colorWithHexString:@"#ce1a37"]//#e34f4f
//蓝色字体颜色值
#define BluewordColor  [ColorTools colorWithHexString:@"#436EEE"]
//边框色值
#define PlayerBorder [ColorTools colorWithHexString:@"#e7e7e7"]
//辅助红色
#define RedColor     [ColorTools colorWithHexString:@"#f4301c"]



@interface ColorTools : NSObject

/** 颜色转换 IOS中十六进制的颜色转换为UIColor **/
+ (UIColor *) colorWithHexString: (NSString *)color;

/** 给图片设置颜色 **/
+ (UIImage *)imageWithColor:(UIColor *)color;



@end
