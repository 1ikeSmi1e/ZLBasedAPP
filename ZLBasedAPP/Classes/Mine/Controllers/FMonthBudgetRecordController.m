//
//  FMonthBudgetRecordController.m
//  ftool
//
//  Created by admin on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FMonthBudgetRecordController.h"
#import "FMonthBudgetRecordCell.h"

@interface FMonthBudgetRecordController ()<UIViewOutterDelegate>

@property (nonatomic, weak) UILabel *totalBudgetL;
@property (nonatomic, weak) UILabel *usedBudgetL;
@property (nonatomic, weak) UILabel *leftBudgetL;
@end
static NSString * const reuseIdentifier = @"FMonthBudgetRecordCell";
@implementation FMonthBudgetRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    self.dataArray = AppDelegateInstance.aFAccountCategaries.expensesTypeArr;
    
    [self updateHeaderView];
}

- (void)customView:(UIView *)sectionView didClickWithType:(ClickType)type{
    
    if (type == ClickType_didEndeditMonthBudget) {
        
        [self updateHeaderView];
    }
}

- (void)updateHeaderView{
    
    CGFloat monthBudget = 0;
    for (FFirstType *typeBean in AppDelegateInstance.aFAccountCategaries.expensesTypeArr) {
        monthBudget += typeBean.budget;
    }
    
    CGFloat monthExpandse = 0;
    for (FAccountRecord *expandseRecord in AppDelegateInstance.currentMonthRecord.expandseArr) {
        monthExpandse += expandseRecord.amount;
    }
    self.usedBudgetL.text = [NSString numberformatStrFromDouble:monthExpandse];
    self.totalBudgetL.text = [NSString numberformatStrFromDouble:monthBudget];
    
    self.leftBudgetL.text = [NSString numberformatStrFromDouble:(monthBudget - monthExpandse)];
}

- (void)initView {
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"本月预算" leftName:nil rightName:@"保存" delegate:self];
    
    self.tableView = [UITableView tableViewWithFrmae:RECT(0, bar.maxY, MSWIDTH, MSHIGHT-bar.maxY) backgroundColor:AJGrayBackgroundColor delegate:self tableViewStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLineEtched superview:self.view];
    
    self.tableView.estimatedRowHeight = self.tableView.rowHeight = 100.f;
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    // headerView
    UIView *heaer = [UIView viewWithFrame:RECT(0, 0, MSWIDTH, 160) backgroundColor:NavgationColor superview:nil];
    UILabel *totalBudgetL = [UILabel labelWithFrame:RECT(15, 30, MSWIDTH-30, 35) text:@"1,543.00" textColor:AJWhiteColor textFont:35 textAligment:NSTextAlignmentLeft superview:heaer];
    self.totalBudgetL = totalBudgetL;
    UILabel *label = [UILabel labelWithFrame:RECT(15, totalBudgetL.maxY+5, 100, 13) text:@"支出总预算" textColor:[[UIColor whiteColor] colorWithAlphaComponent:.8] textFont:13 textAligment:NSTextAlignmentLeft superview:heaer];
    
    UILabel *usedBudgetL = [UILabel labelWithFrame:RECT(15, label.maxY + 15, MSWIDTH/2-15, 15) text:@"8,543.00" textColor:AJWhiteColor textFont:15 textAligment:NSTextAlignmentLeft superview:heaer];
    self.usedBudgetL = usedBudgetL;
    label = [UILabel labelWithFrame:RECT(15, usedBudgetL.maxY+5, 100, 13) text:@"已使用" textColor:[[UIColor whiteColor] colorWithAlphaComponent:.8] textFont:13 textAligment:NSTextAlignmentLeft superview:heaer];
    
    
    UILabel *leftBudgetL = [UILabel labelWithFrame:RECT(MSWIDTH/2, usedBudgetL.y, MSWIDTH/2-15, 15) text:@"7,543.00" textColor:AJWhiteColor textFont:15 textAligment:NSTextAlignmentLeft superview:heaer];
    self.leftBudgetL = leftBudgetL;
    label = [UILabel labelWithFrame:RECT(leftBudgetL.x, leftBudgetL.maxY+5, 100, 13) text:@"剩余预算" textColor:[[UIColor whiteColor] colorWithAlphaComponent:.8] textFont:13 textAligment:NSTextAlignmentLeft superview:heaer];
    
    heaer.height = label.maxY + 15;
    self.tableView.tableHeaderView = heaer;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:RECT(0, 0, 0, 20)];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FMonthBudgetRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    FFirstType *bean = self.dataArray[indexPath.row];
    cell.afirstType = bean;
    cell.delegate = self;
    return cell;
}

- (void)nextItemClick{
    [SVProgressHUD showImage:kSuccessImage status:@"已保存"];// 实际在viewDidDisappear方法统一保存了
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    if (!self.navigationController) {
        
        if (!AppDelegateInstance.userInfo) {
            
           ShowLightMessage(@"保存失败！未登录！");
        }else{
            
            AppDelegateInstance.aFAccountCategaries.expensesTypeArr = [self.dataArray mutableCopy];
            [FAccountRecordSaveTool saveAccountCategaries];
        }
        
    }
}
@end
