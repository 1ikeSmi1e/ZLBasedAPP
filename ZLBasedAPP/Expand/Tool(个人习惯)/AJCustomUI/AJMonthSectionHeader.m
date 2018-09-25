//
//  AJMonthSectionHeader.m
//  SP2P_9
//
//  Created by eims on 17/2/23.
//  Copyright © 2017年 EIMS. All rights reserved.
//

#import "AJMonthSectionHeader.h"
#import "UIColor+custom.h"

@interface AJMonthSectionHeader ()
@property (nonatomic, weak) UILabel *textL;
@end
@implementation AJMonthSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = RGB(242,242,242);
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = RGB(102,102,102);
        [self.contentView addSubview:label];
        self.textL = label;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    self.textL.text = text;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textL.frame = CGRectMake(15, 0, self.bounds.size.width-30, self.bounds.size.height);
}
@end
