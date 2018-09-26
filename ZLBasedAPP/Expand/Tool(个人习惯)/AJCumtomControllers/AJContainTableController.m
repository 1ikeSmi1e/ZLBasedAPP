//
//  AJContainTableController.m
//  SP2P
//
//  Created by Ajax on 16/2/24.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJContainTableController.h"
#import "MJRefresh.h"
//#import "NoRecordView.h"

@interface AJContainTableController ()
@end

@implementation AJContainTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currPage = 1;
    self.totalPage = 100;

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
//#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}



- (void)hideRefreshHeaderFooter
{
    [MyTools hidenNetworkActitvityIndicator];
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}
- (void)addTableViewRefreshHeader
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //        [self.tableView.mj_footer setValue:@YES forKeyPath:@"stateLabel.hidden"];
        [(MJRefreshAutoNormalFooter*)weakSelf.tableView.mj_footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
        [MyTools showNetworkActivityIndicator];
        weakSelf.currPage = 1;
        [weakSelf requestData];
        
    }];
}

- (void)addTableViewRefreshHeaderFooter
{
    [self addTableViewRefreshHeader];
    
    __weak typeof(self) weakSelf = self;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currPage ++;
        
        if ( weakSelf.currPage <= weakSelf.totalPage) {
            
            //            [(MJRefreshAutoNormalFooter*)weakSelf.tableView.mj_footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
            [weakSelf requestData];
            [MyTools showNetworkActivityIndicator];
        }else{
            
            [(MJRefreshAutoNormalFooter*)weakSelf.tableView.mj_footer setTitle:@"已经到底啦" forState:MJRefreshStateIdle];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
    footer.automaticallyHidden = YES;
    //    footer.stateLabel.hidden = YES;
    self.tableView.mj_footer = footer;
    
}

/** 显示暂无记录视图 */
- (void)hideNoRecordView
{
    //    NoRecordView *view = [self.tableView viewWithTag:1000999];
    //    [view removeFromSuperview];
}

- (void)showNoRecordView
{
    //    CGRect frame = RECT(0, 0, self.tableView.width, 250*AJScaleMiltiplier);
    //    NoRecordView *view = [NoRecordView viewWithFrame:frame backgroundColor:nil superview:self.tableView];
    //    view.tag = 1000999;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
@end
