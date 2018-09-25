//
//  FFinanceRepayDetailViewController.m
//  ftool
//  理财计算器 -》还款明细
//  Created by apple on 2018/6/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FFinanceRepayDetailViewController.h"
#import "FRepayDetailCell.h"

@interface FFinanceRepayDetailViewController ()

@end

@implementation FFinanceRepayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"还款明细" leftName:nil rightName:@"" delegate:self];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _lb_amount.text = _amount;
    _lb_apr.text = _apr;
    _lb_months.text = _months;
    _lb_interest.text = _interest;
    _lb_endTime.text = _endTime;
    
    _lb_repayWay.text = _repayWay;
//    NSLog(@"data = %@", _data);
    
    [self.tableView reloadData];
}

//每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}




//每一组的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FRepayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repayDetailCell"];
    
    NSMutableDictionary *item = [_data objectAtIndex:indexPath.row];
    
    cell.lb_no.text = [NSString stringWithFormat:@"第%ld期", indexPath.row+1];
    
    cell.lb_repayAmount.text = [item objectForKey:@"money"];
    cell.lb_repayDate.text = [item objectForKey:@"date"];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
