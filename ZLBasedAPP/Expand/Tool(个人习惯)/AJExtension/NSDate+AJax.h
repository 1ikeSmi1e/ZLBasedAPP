//
//  NSDate+AJax.h
//  coredataDEMO
//
//  Created by 周利强 on 15/7/2.
//  Copyright (c) 2015年 周利强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AJax)
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

/**
 *  日期转化为字符串
 */
- (NSString *)getString;
/**
 *  判断是否是同一天
 */
- (BOOL)isSameDayWithDate:(NSDate*)date;
/**
 *  判断是否是同一年
 */
- (BOOL)isSameYearWithDate:(NSDate*)date;
/**
 *  取得今年
 */
- (NSString*)Year;

/**
 *  取得年月日
 */
- (NSString*)YearMonthDay;
/**
 *  取得年月日
 */
- (NSString*)YearMonthDayWithOne;
@end
