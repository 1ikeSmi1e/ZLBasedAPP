//
//  FMonthBudgetRecordCell.h
//  ftool
//
//  Created by admin on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMonthBudgetRecordCell : UITableViewCell

@property (nonatomic, weak) id<UIViewOutterDelegate> delegate;

@property (nonatomic,strong) FFirstType *afirstType;
@end
