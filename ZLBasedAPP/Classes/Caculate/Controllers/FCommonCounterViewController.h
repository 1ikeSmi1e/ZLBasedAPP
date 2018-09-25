//
//  FCommonCounterViewController.h
//  ftool
//
//  Created by apple on 2018/6/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "AJContainTableController.h"

@interface FCommonCounterViewController : AJContainTableController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITextField *tf_amount;
@property (weak, nonatomic) IBOutlet UITextField *tf_rate;
@property (weak, nonatomic) IBOutlet UITextField *tf_discount; //折扣
@property (weak, nonatomic) IBOutlet UITextField *tf_limit; //年限


- (IBAction)repayTypeChange:(UISegmentedControl *)sender;
- (IBAction)btnCounting:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_marginTop; //累计支付行top间距约束


@property (weak, nonatomic) IBOutlet UILabel *lb_firstTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_firstRepay;  //首期，或每期还款
@property (weak, nonatomic) IBOutlet UILabel *lb_dicreaseAmount; //每月递减金额（等额本金用）

@property (weak, nonatomic) IBOutlet UILabel *lb_allRepayInterest; //总还利息
@property (weak, nonatomic) IBOutlet UILabel *lb_allRepayAmount; //总还金额


@end
