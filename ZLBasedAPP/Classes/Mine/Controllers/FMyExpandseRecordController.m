//
//  FMyExpandseRecordController.m
//  ftool
//
//  Created by admin on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FMyExpandseRecordController.h"
#import "FMyExpandseRecordCell.h"
#import "AJMonthSectionHeader.h"
#import "FMyExpandseRecordDetailController.h"

@interface FMyExpandseRecordController ()

@property (nonatomic, strong) FAccountRecord *selectRecord;
@property (nonatomic, weak) UIButton *loadMorebtn;
@end

static NSString * const reuseIdentifier = @"FMyExpandseRecordCell";
static NSString * const reuseIdentifier2 = @"AJMonthSectionHeader";

@implementation FMyExpandseRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    NSMutableArray *currentMonthExpandse = AppDelegateInstance.currentMonthRecord.expandseArr;
    if (currentMonthExpandse.count <= 0) {
        return;
    }
    [currentMonthExpandse sortUsingComparator:^NSComparisonResult(FAccountRecord *obj1, FAccountRecord *obj2) {
        // 倒序
        NSComparisonResult result = [obj1.time_minute compare:obj2.time_minute];
        if (result == NSOrderedAscending) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    [self.dataArray addObject:currentMonthExpandse];
}

- (void)initView {
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"支出记录" leftName:nil rightName:@"" delegate:self];
    
    self.tableView = [UITableView tableViewWithFrmae:RECT(0, bar.maxY, MSWIDTH, MSHIGHT-bar.maxY) backgroundColor:AJGrayBackgroundColor delegate:self tableViewStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLineEtched superview:self.view];
    
    self.tableView.rowHeight = 55.f;
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    UIView *footer = [UIView viewWithFrame:RECT(0, 0, MSWIDTH, 100) backgroundColor:nil superview:nil];
    UIButton *loadMorebtn = [UIButton buttonWithFrame:RECT(50, 30, MSWIDTH-100, 37) backgroundColor:AJWhiteColor title:@"加载更多" titleColor:[UIColor ys_black] titleFont:15 target:self action:@selector(findMoreRecordClick:) superview:footer];
    self.loadMorebtn = loadMorebtn;
    self.tableView.tableFooterView = footer;
    [self.tableView registerClass:[AJMonthSectionHeader class] forHeaderFooterViewReuseIdentifier:reuseIdentifier2];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray[section] count];
}

- (void)findMoreRecordClick:(UIButton *)sender
{
    // 锁定要加载的月份
    NSArray *lastArr = self.dataArray.lastObject;
    FAccountRecord *bean = lastArr.firstObject;
    NSDate *lastDate = nil;
    if (!bean) {
        lastDate = [NSDate date];
    }else{
        lastDate = [NSDate getDate:bean.time_month format:@"yyyy年MM月"];
    }    NSInteger year = lastDate.year;
    NSInteger month = lastDate.month;
    month -= 1;
    if (month<=0) {
        month = 12;
        year -= 1;
    }
    NSString *targetDateStr = [NSString stringWithFormat:@"%04d%02d", (int)year, (int)month];
    
    // 加载月份数据文件
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [NSString stringWithFormat:@"F_%@_%@.txt", @"default", targetDateStr];
    NSString *filePathName = [path stringByAppendingPathComponent:fileName];
    
    NSString *jsonstring = [NSString stringWithContentsOfFile:filePathName encoding:NSUTF8StringEncoding error:nil];
    if (!jsonstring.length) {// 用户没有存取，从APP中取
        
        NSString *filePathName_app = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        if (filePathName_app.length) {
            
            jsonstring = [NSString stringWithContentsOfFile:filePathName_app encoding:NSUTF8StringEncoding error:nil];
        }else{
            ShowLightMessage(@"没有更多了");
            [self.loadMorebtn setTitle:@"已加载全部数据" forState:UIControlStateNormal];
            return;
        }
    }
    FCurrentMonthRecord *targetMonthRecord = [FCurrentMonthRecord mj_objectWithKeyValues:jsonstring];
    // 加载数组，排序,刷新列表
    NSMutableArray *currentMonthExpandse = targetMonthRecord.expandseArr;
    
    [currentMonthExpandse sortUsingComparator:^NSComparisonResult(FAccountRecord *obj1, FAccountRecord *obj2) {
        // 倒序
        NSComparisonResult result = [obj1.time_minute compare:obj2.time_minute];
        if (result == NSOrderedAscending) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    [self.dataArray addObject:currentMonthExpandse];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FMyExpandseRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    FAccountRecord *bean = self.dataArray[indexPath.section][indexPath.row];
    
    cell.timeL.text = [bean.time_minute substringFromIndex:3];
    cell.textL.text = bean.subType.name;
    cell.imgV.image = [UIImage imageNamed:bean.subType.iconName];
    cell.moneyL.text = [NSString numberformatStrFromDouble:bean.amount];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    FAccountRecord *bean = [self.dataArray[section] firstObject];
    AJMonthSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier2];
    [header setText:bean.time_month];
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    return 45.f;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
//    return .5f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    FAccountRecord *bean = self.dataArray[indexPath.section][indexPath.row];
    self.selectRecord = bean;
    
    FMyExpandseRecordDetailController *controller = [FMyExpandseRecordDetailController new];
    controller.aExpandseRecord = bean;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}
- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    if (!self.navigationController) {
        if (!AppDelegateInstance.userInfo) {
            
            ShowLightMessage(@"保存失败！未登录！");
        }else{
            
            AppDelegateInstance.currentMonthRecord.expandseArr = [self.dataArray.firstObject mutableCopy];
            [FAccountRecordSaveTool saveCurrentMonthBlanceRecords];
        }
       
    }
}
@end
