//
//  FCounterViewController.h
//  ftool
//
//  Created by apple on 2018/6/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "AJContainTableController.h"

@interface FCounterViewController : AJContainTableController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabelViewHeight;
@end
