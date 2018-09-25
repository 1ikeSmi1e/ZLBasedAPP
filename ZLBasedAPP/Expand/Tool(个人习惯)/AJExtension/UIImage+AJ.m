//
//  UIImage+AJ.m
//

#import "UIImage+AJ.h"
#import "UIColor+custom.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#include <unistd.h>

@implementation UIImage (AJ)

+ (UIImage *)imageWithColorStart:(UIColor *)colorStart end:(UIColor *)colorEnd
{
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 绘制颜色渐变
//    UIColor *color_middle = [UIColor colorWithHexString:@"#ff6a00"];
    colorStart = RGB(251,138,36);
    colorEnd = RGB(255,102,0);
    
    // 创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    // 创建起点颜色
//    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){251/255.0f, 138/255.0f, 36/255.0f, 1});
//    // 创建终点颜色
//    CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){255/255.0f, 102/255.0f, 0/255.0f, 1});
//    // 创建颜色数组
//    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
    NSArray *colors = @[(__bridge id) colorStart.CGColor, (__bridge id) colorEnd.CGColor];
    CGFloat locations[] = {0.0, 1.0};
    // 创建渐变对象
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, (__bridge CFArrayRef) colors, locations);
    
    // 释放颜色数组
//    CFRelease(colorArray);
    // 释放起点和终点颜色
//    CGColorRelease(beginColor);
//    CGColorRelease(endColor);
    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(0, 0), CGPointMake(1, 0), 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 释放渐变对象
    CGGradientRelease(gradientRef);
    // 释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
//    UIRectFill(rect);
  
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (instancetype)addEdgeInset:(UIEdgeInsets)insets
{
    CGRect rect = CGRectMake(0, 0, self.size.width + insets.left + insets.right, self.size.height + insets.top + insets.bottom);
    // create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [self drawInRect:CGRectMake(insets.left, insets.top, self.size.width, self.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (NSString *)md5_firstGuideImg
{
    NSString *imageName = @"guide_page1_640x960";
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    NSString *encryptStr = [self encodeBase64Data:[NSData dataWithContentsOfFile:imgPath]];
    
    NSString *result = [self md5:encryptStr];
    return result;
}

+ (NSString*)encodeBase64Data:(NSData *)data {
//    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}
+ (NSString*) md5:(NSString*) str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    NSMutableString *hash = [NSMutableString string];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++)
    {
        [hash appendFormat:@"%02X",result[i]];
    }
    return [hash lowercaseString];
}
@end
