//
//  UITextField+custom.h
//  MobilePaymentOS
//
//  Created by admin on 2018/4/18.
//  Copyright © 2018年 yinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (custom)
+ (id)textFieldWithFrame:(CGRect)frame
                 leftImg:(NSString *)leftImg
                delegate:(id)delegate
                    text:(NSString *)text
               textColor:(UIColor *)textColor
                textFont:(float)textFont
             placeholder:(NSString *)placeholder
               superview:(id)superview;
@end

@interface AJTextField : UITextField
@end

@interface AJLeftImgField : AJTextField

- (instancetype)initWithFrame:(CGRect)frame leftImg:(NSString *)leftImg;
@end


// 圆角无边框输入框
@interface AJRoundConerField : UITextField

@end


// 边框输入框
@interface AJBorderField : UITextField

@end
