//
//  FMyIncomeRecordCell.m
//  ftool
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FMyIncomeRecordCell.h"

@implementation FMyIncomeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.moneyL.textColor = [UIColor ys_red];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
