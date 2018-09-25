//
//  UIButton+KK.h
//  SP2P_10
//
//  Created by md005 on 16/3/21.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (KK)

- (CGSize)sizeWithTitle:(NSString *)title font:(UIFont*)font;

+(id)buttonWithFrame:(CGRect)frame
                font:(CGFloat)font
          titleColor:(UIColor *)titleColor
         normalImage:(id)normalImage
        disableImage:(id)disableImage
              target:(id)target
              action:(SEL)action
               title:(NSString *)title
           superview:(id)superview;


@end
