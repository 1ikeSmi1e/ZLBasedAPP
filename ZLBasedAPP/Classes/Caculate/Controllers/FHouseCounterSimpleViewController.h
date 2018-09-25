//
//  FHouseCounterSimpleViewController.h
//  ftool
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "AJContainTableController.h"

@interface FHouseCounterSimpleViewController : AJContainTableController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITextField *tf_amount;
@property (weak, nonatomic) IBOutlet UITextField *tf_rate;
@property (weak, nonatomic) IBOutlet UITextField *tf_discount; //折扣
@property (weak, nonatomic) IBOutlet UITextField *tf_limit; //年限

@property (weak, nonatomic) IBOutlet UIView *view_discount; //折扣行，公积金不要
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_gjtTop; //通过移动下一行覆盖

- (IBAction)repayTypeChange:(UISegmentedControl *)sender;
- (IBAction)btnCounting:(UIButton *)sender;

@property (nonatomic,assign) BOOL isBusiness; //是否纯商业贷
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_marginTop; //累计支付行top间距约束

@property (weak, nonatomic) IBOutlet UILabel *lb_firstTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_firstRepay;  //首期，或每期还款
@property (weak, nonatomic) IBOutlet UILabel *lb_dicreaseAmount; //每月递减金额

@property (weak, nonatomic) IBOutlet UILabel *lb_allRepayInterest; //总还利息
@property (weak, nonatomic) IBOutlet UILabel *lb_allRepayAmount; //总还金额


@end
