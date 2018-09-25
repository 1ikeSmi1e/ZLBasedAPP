//
//  AJContainTableController.h
//  SP2P
//
//  Created by Ajax on 16/2/24.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJNetWorkController.h"
#import "AJCustomUI.h"

@interface AJContainTableController : AJNetWorkController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, assign) int currPage;
@property (nonatomic, assign) int totalPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UITableView *tableView;




- (void)addTableViewRefreshHeader;
- (void)addTableViewRefreshHeaderFooter;
- (void)hideRefreshHeaderFooter;

/** 显示暂无记录视图 */
- (void)showNoRecordView;
- (void)hideNoRecordView;
@end
