//
//  FHouseCounterSimpleViewController.m
//  ftool
//  纯公积金 或 商业贷
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FHouseCounterSimpleViewController.h"
#import "BaseContentCell.h"
#import "NSString+Shove.h"

#define LH_RESULT 40 //结果行高

@interface FHouseCounterSimpleViewController (){
    CGRect headRect;
    NSInteger repayType;
    NSInteger lastType;
    
    NSArray *_titleArray;
    NSArray *_contentArray;
}

@end

@implementation FHouseCounterSimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    headRect = self.headView.frame;
    if (!_isBusiness) { //公积金少一行
        headRect.size.height -= LH_RESULT;
        [self resetHeadHight: 0];
        
        // 公积金 不要折扣项
        _cst_gjtTop.constant -= 44;
    }

    [self.tableView registerClass:[BaseContentCell class] forCellReuseIdentifier:@"RateViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [_tf_amount setText:@"10"]; //贷款
    [_tf_discount setText:@"1.0"]; //默认没折扣
    [_tf_rate setText:_isBusiness ? @"4.9" : @"3.25"]; //利率
    [_tf_limit setText:@"10"]; //年限
    
    repayType = 0;
    
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
    if ([self isInputed:_tf_amount andPromit:@"请输入金额"] && [self isInputed:_tf_rate andPromit:@"请输入利率"]
        && [self isInputed:_tf_limit andPromit:@"请输入年限"]) {
        
        [self changeFirstTitle];
        
        double amount = [_tf_amount.text doubleValue] * 10000;
        double monthRate = [_tf_rate.text doubleValue]/100/12;   //月利率
        
        if([_tf_discount.text doubleValue] != 1 && [_tf_discount.text doubleValue] > 0){
            monthRate = monthRate * [_tf_discount.text doubleValue];  //折扣
        }
        long repayMonths = [_tf_limit.text integerValue] * 12; //还款期数
        
        if (repayType == 0) { //等额本息
            //            amount = 10000; 示例 https://wenku.baidu.com/view/12c20baa680203d8ce2f244d.html?from=search
            //            monthRate = 0.005541667;   repayMonths = 120;
            
            //每月还款 = [金额*月利率*（1+月利率)^还款月数] / [(1+月利率) ^ 还款月数-1]
            double apiecePay = (amount * monthRate * powl((1+monthRate), repayMonths))
            / ( powl((1+monthRate), repayMonths) -1);
            //总共还款
            double allRepay = apiecePay * repayMonths;
            //共还利息
            double allTerest = allRepay - amount;
            [_lb_firstRepay setText:[NSString stringWithFormat:@"%.2f", apiecePay]];
            [_lb_allRepayAmount setText:[NSString stringWithFormat:@"%.2f", allRepay]];
            [_lb_allRepayInterest setText:[NSString stringWithFormat:@"%.2f", allTerest]];
            
            [self generateListData:repayMonths apieceRepay:apiecePay andDecrease:0] ;
        }
        else {     //等额本金 实例 https://wenku.baidu.com/view/7c88252bf5335a8102d220f1.html?from=search
            //每月还款 = [贷款金额/月数] + （本金 - 已还本金累计）* 月利率
            double alwayRepay = 0; //已还
            double apieceRepay = (amount/repayMonths) + (amount - alwayRepay) * monthRate;
            
            double monthBenjin = amount/repayMonths; //每月本金
            double firstMonthPay = monthBenjin + (amount * monthRate); //第一月还款
            double secondMonthPay = monthBenjin + ((amount - monthBenjin) * monthRate); //第二月还款
            
            double decrease = firstMonthPay - secondMonthPay;  //每月递减(利息)
            
            [_lb_firstRepay setText:[NSString stringWithFormat:@"%.2f", firstMonthPay]];
            [_lb_dicreaseAmount setText:[NSString stringWithFormat:@"%.2f", decrease]];
            
            double allPayInterest = 0;
            double fisrtMothInterest = amount * monthRate; //第一月利息
            //总还利息 累计
            for (int i = 0; i< repayMonths; i++){
                allPayInterest += (fisrtMothInterest - decrease*i);
            }
            
            [_lb_allRepayAmount setText:[NSString stringWithFormat:@"%.2f", amount + allPayInterest]];
            [_lb_allRepayInterest setText:[NSString stringWithFormat:@"%.2f", allPayInterest]];
            
            [self generateListData:repayMonths apieceRepay:firstMonthPay andDecrease:decrease];
        }
    }
}

//生成列表数据
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
