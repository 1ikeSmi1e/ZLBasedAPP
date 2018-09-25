//
//  NSString+AJ.h
//  博天下平台
//
//  Created by 周利强 on 15/8/18.
//  Copyright (c) 2015年 周利强. All rights reserved.
//

typedef NS_ENUM(NSInteger, FixedType){
    FixedTypeDay = 0,       // 日期
    FixedTypeWeek,  // 星期
    FixedTypeTempClose,
    FixedTypeTempOpen
};
#import <Foundation/Foundation.h>
//#import <CommonCrypto/CommonDigest.h>

@interface NSString (URL)
/**
 *  urlStr中文转化，可以用NSString的对象方法取代
 */
- (NSString *)URLEncodedString;

/*
 * 给字符串md5加密
 */
- (NSString *)md5;
/**
 *  urlStr中文转化，可以用NSString的对象方法取代
 */
//- (NSString *)Md5_32Bit_String;

@end
@interface NSString (time)
+ (instancetype)strWithValue:(id)value;
- (NSString *)getActivityTimeWithEndTime:(NSString *)endTimestr;
- (NSString *)getMonth;
- (NSString *)getDeadLine;
- (NSString *)getYear;
- (NSString *)getMonthJustNumber;
- (instancetype)changeToMuseumCloseInfoWithFixedType:(FixedType)type;
- (CGSize)textSizeWithMaxSize:(CGSize)maxsize font:(UIFont*)font;
- (NSDate *)createAtToDate;
- (NSDate *)createAtToDateFormat:(NSString*)fomat;
@end
@interface NSNumber (string)
- (NSString*)countToShow;
@end

@interface NSString (AttributedString)

/********************************************************************
 *  返回包含关键字的富文本编辑
 *
 *  @param lineSpacing 行高
 *  @param textcolor   字体颜色
 *  @param font        字体
 *  @param KeyColor    关键字字体颜色
 *  @param KeyFont     关键字字体
 *  @param KeyWords    关键字数组
 *
 *  @return
 ********************************************************************/
-(NSAttributedString *)stringWithParagraphlineSpeace:(CGFloat)lineSpacing
                                           textColor:(UIColor *)textcolor
                                            textFont:(UIFont *)font
                                    withKeyTextColor:(UIColor *)KeyColor
                                             keyFont:(UIFont *)KeyFont
                                            keyWords:(NSArray *)KeyWords;

@end

@interface NSString (DeviceInfo)
+ (instancetype)iphoneType;

/** 是否是iPhone X */
+ (BOOL)isIphoneX;
@end
