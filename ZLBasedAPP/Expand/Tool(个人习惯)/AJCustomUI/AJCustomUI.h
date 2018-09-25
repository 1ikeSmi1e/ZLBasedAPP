//
//  AJCustomUI.h
//  SP2P_9
//
//  Created by Ajax on 16/6/13.
//  Copyright © 2016年 Jerry. All rights reserved.
//

#ifndef AJCustomUI_h
#define AJCustomUI_h

#import "LDProgressView.h"
#import "UIButton+Custom.h"
#import "UITextField+custom.h"
#import "UIColor+custom.h"
#import "UIImage+AJ.h"
#import "MyTools.h"
#import "UIView+AJ.h"

// UI相关
#define MSWIDTH         [UIScreen mainScreen].bounds.size.width
#define MSHIGHT         CGRectGetHeight([UIScreen mainScreen].bounds)
#define RECT(x, y, w, h) CGRectMake(x, y, w, h)
#define EDGEINSET(top, left, bottom, right) UIEdgeInsetsMake(top, left, bottom, right)
// 按照ipnone6设计效果图缩放比例
#define AJScaleMiltiplier MSWIDTH/375
#define AJHeightMiltiplier MSHIGHT/667
#define AJHeightMiltiplier_Content (MSHIGHT-64)/(667-64)
#endif /* AJCustomUI_h */
