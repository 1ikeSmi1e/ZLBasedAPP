//
//  FMineCell.m
//  ftool
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FMineCell.h"

@implementation FMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.image = nil;
    self.titleL.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
