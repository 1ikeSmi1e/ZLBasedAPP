//
//  FSaveCounterViewController.m
//  ftool
//  存款计算器
//  Created by apple on 2018/6/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FSaveCounterViewController.h"
#import "BRStringPickerView.h"

@interface FSaveCounterViewController ()<UITextFieldDelegate> {
    
    NSInteger amount;
    NSInteger limit;
    NSInteger limitType; //0月， 1年
    
    NSInteger saveType; //0活期， 1定期
    double rate;        //年率利
    
    NSString *currSelect; //当前选择期限
}

@end

@implementation FSaveCounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"存款计算器" leftName:nil rightName:@"利率表" delegate:self];
   
     self.tf_amount.delegate = self;
//    [ self.tf_amount addTarget:self action:@selector(textFieldDidEndEditing:)  forControlEvents:UIControlEventEditingDidEnd];
}


//存款类型
- (IBAction)typeChange:(id)sender {
    UISegmentedControl *seg = sender;
    NSLog(@"%ld", seg.selectedSegmentIndex);
    saveType = seg.selectedSegmentIndex;
    
    [self changeRate];
    [self counter];
}

-(void) changeRate{
    NSMutableDictionary *varRate = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1.10",@"3个月", @"1.30",@"6个月", nil];
    NSDictionary *constantRate = [NSDictionary dictionaryWithObjectsAndKeys:@"1.50",@"1年", @"2.10",@"2年",
                                  @"2.75", @"3年", @"2.75", @"5年", nil];
    
    if(saveType == 0){      //活期
        rate = 0.35; //利率固定的
        
    }else {   //定期
        if(limit > 0){
            if(limitType == 0){ //月
                rate = limit > 3 ? 1.30:1.10;
            }else {          //年
                if(limit >= 3){
                    rate = 2.75;
                }else {
                    rate = [[constantRate objectForKey:currSelect] doubleValue];
                }
            }
        }
        
    }
    self.lb_rate.text = [NSString stringWithFormat:@"%.2f", rate];
}


- (IBAction)selectLimit:(id)sender {
    NSString *defultValue = currSelect? currSelect: self.btn_select.titleLabel.text;
    
    NSArray *_data = @[@"3个月", @"6个月", @"1年", @"2年", @"3年", @"4年", @"5年", @"6年",
                       @"7年", @"8年", @"9年", @"10年", @"15年", @"18年", @"20年", @"25年",
                       @"30年", @"35年", @"40年", @"50年", @"60年", @"80年"];
    
    [BRStringPickerView showStringPickerWithTitle:nil dataSource:_data defaultSelValue:defultValue isAutoSelect:YES themeColor:nil resultBlock:^(id selectValue) {
        currSelect = selectValue;
        
        [sender setTitle:currSelect forState:UIControlStateNormal];
        
        DLOG(@"accountCategeryClick : %@", selectValue);
        if ([currSelect containsString:@"个月"]) {
            limitType = 0;
            limit = [[currSelect stringByReplacingOccurrencesOfString:@"个月" withString:@""] integerValue] ;
        }else {
            limitType = 1;
            limit = [[currSelect stringByReplacingOccurrencesOfString:@"年" withString:@""] integerValue] ;
        }
        [self changeRate];
        [self counter];
    }];
}

//计算
- (void) counter{
    if(rate <= 0 ){
        return;
    }
    double _limit = limit;
    if (limitType == 0) { //期限为月时
        _limit = ((double)limit)/12.0;
    }
    //利息 = 金额 * 期限 * (年率利%)
    double lixi = amount * _limit * (rate/100);
    double benxi = amount + lixi;
    
    self.lb_lixi.text = [NSString stringWithFormat:@"%.2f", lixi];
    self.lb_benxi.text = [NSString stringWithFormat:@"%.2f", benxi];
    
}


- ( void )textFieldDidEndEditing:( UITextField *)textField{
    amount = [textField.text integerValue];
    [self counter];
    NSLog(@"%ld", amount);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextItemClick{
    UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Counters" bundle:nil];
    UIViewController *tenderVC = [homeStoryboard instantiateViewControllerWithIdentifier:@"rateController"];
//    tenderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tenderVC animated:YES];
}

@end
