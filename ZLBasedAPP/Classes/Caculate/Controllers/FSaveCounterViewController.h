//
//  FSaveCounterViewController.h
//  ftool
//
//  Created by apple on 2018/6/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZLBaseViewController.h"

@interface FSaveCounterViewController : ZLBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *lb_lixi;
@property (weak, nonatomic) IBOutlet UILabel *lb_benxi;
@property (weak, nonatomic) IBOutlet UITextField *tf_amount;

- (IBAction)typeChange:(id)sender;
- (IBAction)selectLimit:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_select;
@property (weak, nonatomic) IBOutlet UILabel *lb_rate;
@end
