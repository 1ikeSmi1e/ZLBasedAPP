//
//  UIColor+custom.m
//  MobilePaymentOS
//
//  Created by admin on 2018/4/18.
//  Copyright © 2018年 yinsheng. All rights reserved.
//

#import "UIColor+custom.h"

@implementation UIColor (custom)
+ (instancetype)ys_black
{
    return  [self colorWithHexString:@"#323232"];
}
+ (instancetype)ys_darkGray
{
    return [self colorWithHexString:@"#646464"];
}
+ (instancetype)ys_lightGray
{
    return [self colorWithHexString:@"#969696"];
}

+ (instancetype)ys_green
{
    return [UIColor colorWithRed:37/255.f green:178/255.f blue:121/255.f alpha:1.0];
}

+ (instancetype)ys_blue
{
    return [self colorWithHexString:@"#3296F0"];
}
+ (instancetype)ys_lightBlue
{
    return [UIColor colorWithRed:6/255.f green:181/255.f blue:255/255.f alpha:1.0];
}
+ (instancetype)ys_grayLine
{// #F0F0F0
    return [UIColor colorWithRed:240/255.f green:240/255.f blue:240/255.f alpha:1.0];
}
+ (instancetype)ys_grayBorder
{
    return [UIColor colorWithRed:208/255.f green:208/255.f blue:208/255.f alpha:1.0];
}

+ (instancetype)ys_orange
{
    return [self colorWithHexString:@"#FF7900"];
}
+ (instancetype)ys_lightOrange
{
    return [UIColor colorWithRed:254/255.f green:190/255.f blue:143/255.f alpha:1.0];
}
+ (instancetype)ys_red
{
    return [self colorWithHexString:@"#FC5455"];
}
+ (instancetype)ys_enable
{
    return [UIColor colorWithRed:227/255.f green:227/255.f blue:227/255.f alpha:1.0];
}


#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0x"] || [cString hasPrefix:@"0X"] )
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


#pragma mark - 给图片设置颜色
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end


@implementation UIColor (RGBValues)

- (CGFloat)red {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[0];
}

- (CGFloat)green {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[1];
}

- (CGFloat)blue {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[2];
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

- (BOOL)isClearColor {
    return [self isEqual:[UIColor clearColor]];
}

- (BOOL)isLighterColor {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return (components[0]+components[1]+components[2])/3 >= 0.5;
}

- (UIColor *)lighterColor {
    if ([self isEqual:[UIColor whiteColor]]) return [UIColor colorWithWhite:0.99 alpha:1.0];
    if ([self isEqual:[UIColor blackColor]]) return [UIColor colorWithWhite:0.01 alpha:1.0];
    CGFloat hue, saturation, brightness, alpha, white;
    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:hue
                          saturation:saturation
                          brightness:MIN(brightness * 1.3, 1.0)
                               alpha:alpha];
    } else if ([self getWhite:&white alpha:&alpha]) {
        return [UIColor colorWithWhite:MIN(white * 1.3, 1.0) alpha:alpha];
    }
    return nil;
}

- (UIColor *)darkerColor {
    if ([self isEqual:[UIColor whiteColor]]) return [UIColor colorWithWhite:0.99 alpha:1.0];
    if ([self isEqual:[UIColor blackColor]]) return [UIColor colorWithWhite:0.01 alpha:1.0];
    CGFloat hue, saturation, brightness, alpha, white;
    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:hue
                          saturation:saturation
                          brightness:brightness * 0.75
                               alpha:alpha];
    } else if ([self getWhite:&white alpha:&alpha]) {
        return [UIColor colorWithWhite:MAX(white * 0.75, 0.0) alpha:alpha];
    }
    return nil;
}

@end
