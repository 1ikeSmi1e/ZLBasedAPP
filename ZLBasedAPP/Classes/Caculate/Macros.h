//
//  Macros.h
//  ftool
//
//  Created by apple on 2018/6/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define BGC     [UIColor colorWithRed:(242.0 / 255.0f) green:(242.0 / 255.0f) blue:(242.0 / 255.0f) alpha:1.0f]
//十六进制颜色
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

#define baseNavColor [UIColor colorWithRed:(242.0 / 255.0f) green:(70.0 / 255.0f) blue:(14.0 / 255.0f) alpha:1.0f]  //导航栏颜色
#define baseBgColor UIColorFromHex(0xf5f5f5)   //背景颜色
#define baseBlackColor UIColorFromHex(0x333333)   //浅黑色调
#define baseDarkGrayColor UIColorFromHex(0x666666)  //深灰色调
#define baseGrayColor UIColorFromHex(0x999999)       //浅灰色调
#define LockBackColor UIColorFromHex(0x222836)    //手势密码背景颜色
#define baseBorderColor UIColorFromHex(0xe6e6e6)  //边框颜色
#define baseOrangeColor UIColorFromHex(0xfa5e0b)  //橙色色调
#define baseYellowColor UIColorFromHex(0xFAB742)  //浅黄色色调

#define ITHIGHT   44
#define CELLHIGHT 58
#define NAVBAR_HEIGHT  ADDBAR(44)
#define SEGMENTHEIGHT  40
#define SCALE    MSHIGHT / 568
#define WSCALE   MSWIDTH / 375
#define HSCALE   MSHIGHT / 667
#define TABLEHEIGHT MSHIGHT-NAVBAR_HEIGHT
#define MSWIDTH [UIScreen mainScreen].bounds.size.width
#define MSHIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define SINGLE_LINE_WIDTH .5f

#define CHANGETABBAR   @"ChangeTabbarIndex"
#define CLIENT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#endif /* Macros_h */
