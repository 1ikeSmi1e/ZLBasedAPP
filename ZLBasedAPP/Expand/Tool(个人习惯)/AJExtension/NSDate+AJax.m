//
//  NSDate+AJax.m
//  coredataDEMO
//
//  Created by 周利强 on 15/7/2.
//  Copyright (c) 2015年 周利强. All rights reserved.
//

#import "NSDate+AJax.h"

@implementation NSDate (AJax)
- (BOOL)isSameDayWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *dateCmps = [calendar components:unit fromDate:date];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == dateCmps.year) &&
    (selfCmps.month == dateCmps.month) &&
    (selfCmps.day == dateCmps.day);
}
/**
 *  是否为今天
 */
- (BOOL)isToday
{
    return [self isSameDayWithDate:[NSDate date]];
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}
- (BOOL)isSameYearWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *dateCmps = [calendar components:unit fromDate:date];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return dateCmps.year == selfCmps.year;
}
- (NSString*)Year
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年";
    return  [fmt stringFromDate:self];
}
/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    return [self isSameYearWithDate:[NSDate date]];
}
/**
 *  与现在的时间差距
 */
- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}
- (NSString *)getString
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日HH:mm";
//#warning 真机调试下, 必须加上这段
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return [fmt stringFromDate:self];
}
- (NSString *)YearMonthDay
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
//#warning 真机调试下, 必须加上这段
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return [fmt stringFromDate:self];
}
- (NSString*)YearMonthDayWithOne
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    //#warning 真机调试下, 必须加上这段
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return [fmt stringFromDate:self];

}

//得到本地时间，避免时区问题
//NSTimeZone *zone = [NSTimeZone systemTimeZone];
//NSInteger interval = [zone secondsFromGMTForDate:date];
//NSDate *localeDate = [date dateByAddingTimeInterval:interval];
@end
