//
//  AppDefaultUtil.h
// zhouliqiang
//

#import <Foundation/Foundation.h>

@interface AppDefaultUtil : NSObject

/** 发送结算详情/月账单到邮件，保存用户输入的邮箱地址 */
+ (void)setEmailAdress:(NSString *)emailAdress;
+ (NSString *)getEmailAdress;

/**
 单例模式，实例化对象
 */
+ (instancetype)sharedInstance;

-(void) setPhoneNum:(NSString *)value;

// 保存最后一次登录的用户密码(des加密后)
-(void) setPassword:(NSString *)value;

// 设置当前的登录状态
- (void)setLoginState:(BOOL)value;

// 获取当前的登录状态
-(BOOL) isLoginState;


@end
