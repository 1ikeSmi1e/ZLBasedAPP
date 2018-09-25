//
//  NSString+AJ.m
//  博天下平台
//
//  Created by 周利强 on 15/8/18.
//  Copyright (c) 2015年 周利强. All rights reserved.
//

#import "NSString+AJ.h"
#import "NSDate+AJax.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <sys/utsname.h>

@implementation NSString (URL)
- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

//32位MD5加密方式（大写用X,小写加密就用x） [result appendFormat:@"%02X", digest[i]];
//- (NSString *)Md5_32Bit_String{
//    const char *cStr = [self UTF8String];
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5( cStr, (uint32_t)strlen(cStr), digest );
//    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        //        大写
//        //        [result appendFormat:@"%02X", digest[i]];
//        //    小写
//        [result appendFormat:@"%02x", digest[i]];
//    return result;
//}
- (NSString*)md5
{
    const char *ptr = [self UTF8String];
    
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end
@implementation NSString (time)

+ (nullable instancetype)strWithValue:(id)value
{
    if (![value isEqual:[NSNull null]]) {
        return [NSString stringWithFormat:@"%@", value];
    }else{
        return nil;
    }
}
- (CGSize)textSizeWithMaxSize:(CGSize)maxsize font:(UIFont *)font
{
    return [self boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}
- (NSString *)getYear
{
    NSDate *createdDate = [self createAtToDateWithFormat:@"yyyy年"];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy";
    return [fmt stringFromDate:createdDate];
}
- (NSString *)getMonth
{
    NSDate *createdDate = [self createAtToDate];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月";
    return [fmt stringFromDate:createdDate];
}
- (NSString *)getMonthJustNumber
{
    NSDate *createdDate = [self createAtToDate];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM";
    return [fmt stringFromDate:createdDate];
}
- (NSString *)getActivityTimeWithEndTime:(NSString *)endTimestr
{
    NSDate *createdDate = [self createAtToDate];
    NSDate *endDate = [endTimestr createAtToDate];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    // 判断是否是同一天
    if ([createdDate isSameDayWithDate:endDate]) {
        // 开始时间
        fmt.dateFormat = @"MM月dd日HH:mm - ";
        NSString *begin = [fmt stringFromDate:createdDate];
        // 结束时间
        fmt.dateFormat = @"HH:mm";
        NSString *end = [fmt stringFromDate:endDate];
        return [begin stringByAppendingString:end];
    }else{
//#warning 没有判断活动是否跨年，：目前不需要
        // 开始时间
        fmt.dateFormat = @"MM月dd日HH:mm -";
        NSString *begin = [fmt stringFromDate:createdDate];
        // 结束时间
        fmt.dateFormat = @"MM月dd日HH:mm";
        NSString *end = [fmt stringFromDate:endDate];
        return [begin stringByAppendingString:end];
    }
}
- (NSString *)getDeadLine
{
    NSDate *createdDate = [self createAtToDate];
//    [createdDate isThisYear];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日HH:mm";
//#warning 没有判断活动是否跨年，：目前不需要
    return [fmt stringFromDate:createdDate];
}
- (NSDate *)createAtToDateFormat:(NSString*)fomat
{
    // _created_at == @"2015-09-21 14:36:53"
    // 1.获得微博的发送时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = fomat;
//#warning 真机调试下, 必须加上这段
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return  [fmt dateFromString:self];
}
- (NSDate *)createAtToDate
{
    // _created_at == @"2015-09-21 14:36:53"
    // 1.获得微博的发送时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//#warning 真机调试下, 必须加上这段
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return  [fmt dateFromString:self];
}
- (NSDate *)createAtToDateWithFormat:(NSString *)fomat
{
    // _created_at == @"2015-09-21 14:36:53"
    // 1.获得微博的发送时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat =fomat;
//#warning 真机调试下, 必须加上这段
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return  [fmt dateFromString:self];
}
- (instancetype)changeToMuseumCloseInfoWithFixedType:(FixedType)type
{
    NSMutableString *str = nil;
    switch (type) {
        case FixedTypeDay:// 固定日期
        {
//            str = [NSMutableString stringWithString:@"固定闭馆日期:"];
            str = [NSMutableString string];
            [str appendString:self];
            
        }
            return str;
            break;
        case FixedTypeWeek:// 固定星期几@"1,2,3,4,5,"
        {
            NSString *separator = @",";
            if (self.length == 1) {// 服务器数据至少有一个
                return [self weekdayWithNumber];
            }else{// 不止一个
                NSArray *arrTemp = [self componentsSeparatedByString:separator];
//                str = [NSMutableString stringWithString:@"固定闭馆日期:"];
                str = [NSMutableString string];
                NSString *add = nil;
                for (NSString *number in arrTemp) {
                    add = [number weekdayWithNumber];
                    [str appendString:add];
                    [str appendString:separator];
                }
                // 去掉末尾的分割字符
            NSString *strReturn =  [str substringToIndex:str.length - 1];
                return strReturn;
            }
        }
            break;
        case FixedTypeTempClose:// 临时闭关
            return self;
            break;
        case FixedTypeTempOpen:// 临时开馆
            return self;
            break;
        default:
            break;
    }
    return str;
}
- (instancetype)weekdayWithNumber
{
    int number = [self intValue];
    if (number < 1 || number > 7) {
        return nil;
    }
    NSString *base = @"星期";
    NSString *add = nil;
    switch (number) {
        case 1:
             add = @"一";
            break;
        case 2:
            add = @"二";
            break;
        case 3:
            add = @"三";
            break;
        case 4:
            add = @"四";
            break;
        case 5:
            add = @"五";
            break;
        case 6:
            add = @"六";
            break;
        default:
            add = @"日";
            break;
    }
    return [base stringByAppendingString:add];
}
@end
@implementation NSNumber (string)

- (NSString *)countToShow
{
    NSString *title = nil;
    long long count = [self longLongValue];
    if (count < 10000) { // 小于1W
        title = [NSString stringWithFormat:@"%lld", count];
    } else {
        double countDouble = count / 10000.0;
        title = [NSString stringWithFormat:@"%.1f万", countDouble];
        
        // title == 4.2万 4.0万 1.0万 1.1万
    }
    return [title stringByReplacingOccurrencesOfString:@".0" withString:@""];

}

@end


@implementation NSString (AttributedString)
-(NSAttributedString *)stringWithParagraphlineSpeace:(CGFloat)lineSpacing
                                           textColor:(UIColor *)textcolor
                                            textFont:(UIFont *)font {
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    // NSKernAttributeName字体间距
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@1.5f};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    // 创建文字属性
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:textcolor,NSFontAttributeName:font};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    return attriStr;
}

- (CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

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
 *******************************************************************/
-(NSAttributedString *)stringWithParagraphlineSpeace:(CGFloat)lineSpacing
                                           textColor:(UIColor *)textcolor
                                            textFont:(UIFont *)font
                                    withKeyTextColor:(UIColor *)KeyColor
                                             keyFont:(UIFont *)KeyFont
                                            keyWords:(NSArray *)KeyWords {
    
    NSAttributedString * AttributeString = [self stringWithParagraphlineSpeace:lineSpacing textColor:textcolor textFont:font compated:^(NSMutableAttributedString *attriStr) {
        NSDictionary * KeyattriBute = @{NSForegroundColorAttributeName:KeyColor,NSFontAttributeName:KeyFont};
        for (NSString * item in KeyWords) {
            NSRange  range = [self rangeOfString:item options:(NSCaseInsensitiveSearch)];
            [attriStr addAttributes:KeyattriBute range:range];
        }
    }];
    return AttributeString;
}

/********************************************************************
 *  基本校验方法
 *
 *  @param lineSpacing 行高
 *  @param textcolor   字体颜色
 *  @param font        字体
 *
 *  @return <#return value description#>
 ********************************************************************/
-(NSAttributedString *)stringWithParagraphlineSpeace:(CGFloat)lineSpacing
                                           textColor:(UIColor *)textcolor
                                            textFont:(UIFont *)font
                                            compated:(void(^)(NSMutableAttributedString * attriStr))compalted
{
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    // NSKernAttributeName字体间距
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@1.5f};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    // 创建文字属性
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:textcolor,NSFontAttributeName:font};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    if (compalted) {
        compalted(attriStr);
    }
    return attriStr;
}
@end

@implementation NSString (DeviceInfo)
+ (instancetype)iphoneType {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
}
/** 是否是iPhone X */
+ (BOOL)isIphoneX
{
    return [@"iPhone X" isEqualToString:[NSString iphoneType]];
}
@end
