//
//  NSURL+UrlStringAutoAdjust.m
//  微金在线
//
//  Created by 首控微金财富 on 2018/1/16.
//  Copyright © 2018年 zhouli. All rights reserved.
//

#import "NSURL+UrlStringAutoAdjust.h"

@implementation NSURL (UrlStringAutoAdjust)

+ (void)load
{
    Method orignalMethod = class_getClassMethod(self, @selector(URLWithString:));
    Method exchangeMethod = class_getClassMethod(self, @selector(ys_URLWithString:));
    method_exchangeImplementations(orignalMethod, exchangeMethod);
}

+ (instancetype)ys_URLWithString:(NSString *)URLString
{
    if (URLString.length > 0) {// 中文转码
        
        // 检查有没有进行过编码，有编码的情况下不再进行编码
        // 取参数部分进行编码
        
        NSString *URLString2 = [URLString stringByRemovingPercentEncoding];
        NSString *lastPathComponent = URLString2.lastPathComponent;// 如果是lastPathComponent，则“？”后面必然是参数
        NSRange queryRange = [lastPathComponent rangeOfString:@"?"];//
        if (queryRange.location != NSNotFound && queryRange.length > 0) {
            NSString *queryOrignal = [lastPathComponent substringWithRange:NSMakeRange(queryRange.location+1, lastPathComponent.length -queryRange.location-1)];
            NSString *queryEncode = [queryOrignal stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSString *lastPathComponentEncode = [lastPathComponent stringByReplacingOccurrencesOfString:queryOrignal withString:queryEncode];
            NSString *URLString3 = [URLString2.stringByDeletingLastPathComponent stringByAppendingPathComponent:lastPathComponentEncode];
            
            URLString = URLString3;
        }
        
        return [self ys_URLWithString:URLString];
    }
    return nil;
}
@end
