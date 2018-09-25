//
//  FFinanceRepayDetailViewController.h
//  ftool
//
//  Created by apple on 2018/6/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "AJContainTableController.h"

@interface FFinanceRepayDetailViewController : AJContainTableController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *data;

@property (weak, nonatomic) IBOutlet UILabel *lb_amount; //本金
@property (weak, nonatomic) IBOutlet UILabel *lb_interest; //利息

@property (weak, nonatomic) IBOutlet UILabel *lb_apr; //年化率
@property (weak, nonatomic) IBOutlet UILabel *lb_months;

@property (weak, nonatomic) IBOutlet UILabel *lb_repayWay;
@property (weak, nonatomic) IBOutlet UILabel *lb_endTime;

@property (strong, nonatomic) NSString *amount; //本金
@property (strong, nonatomic) NSString *interest; //利息

@property (strong, nonatomic) NSString *apr; //年化率
@property (strong, nonatomic) NSString *months;

@property (strong, nonatomic) NSString *repayWay;
@property (strong, nonatomic) NSString *endTime;
@end
