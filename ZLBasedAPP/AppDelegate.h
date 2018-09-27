//
//  AppDelegate.h
//  ZLBasedAPP
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#define kRequestUrlPath_test @"http://szhb56.cn/TestTiny.txt"
#define kRequestUrlPath_appstore @"http://szhb56.cn/JiZhang.txt"

#define APPStorDate [NSDate setYear:2018 month:10 day:22 hour:7 minute:30] // 预计App Store的审核时间
#ifdef     DEBUG
#define JLBDebug
#else
#define JLBRealse
#endif

#ifdef JLBDebug
#define kRequestUrlPath kRequestUrlPath_test
#else
#define kRequestUrlPath kRequestUrlPath_appstore
#endif



#import <UIKit/UIKit.h>
#import "ZLUserModel.h"
static NSString * const FToolUserDidSaveARecordNotification = @"FToolUserDidSaveARecordNotification";

@class FAccountCategaries, FCurrentMonthRecord;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) ZLUserModel *userInfo;

@property (nonatomic,strong) FAccountCategaries *aFAccountCategaries;

@property (nonatomic,strong) FCurrentMonthRecord *currentMonthRecord;

- (void)PostRequest;
@end


