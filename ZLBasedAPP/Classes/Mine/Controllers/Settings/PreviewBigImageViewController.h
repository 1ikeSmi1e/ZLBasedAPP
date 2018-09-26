//
//  PreviewBigImageViewController.h
//  MobilePaymentOS
//
//  Created by YST on 16/6/20.
//  Copyright © 2016年 yinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLSettingFeedBackController.h"

@interface PreviewBigImageViewController : UICollectionViewController
@property (nonatomic, strong) NSArray *imgsArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSArray *smallImageArray;
@property (nonatomic, assign) BOOL isTransmit;

+ (UICollectionViewLayout *)photoPreviewViewLayoutWithSize:(CGSize)size;
@end
