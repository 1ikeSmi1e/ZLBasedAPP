//
//  FMyIncomeRecordDetailController.m
//  ftool
//
//  Created by admin on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FMyIncomeRecordDetailController.h"
#import "FTakeRecordIncomeView.h"


@interface FMyIncomeRecordDetailController ()<UIViewOutterDelegate>
@property (nonatomic, weak) FTakeRecordIncomeView *contentV;
@end

@implementation FMyIncomeRecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

#pragma  mark - UIViewOutterDelegate
- (void)customView:(UIView *)sectionView didClickWithType:(ClickType)type{
    
    if (ClickType_editCategory == type) {
        
        //        FEditFirstTypeController *controller = [FEditFirstTypeController new];
        //        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void)initView {
    
    self.view.backgroundColor = AJGrayBackgroundColor;
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"详情" leftName:nil rightName:@"保存" delegate:self];

    UIScrollView *tableview = [UIScrollView viewWithFrame:CGRectMake(0, bar.maxY, MSWIDTH, self.view.height-bar.maxY) backgroundColor:AJWhiteColor superview:self.view];
    //    tableview.tableFooterView = [UIView new];
    tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    FTakeRecordIncomeView *contentV = [FTakeRecordIncomeView viewWithFrame:RECT(0, 0, MSWIDTH, 500) backgroundColor:nil superview:tableview];
    contentV.aincomeRecord = self.aincomeRecord;
    contentV.delegate = self;
    tableview.contentSize = CGSizeMake(0, contentV.height+30);
    self.contentV = contentV;
    
    UILabel *tipL = [UILabel labelWithFrame:RECT(15, MSHIGHT - 50, MSWIDTH, 15) text:@"如果不是当前月份数据，编辑无效，抱歉" textColor:[UIColor ys_darkGray] textFont:14 textAligment:NSTextAlignmentLeft superview:self.view];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (!self.navigationController) {// 保存的是页面离开时的样子
        
        [self save];
    }
}

- (void)save{
    
    NSDate *currentDate = [NSDate date];
    NSDate *recordDade = [NSDate getDate:self.aincomeRecord.time_month format:@"yyyy年MM月"];
    if (currentDate.year != recordDade.year || currentDate.month != recordDade.month) {
        
        ShowLightMessage(@"不是当前月份数据，编辑无效");
        return;
    }
    
    BOOL infoDone = [self.contentV infoDoneCheck];
    if (!infoDone) {
        //        ShowLightMessage(@"报告老板，信息填写不完整！");
    }else{
        FAccountRecord *income = [self.contentV incomeReord];
        
        [self.aincomeRecord copyPropertyWithRecord:income];
        ShowLightMessage(@"已保存！");
    }
    
}
- (void)nextItemClick{
 
//    [SVProgressHUD showImage:kSuccessImage status:@"已保存"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController popViewControllerAnimated:YES];
        NSArray *arrPoped = [self.navigationController popToRootViewControllerAnimated:YES];
        for (UIViewController *popVC in arrPoped) {
            [popVC viewDidDisappear:NO];
        }
        
    });
}
@end
