//
//  UIImage+AJ.h
//  com.higgs.botrip
//
//  Created by 周利强 on 15/10/10.
//  Copyright © 2015年 周利强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface UIImage (AJ)

//programmatically create an UIImage with 1 pixel of a given color
+ (UIImage *)imageWithColor:(UIColor *)color;

//implement additional methods here to create images with gradients etc.
//[..]
+ (UIImage *)imageWithColorStart:(UIColor *)colorStart end:(UIColor *)colorEnd;

/**
 给现有图片加空白边距生成新图片

 @param insets 边距
 @return 新图片
 */
- (instancetype)addEdgeInset:(UIEdgeInsets)insets;


/**
 取出引导图的第一张
 
 @return 引导图的第一张
 */
+ (NSString *)md5_firstGuideImg;
@end

