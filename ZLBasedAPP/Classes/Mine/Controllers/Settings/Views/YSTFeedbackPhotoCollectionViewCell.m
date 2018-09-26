//
//  YSTFeedbackPhotoCollectionViewCell.m
//  MobilePaymentOS
//
//  Created by yscompany on 2017/5/10.
//  Copyright © 2017年 yinsheng. All rights reserved.
//

#import "YSTFeedbackPhotoCollectionViewCell.h"

@implementation YSTFeedbackPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _profilePhoto = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        
        _profilePhoto.contentMode = UIViewContentModeScaleAspectFill;
        
        _profilePhoto.clipsToBounds = YES;
        
        [self.contentView addSubview:_profilePhoto];
    }
    return self;
}
- (void)setBigImgViewWithImage:(UIImage *)img{
    if (_BigImgView) {
        _BigImgView.frame = _profilePhoto.frame;
        _BigImgView.image = img;
    }
    else{
        _BigImgView = [[UIImageView alloc]initWithImage:img];
        _BigImgView.frame = _profilePhoto.frame;
        [self insertSubview:_BigImgView atIndex:0];
    }
    _BigImgView.contentMode = UIViewContentModeScaleToFill;
}

@end
