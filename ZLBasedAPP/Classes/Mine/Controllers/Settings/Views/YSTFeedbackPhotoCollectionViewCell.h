//
//  YSTFeedbackPhotoCollectionViewCell.h
//  MobilePaymentOS
//
//  Created by yscompany on 2017/5/10.
//  Copyright © 2017年 yinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 意见反馈选取照片cell
 */
@interface YSTFeedbackPhotoCollectionViewCell : UICollectionViewCell
@property (strong,nonatomic) UIImageView *profilePhoto;
@property(nonatomic,strong) UIImageView *BigImgView;
- (void)setBigImgViewWithImage:(UIImage *)img;
@end
