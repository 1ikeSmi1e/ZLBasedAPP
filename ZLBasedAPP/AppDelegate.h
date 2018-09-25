//
//  AppDelegate.h
//  ZLBasedAPP
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLUserModel.h"
static NSString * const FToolUserDidSaveARecordNotification = @"FToolUserDidSaveARecordNotification";

@class FAccountCategaries, FCurrentMonthRecord;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) ZLUserModel *userInfo;

@property (nonatomic,strong) FAccountCategaries *aFAccountCategaries;

@property (nonatomic,strong) FCurrentMonthRecord *currentMonthRecord;
@end

