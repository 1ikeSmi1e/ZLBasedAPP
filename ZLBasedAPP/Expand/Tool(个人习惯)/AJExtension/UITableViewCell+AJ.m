//
//  UITableViewCell+AJ.m
//  SP2P_9
//
//  Created by eims on 16/12/12.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "UITableViewCell+AJ.h"
#import "UIColor+custom.h"

@implementation UITableViewCell (AJ)
#pragma  mark - 设置为顶部表头
- (void)setTopBar
{
    self.contentView.backgroundColor = RGB(213, 229, 249);
    self.userInteractionEnabled = NO;
}
@end
