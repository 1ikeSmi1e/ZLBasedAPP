//
//  MyTools.h
//  SP2P_6.1
//
//  Created by wujiandong on 15/11/13.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJSingleton.h"

@interface MyTools : NSObject <NSCopying, NSMutableCopying>

+ (void)tenderbtn:(UIButton *)tenderBtn updateWithBidStatus:(int)bid_status;
+ (void)gotoFinanceVCFromController:(UIViewController *)currentVC;
/**
 @return 过滤的字符串
 */
+ (NSString *)filterHTML:(NSString *)html;

//当前时间 是否在这个时间内
+(BOOL)isInTimeFromString:(NSString*)formString addMonth:(NSInteger) addMonths  day:(NSInteger) days;

//获取图片路径
+ (NSString *)getImageUrlPath:(NSString *)path;

//+ (MyTools *)sharedTools;
singletonH(Tools)

// 获取指定最大宽度、最大高度、字体大小的string的size
+ (CGSize)getSizeOfString:(NSString *)string
                 maxWidth:(float)width
                maxHeight:(float)height
             withFontSize:(CGFloat)fontSize;
/**
 *  获取指定最大宽度、最大高度、字体大小的string的size
 *
 *  @param string   计算的文字
 *  @param width    最大宽度
 *  @param height   最大高度
 *  @param font     自定义字体
 *
 *  @return size
 */
+ (CGSize)getTypeFaceSizeOfString:(NSString *)string
                         maxWidth:(float)width
                        maxHeight:(float)height
                         withFont:(UIFont *)font;
//返回button
+ (UIButton *)leftBarButton;

/**
 *  TextField左视图
 *
 *  @param imageName leftImage-->size
 *
 *  @return view
 */
+ (UIView *)textFieldLeftViewWithImageSize:(CGSize)imageSize
                                 imageName:(NSString *)imageName;

// 设置可变字体
+ (void)setAttributedLabel:(UILabel *)label rangeStr:(NSString *)rangeStr color:(UIColor *)color font:(UIFont *)font;
// 设置可变字体，获取可变字符串,行距
+ (NSMutableAttributedString *)getAttributedWithText:(NSString *)text rangeStr:(NSString *)rangeStr color:(UIColor *)color font:(UIFont *)font lineSpace:(CGFloat)lineSpace;
/**
 *  简单的富文本
 *
 *  @param text      需要处理的字符串
 *  @param textStart 富文本开始的位置
 *  @param textEnd   富文本结束的位置
 *  @param textColor 富文本颜色
 *  @param textFont  富文本字体
 *
 *  @return 处理后的富文本
 */
+ (NSMutableAttributedString *)getNSMutableAttributedStringWithText:(NSString *)text
                                                              start:(NSInteger)textStart
                                                                end:(NSInteger)textEnd
                                                          textColor:(UIColor *)textColor
                                                           textFont:(UIFont *)textFont;

/**
 *  简单的富文本
 *
 *  @param text      需要处理的字符串
 *  @param textStart 富文本开始的位置
 *  @param textEnd   富文本结束的位置
 *  @param textColor 富文本颜色
 *  @param textFont  富文本字体
 *
 *  @return 处理后的富文本
 */
+ (NSMutableAttributedString *)getAttributedStringWithText:(NSString *)text
                                                              start:(NSInteger)textStart
                                                                end:(NSInteger)textEnd
                                                          textColor:(UIColor *)textColor
                                                           textFont:(UIFont *)textFont;
/**
 * 给label设置可变字体
 */
+ (void)setAttributedString:(UILabel *)label rangeStr:(NSString *)rangeStr color:(UIColor *)color font:(UIFont *)font;


/**
 清除webview缓存和cookies
 */
+ (void)cleanCacheAndCookie;

/**
 * 给label设置字体行距
 */
+ (void)setAttributedString:(UILabel *)label lineSpace:(CGFloat)lineSpace;
+ (void)showNetworkActivityIndicator;
+ (void)hidenNetworkActitvityIndicator;
@end

@interface UIStoryboard (Ajax)
+ (UIViewController*)getControllerWithStoryboardID:(NSString*)storyboardID;
@end

@interface UIFont (MyTools)
+ (UIFont *)customFontWithSize:(CGFloat)size;
@end

@interface UILabel (MyTools)
+ (id)labelWithFrame:(CGRect)frame
                text:(NSString *)text
           textColor:(UIColor *)textColor
            textFont:(float)textFont
            fitWidth:(BOOL)fitWidth
           superview:(id)superview;


+ (id)labelWithFrame:(CGRect)frame
                text:(NSString *)text
           textColor:(UIColor *)textColor
            textFont:(float)textFont
            textAligment:(NSTextAlignment)textaligment
           superview:(id)superview;

/**
 * align = NSTextAlignmentCenter
 * default fontSize = 13.0f
 */
+ (id)labelWithFrame:(CGRect)frame
                text:(NSString *)text
            textFont:(float)fontSize
           backColor:(UIColor *)backColor
           superview:(id)superview;
@end

@interface UIImageView (MyTools)
+ (id)imageViewWithFrame:(CGRect)frame
               imageFile:(NSString *)imageFile
               superview:(id)superview;

@end

@interface UIView (MyTools)
+ (id)viewWithFrame:(CGRect)frame
    backgroundColor:(UIColor *)backgroundColor
          superview:(id)superview;

@end

@interface UIButton (MyTools)
+ (id)buttonWithFrame:(CGRect)frame
      backgroundColor:(UIColor *)backgroundColor
                title:(NSString *)title
           titleColor:(UIColor *)titleColor
            titleFont:(CGFloat)titleFont
               target:(id)target
               action:(SEL)action
            superview:(id)superview;

@end

@interface UITextField (MyTools)
+ (id)textFieldWithFrame:(CGRect)frame
                delegate:(id)delegate
                    text:(NSString *)text
               textColor:(UIColor *)textColor
                textFont:(float)textFont
             placeholder:(NSString *)placeholder
               superview:(id)superview;

@end

@interface UITableView (MyTools)
+ (id)tableViewWithFrmae:(CGRect)frame
         backgroundColor:(UIColor *)backgroundColor
                delegate:(id)delegate
          tableViewStyle:(UITableViewStyle)tableViewStyle
          separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
               superview:(id)superview;
@end

@interface UIScrollView (MyTools)
+ (id)scrollViewWithFrame:(CGRect)frame
                 delegate:(id)delegate
          backgroundColor:(UIColor *)backgroundColor
                superview:(id)superview;


@end

@interface UIBarButtonItem(MyTools)

+ (UIBarButtonItem *)leftBarButtonItemWithImage:(UIImage *)image
                                    highlighted:(UIImage *)highlightedImage
                                         target:(id)target
                                       selector:(SEL)selector;

+ (UIBarButtonItem *)rightBarButtonItemWithImage:(UIImage *)image
                                     highlighted:(UIImage *)highlightedImage
                                          target:(id)target
                                        selector:(SEL)selector;

+ (UIBarButtonItem *) leftBarButtonItemWithTitle:(NSString *)title
                                          target:(id)target
                                        selector:(SEL)selector;

+ (UIBarButtonItem *)rightBarButtonItemWithTitle:(NSString *)title
                                          titleColor:(UIColor*)titleColor
                                          target:(id)target
                                        selector:(SEL)selector;

@end
@interface UITextView (MyTools)
+ (instancetype)textViewWithFrame:(CGRect)frame
                        textColor:(UIColor *)textColor
                          bgColor:(UIColor *)color
                             font:(CGFloat)fontsize
                           superV:(UIView *)superView;

@end

@interface UIImage (MyTools)
+ (instancetype)placeholderImg;
@end

@interface NSString (MyTools)
/**
 * 生成3位数字加一个逗号格式的字符串
 */
+ (instancetype)numberformatStrFromDouble:(CGFloat)value;
/**
 * 生成两位小数带元的字符串
 */
+ (instancetype)strFromDouble:(CGFloat)value;
+ (instancetype)stringWithFormatNumberstring:(NSString*)value;
/**
 * 判断字符串是否是email格式
 */
- (BOOL)isEmail;
/**
 * 判断字符串是否是手机号码格式
 */
- (BOOL)isPhone;

/**
 * 判断正则匹配用户身份证号15或18位
 */
- (BOOL)isCheckUserIdCard;

/**
 * 判断是否不是全中文
 */
- (BOOL) deptNameInputShouldChinese;

/**
 * 字符串拼接简化
 */
- (instancetype)appendStr:(NSString *)str;
/**
 * 字符串加密,
 */
- (NSString*)md5;
+ (NSString *)encrypt3DES:(NSString *)src;
+ (NSString *)decrypt3DES:(NSString *)src;



/**
 根据服务器返回的状态字符串，得出红包的中文的状态

 @return 红包状态
 */
- (instancetype)getRedPacketStatusStr;

/**
 * 计算标的期限的
 */
+ (instancetype)strWithPeriod:(NSString *)period unit:(NSString*)periodUnit;

/**
 * self: 是后台传过来的秒
 */
- (NSComparisonResult)timeCompareNow;
/**
 * 获取图片地址
 */
- (instancetype)imgPath;

/**
 自动补齐路径和参数client=ios
 */
- (NSString *)ys_appendParam;
/**
 * 时间转换 ， 本身是后台传过来的一个数字的字符串 dateWithTimeIntervalSince1970
 * 格式 yyyy-MM-dd HH:mm:ss
 */
- (NSString *)timeToSecondWithFormat1;
/**
 * 时间转换 ， 本身是后台传过来的一个数字的字符串 dateWithTimeIntervalSince1970
 * 格式 yyyy-MM-dd HH:mm
 */
- (NSString *)timeToMinuteWithFormat1;
/**
 * 时间转换 ， 本身是后台传过来的一个数字的字符串 dateWithTimeIntervalSince1970
 * 格式 yyyy-MM-dd
 */
- (NSString *)timeToDayWithFormat1;
/**
 * 时间转换 ， 本身是后台传过来的一个数字的字符串 dateWithTimeIntervalSince1970
 * 格式 MM-dd
 */
- (NSString *)timeToMonthDayWithFormat1;

/**
 * 时间转换 ， 本身是后台传过来的一个数字的字符串 dateWithTimeIntervalSince1970
 * 格式 yyyy/MM/dd HH:mm:ss
 */
- (NSString *)timeToSecondWithFormat2;
/**
 * 时间转换 ， 本身是后台传过来的一个数字的字符串 dateWithTimeIntervalSince1970
 * 格式 yyyy/MM/dd HH:mm
 */
- (NSString *)timeToMinuteWithFormat2;
/**
 * 时间转换 ， 本身是后台传过来的一个数字的字符串 dateWithTimeIntervalSince1970
 * 格式 yyyy/MM/dd
 */
- (NSString *)timeToDayWithFormat2;
/**
 * 时间转换 ， 本身是后台传过来的一个数字的字符串 dateWithTimeIntervalSince1970
 * 格式 MM/dd
 */
- (NSString *)timeToMonthDayWithFormat2;

// *******  去掉 html字符串中所有标签  **********
- (NSString *)filterHTML;

@end

