//
//  AJImgBrowser.h
//  SP2P_7
//
//  Created by eims on 16/11/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJImgBrowser : UIView


/**
 查看一张图片

 @param name 图片名、或者图片网络路径
 */
- (void)lookSingleImg:(NSString *)name;

/** 设置图片路径数组 */
- (void)setImageUrls:(NSArray *)imgurls;

- (void)showWithBeginView:(UIView *)view;
//- (void)dissmiss;
@end
