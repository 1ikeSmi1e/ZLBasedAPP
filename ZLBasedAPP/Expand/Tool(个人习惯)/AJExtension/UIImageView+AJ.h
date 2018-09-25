//
//  UIImageView+AJ.h
//  SP2P_9
//
//  Created by eims on 17/2/8.
//  Copyright © 2017年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AJ)


/**
 将文字转成二维码展示

 @param urlStr 要生成二维码的文字
 */
- (void)showQRCodeWithStr:(NSString *)urlStr;


-(void)yh_setImage:(NSURL *)imageUrl;
@end
