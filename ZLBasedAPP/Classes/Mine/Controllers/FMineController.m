//
//  MineController.m
//  ftool
//
//  Created by admin on 2018/6/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FMineController.h"
#import "FMineCell.h"
#import "FMyIncomeRecordController.h"
#import "FMyExpandseRecordController.h"
#import "FMonthIncomeRecordController.h"
#import "FMonthExpandseRecordController.h"
#import "FMonthBudgetRecordController.h"
#import "FMyIncomeRecordCell.h"// 今日记录
#import "FMyExpandseRecordCell.h"// 今日记录
#import "FTakeRecordFatherController.h"
#import "KYWaterWaveView.h"
#import "ProductItem.h"
#import "ZLSettingsController.h"

@interface FMineController ()
@property (nonatomic, weak) KYWaterWaveView *ratioView;
@property (nonatomic, weak) UIView *tongView;
@property (nonatomic, weak) UILabel *incomeL;
@property (nonatomic, weak) UILabel *expandseL;
@property (nonatomic, weak) UILabel *budgetL;

@property (nonatomic, strong) FAccountRecord *todayNewestRecord;
@property (nonatomic, copy) NSString *todayNewestRecordType;// 支出还是收入

@property (nonatomic, weak) UILabel *todayRecordCountL;
//
@property (nonatomic, weak) UILabel *recordStateL;
@property (nonatomic, weak) FMyIncomeRecordCell *todayIncomeRecordView;
@property (nonatomic, weak) FMyExpandseRecordCell *todayExpandseRecordView;

@end
static NSString * const reuseIdentifier = @"FMineCell";
@implementation FMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    ProductItem *itme1 = [ProductItem itemWithTitle:@"收入记录" icon:@"Mine_incomRecord"];
    ProductItem *itme2 = [ProductItem itemWithTitle:@"支出记录" icon:@"Mine_expandseRecord"];
    self.dataArray = @[itme1, itme2].mutableCopy;
    
    [self updateTodayRecordView];
}


/** 筛选最新的一条记录 */
- (void)selectNewestRecord{
    // 查出今天的支出记录
    NSMutableArray *expandseArr = AppDelegateInstance.currentMonthRecord.expandseArr.mutableCopy;
   
    [expandseArr sortUsingComparator:^NSComparisonResult(FAccountRecord *obj1, FAccountRecord *obj2) {
        
        return [obj1.editTime compare:obj2.editTime];
    }];
    FAccountRecord *newestExpandse = expandseArr.lastObject;// 最新
    
    // 查出今天的收入记录
    NSMutableArray *IncomeArr = AppDelegateInstance.currentMonthRecord.incomeArr.mutableCopy;

    [IncomeArr sortUsingComparator:^NSComparisonResult(FAccountRecord *obj1, FAccountRecord *obj2) {
        
        return [obj1.editTime compare:obj2.editTime];
    }];
    FAccountRecord *newestIncome = IncomeArr.lastObject;// 最新
    
    NSComparisonResult result = [newestExpandse.editTime compare:newestIncome.editTime];
    if (result == NSOrderedAscending) {
        
        self.todayNewestRecord = newestIncome;
        self.todayNewestRecordType = @"Income";
    }else{
        self.todayNewestRecordType = @"Expandse";
        self.todayNewestRecord = newestExpandse;
    }
}

- (void)updateTodayRecordView{
    
    [self selectNewestRecord];
    // 比较firstType是在哪个数组
    if ([self.todayNewestRecordType isEqualToString:@"Income"]) {

        self.recordStateL.hidden = YES;
        self.todayIncomeRecordView.hidden = NO;
        self.todayExpandseRecordView.hidden = YES;

        self.todayIncomeRecordView.timeL.text = [self.todayNewestRecord.time_minute substringFromIndex:3];
        self.todayIncomeRecordView.textL.text = self.todayNewestRecord.subType.name;
        self.todayIncomeRecordView.imgV.image = [UIImage imageNamed:self.todayNewestRecord.subType.iconName];
        self.todayIncomeRecordView.moneyL.text = [NSString stringWithFormat:@"￥%.2f", self.todayNewestRecord.amount];

    }else{
        self.recordStateL.hidden = YES;
        self.todayIncomeRecordView.hidden = YES;
        self.todayExpandseRecordView.hidden = NO;

        self.todayExpandseRecordView.timeL.text = [self.todayNewestRecord.time_minute substringFromIndex:3];
        self.todayExpandseRecordView.textL.text = self.todayNewestRecord.subType.name;
        self.todayExpandseRecordView.imgV.image = [UIImage imageNamed:self.todayNewestRecord.subType.iconName];
        self.todayExpandseRecordView.moneyL.text = [NSString stringWithFormat:@"￥%.2f", self.todayNewestRecord.amount];
    }

    // 显示今日记录有几条
     NSInteger today = [NSDate date].day;
    NSInteger todayexpandseCount = 0;
    for (FAccountRecord *expandse in AppDelegateInstance.currentMonthRecord.expandseArr) {
        
        //MM月dd日HH时mm分
        NSInteger recordDay = [expandse.time_minute substringWithRange:NSMakeRange(3, 2)].integerValue;
        if (recordDay == today) {
            todayexpandseCount += 1;
        }
    }
    NSInteger todayIncomeCount = 0;
    for (FAccountRecord *income in AppDelegateInstance.currentMonthRecord.incomeArr) {
        
        //MM月dd日HH时mm分
        NSInteger recordDay = [income.time_minute substringWithRange:NSMakeRange(3, 2)].integerValue;
        if (recordDay == today) {
            todayIncomeCount += 1;
        }
    }
    self.todayRecordCountL.text = [NSString stringWithFormat:@"收支记录共%ld笔", todayexpandseCount + todayIncomeCount];
    
    if (!self.todayNewestRecord) {
        self.recordStateL.hidden = NO;
        self.todayIncomeRecordView.hidden = YES;
        self.todayExpandseRecordView.hidden = YES;
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 更新数据
    CGFloat monthIncome = 0;
    for (FAccountRecord *incomeRecord in AppDelegateInstance.currentMonthRecord.incomeArr) {
        monthIncome += incomeRecord.amount;
    }
    self.incomeL.text = [NSString numberformatStrFromDouble:monthIncome];
    

    
    CGFloat monthExpandse = 0;
    for (FAccountRecord *expandseRecord in AppDelegateInstance.currentMonthRecord.expandseArr) {
        monthExpandse += expandseRecord.amount;
    }
    self.expandseL.text = [NSString numberformatStrFromDouble:monthExpandse];
    
    CGFloat monthBudget = 0;
    
    for (FFirstType *typeBean in AppDelegateInstance.aFAccountCategaries.expensesTypeArr) {
        monthBudget += typeBean.budget;
    }
    if (monthBudget > 0) {
        self.budgetL.font = [UIFont systemFontOfSize:20];
        self.budgetL.text = [NSString numberformatStrFromDouble:monthBudget - monthExpandse];
    }else{
        self.budgetL.font = [UIFont systemFontOfSize:17];
        self.budgetL.text = @"未设置";
    }
    
    CGFloat ratio = (monthBudget>0)? monthExpandse / monthBudget:0;
    self.ratioView.height = MAX(MIN((self.tongView.height-4)*ratio, self.tongView.height-4), 0);
    
    self.ratioView.y = MAX(MIN(self.tongView.maxY-2 -self.ratioView.height, self.tongView.maxY-2) , self.tongView.y+2);
    
    if (self.ratioView.height > self.tongView.height*0.5) {
        self.ratioView.waveSpeed = 6.0f;
        self.ratioView.waveAmplitude = 6.0f;
        [self.ratioView wave];
    }else{
        [self.ratioView stop];
    }
   
    
    [self updateTodayRecordView];
}

- (void)monthIncomeClick:(UIButton *)sender
{
    FMonthIncomeRecordController *controller = [FMonthIncomeRecordController new];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)monthExpandseClick:(UIButton *)sender
{
    FMonthExpandseRecordController *controller = [FMonthExpandseRecordController new];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)monthBudgetClick:(UIButton *)sender
{
    FMonthBudgetRecordController *controller = [FMonthBudgetRecordController new];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)addRecordBtnClick:(UIButton *)sender
{
    FTakeRecordFatherController *controller = [[FTakeRecordFatherController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)lookTodayRecord:(UITapGestureRecognizer *)gesture{
    
    CGPoint touchPoint = [gesture locationInView:gesture.view];
    if (CGRectContainsPoint(self.todayExpandseRecordView.frame, touchPoint) == NO) {
        return;
    }
    if (self.todayNewestRecord && self.todayExpandseRecordView.hidden==NO) {
        
        [self monthExpandseClick:nil];
    }else if(self.todayNewestRecord && self.todayIncomeRecordView.hidden==NO){
        
        [self monthIncomeClick:nil];
    }else{
        return;
    }
}

- (void)initView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [UITableView tableViewWithFrmae:RECT(0, 0, MSWIDTH, MSHIGHT-self.tabBarController.tabBar.height) backgroundColor:AJGrayBackgroundColor delegate:self tableViewStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLineEtched superview:self.view];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.estimatedRowHeight = self.tableView.rowHeight = 55.f;
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    
    UIView *heaer = [UIView viewWithFrame:RECT(0, 0, MSWIDTH, 260) backgroundColor:NavgationColor superview:nil];
    UILabel *dateL = [UILabel labelWithFrame:RECT(20, 50, 200, 25) text:@"06/2018" textColor:[UIColor ys_blue] textFont:35 textAligment:NSTextAlignmentLeft superview:heaer];
    dateL.textColor = RGB(253, 196, 10);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"MM/yyyy";
    NSString *dateStr = [dateFormat stringFromDate:[NSDate date]];
    
    dateL.attributedText = [MyTools getAttributedStringWithText:dateStr start:3 end:dateStr.length textColor:dateL.textColor textFont:[UIFont systemFontOfSize:20]];
    
    // 设置
    CGFloat settingBtnW = 40.f;
    UIButton *settingBtn = [UIButton buttonWithFrame:RECT(MSWIDTH - 40 -20, 40, settingBtnW, settingBtnW) backgroundColor:nil title:nil titleColor:nil titleFont:0 target:self action:@selector(settingBtnClick:) superview:heaer];
    [settingBtn setImage:[UIImage imageNamed:@"Mine_ setting"] forState:UIControlStateNormal];
    
    CGFloat tongViewW = 70;
    CGFloat tongViewH = 130;
    UIView *tongView = [UIView viewWithFrame:RECT(MSWIDTH - tongViewW - 15, dateL.maxY+30, tongViewW, tongViewH) backgroundColor:[UIColor blackColor] superview:heaer];
    tongView.alpha = .2f;
    ViewBorderRadius(tongView, 2, 10, [[UIColor blackColor] colorWithAlphaComponent:.32]);
    self.tongView = tongView;
    
    KYWaterWaveView *ratioView = [KYWaterWaveView viewWithFrame:RECT(MSWIDTH - tongViewW - 15 + 2, dateL.maxY+30, tongViewW-4, tongViewH-2) backgroundColor:RGB(253, 196, 10) superview:heaer];
    ratioView.y = tongView.y + 50;
    ratioView.height = tongViewH - 50-2;
    self.ratioView = ratioView;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ratioViewTapped:)];
    [self.ratioView addGestureRecognizer:tapGes];
    
    self.incomeL = [self addRowWithY:tongView.y-10  Title:@"本月收入" touchaction:@selector(monthIncomeClick:) superView:heaer];
    self.expandseL = [self addRowWithY:heaer.subviews.lastObject.maxY  Title:@"本月支出" touchaction:@selector(monthExpandseClick:) superView:heaer];
    self.budgetL = [self addRowWithY:heaer.subviews.lastObject.maxY  Title:@"预算余额" touchaction:@selector(monthBudgetClick:) superView:heaer];

    self.budgetL.text = @"未设置";
    
    // 最近记录=== 今天
    UIView *recentlyRecordView = [UIView viewWithFrame:RECT(0, 260, MSWIDTH, 150) backgroundColor:AJWhiteColor superview:heaer];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookTodayRecord:)];
    [recentlyRecordView addGestureRecognizer:tapgesture];
    
    
    UILabel *label = [UILabel labelWithFrame:RECT(15, 15, 40, 40) text:@"今" textColor:AJWhiteColor textFont:20 textAligment:NSTextAlignmentCenter superview:recentlyRecordView];
    label.backgroundColor = [UIColor ys_blue];
    label.font = [UIFont boldSystemFontOfSize:20];
    ViewRadius(label, label.width/2);
    
    UILabel *todayRecordCountL = [UILabel labelWithFrame:RECT(label.maxX + 8, label.y, MSWIDTH-30, label.height) text:@"共0笔" textColor:[UIColor ys_darkGray] textFont:17 textAligment:NSTextAlignmentLeft superview:recentlyRecordView];
    self.todayRecordCountL = todayRecordCountL;
    
    UILabel *recordStateL = [UILabel labelWithFrame:RECT(15, label.maxY + 20, MSWIDTH-30, 65) text:@"亲，您今天没有记账~" textColor:[UIColor ys_darkGray] textFont:17 textAligment:NSTextAlignmentCenter superview:recentlyRecordView];
    recordStateL.hidden = YES;
    self.recordStateL = recordStateL;
    
    UIView *line = [UIView viewWithFrame:RECT(0, todayRecordCountL.maxY+5, MSWIDTH, .7f) backgroundColor:[UIColor ys_grayLine] superview:recentlyRecordView];
    //
    FMyIncomeRecordCell *todayIncomeRecordView = [[NSBundle mainBundle] loadNibNamed:@"FMyIncomeRecordCell" owner:nil options:0].lastObject;
    self.todayIncomeRecordView =  todayIncomeRecordView;
    todayIncomeRecordView.frame = RECT(0, recordStateL.y, MSWIDTH, recordStateL.height);
    [recentlyRecordView addSubview:todayIncomeRecordView];
    todayIncomeRecordView.hidden = YES;
//    ViewBorderRadius(todayIncomeRecordView, 0, .7, [UIColor ys_grayLine]);
    
    FMyExpandseRecordCell *todayExpandseRecordView = [[NSBundle mainBundle] loadNibNamed:@"FMyExpandseRecordCell" owner:nil options:0].lastObject;
    self.todayExpandseRecordView =  todayExpandseRecordView;
    todayExpandseRecordView.frame = RECT(0, recordStateL.y, MSWIDTH, recordStateL.height);
    [recentlyRecordView addSubview:todayExpandseRecordView];
    todayExpandseRecordView.hidden = YES;
//    ViewBorderRadius(todayExpandseRecordView, 0, .7, [UIColor ys_grayLine]);
    
//    UIButton *torecordBtn = [UIButton buttonWithFrame:RECT(50, todayExpandseRecordView.maxY + 20, MSWIDTH-100, 37) backgroundColor:NavgationColor title:@"记一笔" titleColor:AJWhiteColor titleFont:15 target:self action:@selector(addRecordBtnClick:) superview:recentlyRecordView];
//    ViewRadius(torecordBtn, 3);
//
    recentlyRecordView.height = todayExpandseRecordView.maxY + 20;
    line = [UIView viewWithFrame:RECT(0, recentlyRecordView.height-.5, MSWIDTH, .7f) backgroundColor:[UIColor ys_grayLine] superview:recentlyRecordView];
    
    
    heaer.height = recentlyRecordView.maxY;
    UIView *footer = [UIView viewWithFrame:RECT(0, 0, MSWIDTH, 100) backgroundColor:nil superview:nil];
    UIButton *btn = [UIButton buttonWithFrame:RECT(50, 30, MSWIDTH-100, 37) backgroundColor:AJWhiteColor title:@"退出登录" titleColor:[UIColor ys_black] titleFont:15 target:self action:@selector(signOut:) superview:footer];
    self.tableView.tableFooterView = footer;
    self.tableView.tableHeaderView = heaer;
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}


// MARK:- 点击了圆筒
- (void)ratioViewTapped:(UIView *)sender
{
    if (self.ratioView.height > self.tongView.height*0.5) {
        
        
        ShowLightMessage(@"您的生活如鱼得水");
    }
}

- (void)requestData{
    [MyTools hidenNetworkActitvityIndicator];
    [self.tableView.mj_header endRefreshing];
}

- (UILabel *)addRowWithY:(CGFloat)y Title:(NSString *)title touchaction:(nonnull SEL)action superView:(UIView *)heaer{
    
    UIControl *view = [UIControl viewWithFrame:RECT(0, y, MSWIDTH-100, 50) backgroundColor:nil superview:heaer];
    [view addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleL = [UILabel labelWithFrame:RECT(15, 0, 80, 50) text:title textColor:[[UIColor whiteColor] colorWithAlphaComponent:.8] textFont:14 textAligment:NSTextAlignmentLeft superview:view];
    
    CGFloat contentLX = titleL.maxX;
    UILabel *contentL = [UILabel labelWithFrame:RECT(contentLX, 0, view.width-contentLX - 15, 50) text:@"￥0.00" textColor:[UIColor whiteColor] textFont:20 textAligment:NSTextAlignmentRight superview:view];
//    UIView *line = [UIView viewWithFrame:RECT(15, contentL.maxY + 5, MSWIDTH-15, .5) backgroundColor:[UIColor ys_grayLine] superview:view];
//    line.tag = 90;
//    contentL.backgroundColor = AJGrayBackgroundColor;
    CGFloat imgVW = 8.f;
    UIImageView *imgV = [UIImageView imageViewWithFrame:RECT(view.width - imgVW - 5, contentL.y, imgVW, contentL.height) imageFile:@"Payments_arrow" superview:view];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    return contentL;
}

// MARK:- 设置按钮
- (void)settingBtnClick:(UIButton *)sender
{
    ZLSettingsController *controller = [ZLSettingsController new];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)signOut:(UIButton *)sender
{
    [SVProgressHUD show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ShowLightMessage(@"已退出登录");
        self.tabBarController.selectedIndex = 0;
        [ZLUserModel clearUser];
        AppDelegateInstance.userInfo = nil;
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FMineCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    ProductItem *itme1 = self.dataArray[indexPath.row];
    
    cell.titleL.text = itme1.title;
    cell.imgV.image = [UIImage imageNamed:itme1.icon];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        FMyIncomeRecordController *controller = [FMyIncomeRecordController new];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        FMyExpandseRecordController *controller = [FMyExpandseRecordController new];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

@end
