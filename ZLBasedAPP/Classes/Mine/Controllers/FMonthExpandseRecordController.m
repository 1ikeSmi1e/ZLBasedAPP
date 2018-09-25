//
//  FMonthExpandseRecordController.m
//  ftool
//
//  Created by admin on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FMonthExpandseRecordController.h"
#import "FMyExpandseRecordCell.h"
#import "AJMonthSectionHeader.h"
#import "FMyExpandseRecordDetailController.h"
#import "FTakeRecordFatherController.h"

@interface FMonthExpandseRecordController ()

@property (nonatomic, weak) UIButton *addMorebtn;
@property (nonatomic, strong) FAccountRecord *selectRecord;
@end

static NSString * const reuseIdentifier = @"FMyExpandseRecordCell";

@implementation FMonthExpandseRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    self.dataArray = AppDelegateInstance.currentMonthRecord.expandseArr;
    [self.dataArray sortUsingComparator:^NSComparisonResult(FAccountRecord *obj1, FAccountRecord *obj2) {
        // 倒序
        NSComparisonResult result = [obj1.time_minute compare:obj2.time_minute];
        if (result == NSOrderedAscending) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSaveARecordNotiHandler:) name:FToolUserDidSaveARecordNotification object:nil];
}
- (void)userDidSaveARecordNotiHandler:(NSNotification *)note
{
    self.dataArray = AppDelegateInstance.currentMonthRecord.expandseArr;
    [self.tableView reloadData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)initView {
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"本月支出记录" leftName:nil rightName:@"" delegate:self];
    
    self.tableView = [UITableView tableViewWithFrmae:RECT(0, bar.maxY, MSWIDTH, MSHIGHT-bar.maxY) backgroundColor:AJGrayBackgroundColor delegate:self tableViewStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLineEtched superview:self.view];
    
    self.tableView.estimatedRowHeight = self.tableView.rowHeight = 63.f;
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    UIView *footer = [UIView viewWithFrame:RECT(0, 0, MSWIDTH, 100) backgroundColor:nil superview:nil];
    UIButton *addMorebtn = [UIButton buttonWithFrame:RECT(50, 30, MSWIDTH-100, 37) backgroundColor:AJWhiteColor title:@"添加一笔" titleColor:[UIColor ys_black] titleFont:15 target:self action:@selector(addMoreRecordClick:) superview:footer];
    self.addMorebtn = addMorebtn;
    self.tableView.tableFooterView = footer;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
}

- (void)addMoreRecordClick:(UIButton *)sender
{
    FTakeRecordFatherController *controller = [FTakeRecordFatherController new];
    [self.navigationController pushViewController:controller animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FMyExpandseRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    FAccountRecord *bean = self.dataArray[indexPath.row];
    
    cell.timeL.text = [bean.time_minute substringFromIndex:3];
    cell.textL.text = bean.subType.name;
    cell.imgV.image = [UIImage imageNamed:bean.subType.iconName];
    cell.moneyL.text = [NSString numberformatStrFromDouble:bean.amount];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63.f;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FAccountRecord *bean = self.dataArray[indexPath.row];
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
            
            AppDelegateInstance.currentMonthRecord.expandseArr = [self.dataArray mutableCopy];
            [FAccountRecordSaveTool saveCurrentMonthBlanceRecords];
            
        }
        
    }
}
@end
