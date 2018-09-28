//
//  ZLQRResultHistoryCell.m
//  ZLBasedAPP
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import "ZLQRResultHistoryCell.h"

@implementation ZLQRResultHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    UITapGestureRecognizer *tapges = [UITapGestureRecognizer alloc] initWithTarget:self action:@selector(<#selector#>)
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (CGRectContainsPoint(self.imgV.frame, point)) {
        return YES;
    }
    
    if (CGRectContainsPoint(self.textView.frame, point)) {
        return YES;
    }
    return NO;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (CGRectContainsPoint(self.imgV.frame, point)) {
//        return <#expression#>
//    }
//}

@end
