//
//  FHouseCounterHybirdViewController.m
//  ftool
//  组合贷
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FHouseCounterHybirdViewController.h"
#import "BaseContentCell.h"

#define LH_RESULT 40 //结果行高

@interface FHouseCounterHybirdViewController (){
    CGRect headRect;
    NSInteger repayType;
    NSInteger lastType;
    
    NSArray *_titleArray;
    NSArray *_contentArray;
}

@end

@implementation FHouseCounterHybirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    headRect = self.headView.frame;
    
    [self.tableView registerClass:[BaseContentCell class] forCellReuseIdentifier:@"RateViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [_tf_amount_gjj setText:@"20"];
    [_tf_rate_gjj setText:@"3.25"];
    
    [_tf_amount setText:@"30"]; //商业贷款额
    [_tf_discount setText:@"1.2"]; //目前上浮20%
    [_tf_rate setText:@"4.9"]; //利率
    [_tf_limit setText:@"10"]; //年限
    
    repayType = 0;
    
    //
    _constraint_marginTop.constant = 20 + 40 + 2;
}



- (IBAction)repayTypeChange:(UISegmentedControl *)sender {
    repayType = sender.selectedSegmentIndex;
    
}


//修改首次或每次 标题、结果列表
- (void) changeFirstTitle{
    
    NSString *currTitle = _lb_firstTitle.text;
    if(repayType == 0){ //本息 每期
        [_lb_firstTitle setText:[currTitle stringByReplacingOccurrencesOfString:@"首期" withString:@"每期"]];
        if (lastType != repayType) {
            _constraint_marginTop.constant -= LH_RESULT;
            [self resetHeadHight: 0];  //headView复原
        }
        
    }else { //本金 首期
        [_lb_firstTitle setText:[currTitle stringByReplacingOccurrencesOfString:@"每期" withString:@"首期"]];
        if (lastType != repayType) {
            _constraint_marginTop.constant += LH_RESULT;
            [self resetHeadHight: LH_RESULT];
        }
    }
    lastType = repayType;
}


- (IBAction)btnCounting:(UIButton *)sender {
    if ([self isInputed:_tf_amount_gjj andPromit:@"请输入公积金额"]
        && [self isInputed:_tf_rate_gjj andPromit:@"请输入公积金利率"]
        && [self isInputed:_tf_amount andPromit:@"请输入商业贷款额"]
        && [self isInputed:_tf_rate andPromit:@"请输入利率"]
        && [self isInputed:_tf_limit andPromit:@"请输入年限"]) {
        
        [self changeFirstTitle];
        
        double amount = [_tf_amount.text doubleValue] * 10000;
        double monthRate = [_tf_rate.text doubleValue]/100/12;   //月利率
        double amount_gjj = [_tf_amount_gjj.text doubleValue] * 10000; //公积金 金额
        double monthRate_gjj = [_tf_rate_gjj.text doubleValue]/100/12;   //公积金 月利率
        
        if([_tf_discount.text doubleValue] != 1 && [_tf_discount.text doubleValue] > 0){
            monthRate = monthRate * [_tf_discount.text doubleValue];  //折扣
        }
        long repayMonths = [_tf_limit.text integerValue] * 12; //还款期数 公用
        
        if (repayType == 0) { //等额本息
            
            //每月还款 = [金额*月利率*（1+月利率)^还款月数] / [(1+月利率) ^ 还款月数-1]
            double apiecePay = (amount * monthRate * powl((1+monthRate), repayMonths))
                / ( powl((1+monthRate), repayMonths) -1);
            double apiecePay_gjj = (amount_gjj * monthRate_gjj * powl((1+monthRate_gjj), repayMonths))
                / ( powl((1+monthRate_gjj), repayMonths) -1);
            
            //总共还款
            double allRepay = apiecePay * repayMonths;
            double allRepay_gjj = apiecePay_gjj * repayMonths;
            
            //共还利息
            double allTerest = allRepay - amount;
            double allTerest_gjj = allRepay_gjj - amount_gjj;
            
            [_lb_firstRepay setText:[NSString stringWithFormat:@"%.2f", apiecePay + apiecePay_gjj]];
            [_lb_allRepayAmount setText:[NSString stringWithFormat:@"%.2f", allRepay + allRepay_gjj]];
            [_lb_allRepayInterest setText:[NSString stringWithFormat:@"%.2f", allTerest + allTerest_gjj]];
            
            [self generateListData:repayMonths apieceRepay:apiecePay + apiecePay_gjj andDecrease:0] ;
        }
        else {     //等额本金 实例 https://wenku.baidu.com/view/7c88252bf5335a8102d220f1.html?from=search
            //每月还款 = [贷款金额/月数] + （本金 - 已还本金累计）* 月利率
//            double alwayRepay = 0; //已还
//            double apieceRepay = (amount/repayMonths) + (amount - alwayRepay) * monthRate;
            
            double monthBenjin = amount/repayMonths; //每月本金
            double monthBenjin_gjj = amount_gjj/repayMonths; //公积金的
            
            double firstMonthPay = monthBenjin + (amount * monthRate); //第一月还款
            double secondMonthPay = monthBenjin + ((amount - monthBenjin) * monthRate); //第二月还款
            double firstMonthPay_gjj = monthBenjin_gjj + (amount_gjj * monthRate_gjj);
            double secondMonthPay_gjj = monthBenjin_gjj + ((amount_gjj - monthBenjin_gjj) * monthRate_gjj);
            
            double decrease = firstMonthPay - secondMonthPay;  //每月递减(利息)
            double decrease_gjj = firstMonthPay_gjj - secondMonthPay_gjj;  //公积金的
            
            [_lb_firstRepay setText:[NSString stringWithFormat:@"%.2f", firstMonthPay + firstMonthPay_gjj]];
            [_lb_dicreaseAmount setText:[NSString stringWithFormat:@"%.2f", decrease + decrease_gjj]];
            
            double allPayInterest = 0;  //全部利息
            double firstMothInterest = amount * monthRate; //第一月利息
            double allPayInterest_gjj = 0; //公积金的
            double fisrtMothInterest_gjj = amount_gjj * monthRate_gjj; //
            
            //总还利息 累计
            for (int i = 0; i< repayMonths; i++){
                allPayInterest += (firstMothInterest - decrease*i);
                allPayInterest_gjj += (fisrtMothInterest_gjj - decrease_gjj*i);
            }
            
            [_lb_allRepayAmount setText:[NSString stringWithFormat:@"%.2f", amount + allPayInterest + amount_gjj + allPayInterest_gjj]];
            [_lb_allRepayInterest setText:[NSString stringWithFormat:@"%.2f", allPayInterest + allPayInterest_gjj]];
            
            [self generateListData:repayMonths apieceRepay:(firstMonthPay + firstMonthPay_gjj) andDecrease:(decrease+decrease_gjj)];
        }
    }
}

/* 生成列表数据
 * apiecePay 第一月还款
 * decrease 每月递减额
 */
- (void) generateListData:(double) months apieceRepay:(double)apiecePay andDecrease:(double)decrease{
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *contents = [NSMutableArray array];
    
    if(repayType == 1){ //等额本金

        double tempRepay;
        for (int i = 0; i< months; i++){
            //每月还款 = 首月还款 - 递减
            tempRepay = apiecePay  - decrease*i;
            [titles addObject:[NSString stringWithFormat:@"第 %d 期还款金额(元)", i+1]];
            [contents addObject:[NSString stringWithFormat:@"%.2f", tempRepay]];
        }
        
    }else { //等额本息
        for(int i = 0; i< months ; i++){
            [titles addObject:[NSString stringWithFormat:@"第 %d 期还款金额(元)", i+1]];
            [contents addObject:[NSString stringWithFormat:@"%.2f", apiecePay]];
        }
    }
    
    _titleArray = titles;
    _contentArray = contents;
    [self.tableView reloadData];
}

-(BOOL) isInputed:(UITextField *)field andPromit:(NSString*)msg{
    if ([field.text isEmpty]) {
        [SVProgressHUD showImage:nil status:msg];
        return NO;
    }else {
        return YES;
    }
}

//显示多少组
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 4;
//}

//每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}


//每一组的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RateViewCell"];
    cell.titLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.conLabel.text = [_contentArray objectAtIndex:indexPath.row];
    cell.lineLabel.hidden = YES;
    
    return cell;
}

-(void) resetHeadHight: (NSInteger) varHight{
    CGRect newFrame = headRect;
    newFrame.size.height = newFrame.size.height + varHight;
    _headView.frame = newFrame;
    
    //    [self.tableView setTableHeaderView:_headView];
    //加个动画
    [self.tableView beginUpdates];
    [self.tableView setTableHeaderView:_headView];
    [self.tableView endUpdates];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
