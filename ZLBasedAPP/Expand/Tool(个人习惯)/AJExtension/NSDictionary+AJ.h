//
//  NSDictionary+AJ.h
// zhouliqiang
//

#import <Foundation/Foundation.h>

@interface NSDictionary (AJ)

/** 获取返回的状态 @return backCodeDict[@"busiState"] */
- (NSString *)busiState;
@end

//@interface NSObject (NSDictionary_safaValue)
// 这个分类是用来解决对字典取值时的对值使用避免奔溃的问题
// 使用时可用 dictionary[@"key"].ys_safeStringValue 即可得到字符串类型的值
// dictionary[@"key"].ys_safeStringValue <==> [YSTSwipSDKUtils getSafeString:dictionary[@"key"]]
// 其余数据类型的使用参照上面

//- (NSString *)ys_safeStringValue;
//- (CGFloat)ys_safeFloatValue;
//- (CGFloat)ys_safeBoolValue;
//@end
