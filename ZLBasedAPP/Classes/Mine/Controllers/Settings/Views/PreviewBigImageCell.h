//
//  PreviewBigImageCell.h
//  MobilePaymentOS
//
//  Created by YST on 16/6/20.
//  Copyright © 2016年 yinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//图片缩放比例
#define kMinZoomScale 0.6f
#define kMaxZoomScale 2.0f

//是否支持横屏
#define shouldSupportLandscape YES
#define kIsFullWidthForLandScape YES //是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES
@interface PreviewBigImageCell : UICollectionViewCell
@property (nonatomic, copy)   void(^singleTapBlock)();

- (void)configureWithBigImage:(UIImage *)bigImage andIsHidden:(BOOL)isHidden;

- (void)configureWithImageDict:(NSDictionary *)imageDict andIsHidden:(BOOL)isHidden;
@end
