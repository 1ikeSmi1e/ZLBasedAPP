//
//  FFinanceCounterViewController.m
//  ftool
//  理财计算器
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FFinanceCounterViewController.h"
#import "BRStringPickerView.h"
#import "FFinanceRepayDetailViewController.h"
#import "BRDatePickerView.h"

@interface FFinanceCounterViewController ()<UITextFieldDelegate> {
    
    // 还款类型 0一次性还本付息，1先息后本，2等额本息，3等额本金
    NSInteger repayWay;
    NSMutableDictionary *dicWay;
    NSString *currSelect;  //还款类型
    
    NSInteger rateType; //利率类型 年 月 日
    NSInteger limitType; //期限类型  月 日
    
    double months; //月数
    double firstPay;
    double _decrease; //递减
    
    NSString *selectStartDate; //起息日

}

@end

@implementation FFinanceCounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"理财计算器" leftName:nil rightName:@"" delegate:self];
    
    [self.tf_limitValue setText:@"12"];
    [self.tf_rateValue setText:@"5"];
    
    self.tf_amount.delegate = self;
    self.tf_limitValue.delegate = self;
    self.tf_rateValue.delegate = self;
    
    self.tf_rebackMoney.delegate = self;  //返现
    self.tf_manageRate.delegate = self;  //管理费率
    
    repayWay = 0;
    rateType = 0;
    limitType = 0;
    dicWay = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"一次性还本付息",
              @"1", @"先息后本",@"2", @"等额本息",@"3", @"等额本金", nil];
    
    [_btn_selectRepayWay setTitle:@"一次性还本付息" forState:UIControlStateNormal];
    
}

//查看明细
- (IBAction)btn_lookDetail:(UIButton *)sender {
    
    double amount = [_tf_amount.text doubleValue] ;
    double rateValue = [_tf_rateValue.text doubleValue];
    double repayMonths = [_tf_limitValue.text integerValue] ; //理财期限
    
    if(amount <= 0 || rateValue <= 0 || repayMonths <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入理财金额"];
    }
    else if([_btn_selectStartDate.titleLabel.text isEqualToString:@"请选择"]){
        [SVProgressHUD showImage:nil status:@"请选择起息日"];
    }else {
        [self counting];
        
        UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Counters" bundle:nil];
        FFinanceRepayDetailViewController *detailVc = [homeStoryboard instantiateViewControllerWithIdentifier:@"FinanceRepayDetail"];
        
        detailVc.amount = [NSString stringWithFormat:@"%@元", _tf_amount.text];
        detailVc.interest = _lb_income.text;
        detailVc.apr = [NSString stringWithFormat:@"%@ %%", _lb_realyRate.text];
        detailVc.repayWay = _btn_selectRepayWay.titleLabel.text;
        
        detailVc.months = [NSString stringWithFormat:@"%@期",_tf_limitValue.text];
        //期限为日的也是一次性
        if (repayWay == 0 || limitType == 1) { //一次性的
            detailVc.months = @"1期";
        }
        
        detailVc.endTime = [self getNewDateFromString:selectStartDate addMonth:repayMonths day:0];
        if ( limitType == 1) {
            detailVc.endTime = [self getNewDateFromString:selectStartDate addMonth:0 day:[_tf_limitValue.text integerValue]];
        }
        detailVc.data = [self generateListData];
        
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }
    
}


- (IBAction)segLimitTypeChange:(UISegmentedControl *)sender {
    limitType = sender.selectedSegmentIndex;
    if(limitType == 1){ //期限单位为：日 时只有一种还款方式
        repayWay = 0;
        dicWay = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"一次性还本付息", nil];
        [_btn_selectRepayWay setTitle:@"一次性还本付息" forState:UIControlStateNormal];
    }else {
        dicWay = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"一次性还本付息",
                  @"1", @"先息后本",@"2", @"等额本息",@"3", @"等额本金", nil];
    }
    [self counting];
}

- (IBAction)segRateTypeChange:(UISegmentedControl *)sender {
    rateType = sender.selectedSegmentIndex;
    [self counting];
}


-(void) counting{
    [self.view endEditing:YES];
    
    double amount = [_tf_amount.text doubleValue] ;
    double rateValue = [_tf_rateValue.text doubleValue];
    double repayMonths = [_tf_limitValue.text integerValue] ; //理财期限

    if (limitType == 1) { //期限单位为：日时
        repayMonths = repayMonths/30;
    }
    if(amount <= 0 || rateValue <= 0 || repayMonths <= 0) {
        NSLog(@" 没输入金额相关信息" );
        return;
    }
    
    //月利率
    double monthRate = rateValue/100/12; //默认选中类型：年
    if (rateType == 1) { //类型为月时
        monthRate = rateValue/100;
    }else if(rateType == 2){ //日时
        monthRate = rateValue/100 * 30;
    }
    //实际年利率
    [self.lb_realyRate setText:[NSString stringWithFormat:@"%.2f", monthRate * 100* 12]];
    months = repayMonths;
    
    if (repayWay == 0) { //一次性还本付息 = 金额 * 月利率 * 期数
        double income = amount * monthRate * repayMonths;
        [_lb_income setText:[NSString stringWithFormat:@"%.2f", income]];
        
    }else if (repayWay == 1) { //先息后本
       
        double income = amount * monthRate * repayMonths;
        [_lb_income setText:[NSString stringWithFormat:@"%.2f", income]];
        
    }else
    if (repayWay == 2) { //等额本息
       
        //每月还款 = [金额*月利率*（1+月利率)^还款月数] / [(1+月利率) ^ 还款月数-1]
        double apiecePay = (amount * monthRate * powl((1+monthRate), repayMonths))
        / ( powl((1+monthRate), repayMonths) -1);
        //总共还款
        double allRepay = apiecePay * repayMonths;
        //共还利息
        double allTerest = allRepay - amount;
      
//        [_lb_allRepayAmount setText:[NSString stringWithFormat:@"%.2f", allRepay]];
        [_lb_income setText:[NSString stringWithFormat:@"%.2f", allTerest]];
        
//        [self generateListData:repayMonths apieceRepay:apiecePay andDecrease:0] ;
         firstPay = apiecePay; _decrease = 0;
    }
    else {     //等额本金 实例 https://wenku.baidu.com/view/7c88252bf5335a8102d220f1.html?from=search
        //每月还款 = [贷款金额/月数] + （本金 - 已还本金累计）* 月利率

        double monthBenjin = amount/repayMonths; //每月本金
        double firstMonthPay = monthBenjin + (amount * monthRate); //第一月还款
        double secondMonthPay = monthBenjin + ((amount - monthBenjin) * monthRate); //第二月还款
        
        double decrease = firstMonthPay - secondMonthPay;  //每月递减(利息)
        
//        [_lb_firstRepay setText:[NSString stringWithFormat:@"%.2f", firstMonthPay]];
        double allPayInterest = 0;
        double fisrtMothInterest = amount * monthRate; //第一月利息
        //总还利息 累计
        for (int i = 0; i< repayMonths; i++){
            allPayInterest += (fisrtMothInterest - decrease*i);
        }
        
        [_lb_income setText:[NSString stringWithFormat:@"%.2f", allPayInterest]];
        
        firstPay = firstMonthPay; _decrease = decrease;
//        [self generateListData:repayMonths apieceRepay:firstMonthPay andDecrease:decrease];
    }
    
    double rebackMoney = [_tf_rebackMoney.text doubleValue]; //返现
    if(rebackMoney > 0){
        double incomne = [_lb_income.text doubleValue] + rebackMoney;
        double oriRate = [_lb_realyRate.text doubleValue];
        double newRate = oriRate * ( 1+ rebackMoney/[_lb_income.text doubleValue]);
        
        [_lb_realyRate setText:[NSString stringWithFormat:@"%.2f", newRate]];
        [_lb_income setText:[NSString stringWithFormat:@"%.2f", incomne]];
    }
    
    double manageRate = [_tf_manageRate.text doubleValue]; //管理费(%)
    if (manageRate > 0) {
        double incomne = [_lb_income.text doubleValue] * (1 - manageRate/100);
        double newRate = [_lb_realyRate.text doubleValue] * (1 - manageRate/100);
        [_lb_realyRate setText:[NSString stringWithFormat:@"%.2f", newRate]];
        [_lb_income setText:[NSString stringWithFormat:@"%.2f", incomne]];
    }
    
}

/* 生成列表数据
 * apiecePay 第一月还款
 * decrease 每月递减额
 */
- (NSMutableArray *) generateListData{
    NSMutableArray *repayListData = [NSMutableArray array];

    repayListData = [NSMutableArray array];
    if (repayWay == 0) { //一次性还本付息
        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        
        double oncePay = [_lb_income.text doubleValue] + [_tf_amount.text doubleValue];
        [item setObject:[NSString stringWithFormat:@"%.2f", oncePay] forKey:@"money"];
        
        [item setObject:[self getNewDateFromString:selectStartDate addMonth:[_tf_limitValue.text integerValue] day:0] forKey:@"date"];
        if (limitType == 1) {
            [item setObject:[self getNewDateFromString:selectStartDate addMonth:0 day:[_tf_limitValue.text integerValue]] forKey:@"date"];
        }
        [repayListData addObject:item];
        
    }else if (repayWay == 1) { //先息后本
        double incomePiece = [_lb_income.text doubleValue]/months;
        
        for(int i = 0; i < months ; i++){
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            [item setObject:[NSString stringWithFormat:@"%.2f", incomePiece] forKey:@"money"];
            [item setObject:[self getNewDateFromString:selectStartDate addMonth:i+1 day:0] forKey:@"date"];
            
            if (i == months-1) { //最后一笔加上本金
                double lastpay = [_tf_amount.text doubleValue] + incomePiece;
                [item setObject:[NSString stringWithFormat:@"%.2f", lastpay] forKey:@"money"];
            }
            
            [repayListData addObject:item];
        }
        
    }else
    if(repayWay == 3){ //等额本金
        double tempRepay;
        for (int i = 0; i< months; i++){
            //每月还款 = 首月还款 - 递减
            tempRepay = firstPay - _decrease*i;
            
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            [item setObject:[NSString stringWithFormat:@"%.2f", tempRepay] forKey:@"money"];
            [item setObject:[self getNewDateFromString:selectStartDate addMonth:i+1 day:0] forKey:@"date"];
            
            [repayListData addObject:item];
        }
        
    }else { //等额本息
        for(int i = 0; i< months ; i++){
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            [item setObject:[NSString stringWithFormat:@"%.2f", firstPay] forKey:@"money"];
            [item setObject:[self getNewDateFromString:selectStartDate addMonth:i+1 day:0] forKey:@"date"];
            
            [repayListData addObject:item];
        }
    }
    return repayListData;
}

//增加n个月时间，换取一个新时间
-(NSString* )getNewDateFromString:(NSString*)formString addMonth:(NSInteger) addMonths  day:(NSInteger) days {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *formDate = [formatter dateFromString:formString];
    
    NSInteger year = formDate.year;
    NSInteger month = formDate.month + addMonths ;
    NSInteger day = formDate.day + days;
    if (day > 30) {
        month += day/30;
        day = day%30;
    }
    if (month > 12) {
        year += month/12;
        month = month%12;
    }
    
    [formatter setDateFormat:@"yyyy-MM-dd"];//需要的格式
    NSDate *newDate = [NSDate setYear:year month:month day:day hour:formDate.hour minute:formDate.minute];
    
    NSString *defaultShow = [formatter stringFromDate:newDate];
    return defaultShow;
}


//选择还款类型
- (IBAction)btn_selectRepayWay:(UIButton*)sender {

//    NSArray *_data = @[@"一次性还本付息", @"先息后本", @"等额本息", @"等额本金"];
    NSArray *_data = [dicWay allKeys];
    
    NSString *defultValue = currSelect? currSelect: sender.titleLabel.text;
    
    [BRStringPickerView showStringPickerWithTitle:nil dataSource:_data defaultSelValue:defultValue isAutoSelect:NO themeColor:nil resultBlock:^(id selectValue) {
        currSelect = selectValue;
        
        [sender setTitle:currSelect forState:UIControlStateNormal];
        repayWay = [[dicWay objectForKey:selectValue] integerValue];
        
        DLOG(@"SelectClick : %@  repayWay = %ld", selectValue, repayWay);

        [self counting];
    }];
}

//选择起息日
- (IBAction)btnSelectDate:(UIButton *)sender {
    
    NSDate *maxDate = [NSDate setYear:2038 month:12 day:31 hour:1 minute:1];
    NSDate *minDate = [NSDate setYear:2015 month:1 day:1 hour:1 minute:1]; //[NSDate date]; 为当前时间
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    
    [formatter setDateFormat:@"yyyy-MM-dd"]; //已选时间
    NSDate *selectDate = [formatter dateFromString:self.btn_selectStartDate.titleLabel.text];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];// view需要的格式
    NSString *defaultShow = [formatter stringFromDate:selectDate];
    
    [BRDatePickerView showDatePickerWithTitle:@"起息日" dateType:BRDatePickerModeYMD defaultSelValue:defaultShow minDate:minDate maxDate:maxDate isAutoSelect:NO themeColor:nil resultBlock:^(NSString *resultStr) {
        
        NSDate *resultdate = [formatter dateFromString:resultStr];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        selectStartDate = [formatter stringFromDate:resultdate];
        [self.btn_selectStartDate setTitle:selectStartDate forState:UIControlStateNormal];
        
    } cancelBlock:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 监听输入框
- ( void )textFieldDidEndEditing:( UITextField *)textField{
    
    [self counting];
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
