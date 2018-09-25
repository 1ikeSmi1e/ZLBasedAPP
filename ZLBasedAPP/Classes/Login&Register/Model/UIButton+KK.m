//
//  UIButton+KK.m
//  SP2P_10
//
//  Created by md005 on 16/3/21.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "UIButton+KK.h"
#import "ColorTools.h"

@implementation UIButton (KK)


- (CGSize)sizeWithTitle:(NSString *)title font:(UIFont*)font
{
	self.titleLabel.font = font;
	[self setTitle:title forState:UIControlStateNormal];
	CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.titleLabel.font.fontName size:self.titleLabel.font.pointSize+2]}];
	return titleSize;
}


+(id)buttonWithFrame:(CGRect)frame
                font:(CGFloat)font
          titleColor:(UIColor *)titleColor
         normalImage:(id)normalImage
        disableImage:(id)disableImage
              target:(id)target
              action:(SEL)action
               title:(NSString *)title
           superview:(id)superview {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    button.backgroundColor = [UIColor clearColor];
    if ([normalImage isKindOfClass:[UIColor class]])
    {
        UIColor *color = (UIColor *)normalImage;
        [button setBackgroundImage:[ColorTools imageWithColor:color] forState:UIControlStateNormal];
    }
    else if ([normalImage isKindOfClass:[NSString class]])
    {
        [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    }

    if ([disableImage isKindOfClass:[UIColor class]])
    {
        UIColor *color = (UIColor *)disableImage;
        [button setBackgroundImage:[ColorTools imageWithColor:color] forState:UIControlStateDisabled];
    }
    else if ([disableImage isKindOfClass:[NSString class]])
    {
        [button setBackgroundImage:[UIImage imageNamed:disableImage] forState:UIControlStateDisabled];
    }else{
        [button setBackgroundImage:disableImage forState:UIControlStateDisabled];
    }
    
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (superview) {
        [superview addSubview:button];
    }
    return button;
}



@end
