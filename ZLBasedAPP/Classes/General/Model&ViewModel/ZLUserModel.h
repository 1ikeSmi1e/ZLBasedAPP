//
//  UserModel.h
//

#import "ZLBaseEntity.h"

@interface ZLUserModel : ZLBaseEntity

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *pwdStr;// 加密后的密码，

+ (ZLUserModel *)sharedUser;

@end

@interface ZLUserModel (Archiver)<NSCoding>
/**
 将用户数据储存在 NSUserDefaults
 */
- (void)saveTo_NSUserDefaults;


/**
 清除保存的用户
 */
+ (void)clearUser;
/**
 从NSUserDefaults中取出用户
 */
+ (instancetype)userFrom_NSUserDefaults;
@end



/* 
 1. 用户注册成功的下一步 --> 设置手势密码
 
 
 2. 用户使用账号密码登录成功后的下一步 ：
 {// 需要取出对应的账号的设置情况
 对应的用户手机号在手机中，未手动关闭（包括未设置的情况）手势密码登录的情况下： 设置手势密码，手势密码设置成功后，跳转和之前登录界面一样
 对应的用户手机号在手机中，手动关闭了手势密码登录的情况下：                和之前一样
 
 * 需注意，用户若用一个账号登录成功后，由于登录成功会新建UserModel对象刷新UserModel的属性isCloseGesture的值，所以登录成功后需要手动取出存储的对应账号的isCloseGesture
 }
 
 
 3. 登录过期弹出页面：
 {// 需要取出对应的账号的设置情况，要取出对应账号的开启关闭状态，NSUserDefaults中的bool类型，key为手机号拼接字符串CloseGesture
 *1. 已设置手势密码 && 未关闭。----> 弹手势登录
 *2. 未设置 || 关闭 。----> 弹登录
 }
 
 
 4. 储存修改的手势密码，手势密码开关状态。
 {
 *1. 储存手势密码时，手势密码参照，FristGestureLockViewController; 若用户输入原手势密码错误达5次，则需清除所有账号信息，重新登录（点击返回是回首页的操作，登录成功后是跳转设置密码，设置成功后是返回首页的操作）
 *2. 储存开关状态；要存对应账号的开启关闭状态，给APPdelegate的userinfo的isCloseGesture赋值即可自动保存
 }
 */
