//
//  Macros.h
//  Created by zhouliqiang 20180429
//

#ifndef Macros_AJ_h
#define Macros_AJ_h

// 应用程序托管
#define AppDelegateInstance	                        ((AppDelegate*)([UIApplication sharedApplication].delegate))

// 打印
#ifdef     DEBUG
#define                 DLOG(...)      NSLog(__VA_ARGS__)
#define                 DLOG_METHOD    NSLog(@"%s", __func__)
#define                 DLOGERROR(...) NSLog(@"%@传入数据有误",__VA_ARGS__)
#else
#define                 DLOG(...)
#define                 DLOG_METHOD
#define                 DLOGERROR(...)
#endif

#define ShowSuccessMessage(message)  [SVProgressHUD showImage:[UIImage imageNamed:@"vendor_sendsuccess"] status:message]
#define ShowLightMessage(message)  [SVProgressHUD showImage:nil status:message]


//默认图、占位图
#define kDefalutImage   [UIImage imageNamed:@"news_image_default"]
// 系统版本判断
#define isIOS9later [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9,0,0}]
#define isIOS10later [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){10,0,0}]
#define isIOS11later [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11,0,0}]

#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]
#endif /* Macros_h */
