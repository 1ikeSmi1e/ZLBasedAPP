//
//  UIView+AJ.m
//  SP2P_6.1
//
//  Created by eims on 16/8/23.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "UIView+AJ.h"
#import "UIColor+custom.h"
#import <objc/runtime.h>

@implementation UIView (AJ)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY
{
     return CGRectGetMaxY(self.frame);
}
- (CGFloat)minX
{
    return CGRectGetMinX(self.frame);
}
- (CGFloat)minY
{
    return CGRectGetMinY(self.frame);
}


- (void)gradientViewWithFrame:(CGRect)frame
{
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            return;
        }
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGB(50, 150, 240).CGColor, (__bridge id)RGB(90, 60, 255).CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.f, 0.5);
    gradientLayer.frame = frame;
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)gradientView
{
    [self gradientViewWithFrame:self.bounds];
}

- (void)setCornerRadiu:(CGFloat)radius borderWidth:(CGFloat)border borderColor:(UIColor *)color
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = border;
}

- (void)removeGradientView
{
    for (CALayer *layer in self.layer.sublayers) {
        
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            
            [layer removeFromSuperlayer];
        }
    }
}

+ (CGFloat)getValueFromArray:(NSArray *)arr{
//    if (iPhoneX) {// 不成比例，只能列举的情况下使用
//        return [arr[0] floatValue];
//    }else if (iPhone6plus) {
//        return [arr[1] floatValue];
//    }else if (iPhone6) {
//        return [arr[2] floatValue];
//    }else if (iPhone5) {
//        return [arr[3] floatValue];
//    }else{// 4S
        return [arr[4] floatValue];
//    }
}
#pragma mark
- (void)shakeAnimation
{
    // 获取到当前的View
    CALayer *viewLayer = self.layer;
    
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    
    // 设置自动反转
    [animation setAutoreverses:YES];
    
    // 设置时间
    [animation setDuration:.06];
    
    // 设置次数
    [animation setRepeatCount:3];
    
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end

//@interface UIControl()
//@property (nonatomic, assign) NSTimeInterval custom_acceptEventTime;
//@end
//@implementation UIControl (Custom)
//
//+ (void)load
//{
//    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
//    SEL sysSEL = @selector(sendAction:to:forEvent:);
//    Method customMethod = class_getInstanceMethod(self, @selector(custom_sendAction:to:forEvent:));
//    SEL customSEL = @selector(custom_sendAction:to:forEvent:);
//    //添加方法 语法：BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types) 若添加成功则返回No
//    // cls：被添加方法的类  name：被添加方法方法名  imp：被添加方法的实现函数  types：被添加方法的实现函数的返回值类型和参数类型的字符串
//    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
//    //如果系统中该方法已经存在了，则替换系统的方法  语法：IMP class_replaceMethod(Class cls, SEL name, IMP imp,const char *types)
//    if (didAddMethod) {
//        class_replaceMethod(self, customSEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
//    }else{
//        method_exchangeImplementations(systemMethod, customMethod);
//    }
//}
//- (NSTimeInterval )custom_acceptEventInterval{
//    return [objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue];
//}
//- (void)setCustom_acceptEventInterval:(NSTimeInterval)custom_acceptEventInterval{
//    objc_setAssociatedObject(self, "UIControl_acceptEventInterval", @(custom_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (NSTimeInterval )custom_acceptEventTime{
//    return [objc_getAssociatedObject(self, "UIControl_acceptEventTime") doubleValue];
//}
//- (void)setCustom_acceptEventTime:(NSTimeInterval)custom_acceptEventTime{
//    objc_setAssociatedObject(self, "UIControl_acceptEventTime", @(custom_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (void)custom_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
//    // 如果想要设置统一的间隔时间，可以在此处加上以下几句
//    // 值得提醒一下：如果这里设置了统一的时间间隔，会影响UISwitch,如果想统一设置，又不想影响UISwitch，建议将UIControl分类，改成UIButton分类，实现方法是一样的
//    //     if (self.custom_acceptEventInterval <= 0) {
//    //         // 如果没有自定义时间间隔，则默认为2秒
//    //        self.custom_acceptEventInterval = 2;
//    //     }
//    // 是否小于设定的时间间隔
//    BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.custom_acceptEventTime >= self.custom_acceptEventInterval);
//    // 更新上一次点击时间戳
//    if (self.custom_acceptEventInterval > 0) {
//        self.custom_acceptEventTime = NSDate.date.timeIntervalSince1970;
//    }
//    // 两次点击的时间间隔小于设定的时间间隔时，才执行响应事件
//    if (needSendAction) {
//        [self custom_sendAction:action to:target forEvent:event];
//    }
//}
//@end
