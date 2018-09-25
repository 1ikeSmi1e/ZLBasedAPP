//
//  FFinanceCounterViewController.h
//  ftool
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZLBaseViewController.h"

@interface FFinanceCounterViewController : ZLBaseViewController

//实际利率
@property (weak, nonatomic) IBOutlet UILabel *lb_realyRate;
//预计收益
@property (weak, nonatomic) IBOutlet UILabel *lb_income;

- (IBAction)btn_lookDetail:(UIButton *)sender;
//理财金额
@property (weak, nonatomic) IBOutlet UITextField *tf_amount;
//启息日 btn_selectStartDate
@property (weak, nonatomic) IBOutlet UIButton *btn_selectStartDate;
@property (weak, nonatomic) IBOutlet UIButton *btn_selectRepayWay;

- (IBAction)btnSelectDate:(UIButton *)sender;

- (IBAction)segLimitTypeChange:(UISegmentedControl *)sender;
- (IBAction)segRateTypeChange:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITextField *tf_limitValue;
@property (weak, nonatomic) IBOutlet UITextField *tf_rateValue;

- (IBAction)btn_selectRepayWay:(id)sender;
//返现
@property (weak, nonatomic) IBOutlet UITextField *tf_rebackMoney;
//管理费（%）
@property (weak, nonatomic) IBOutlet UITextField *tf_manageRate;

@end
