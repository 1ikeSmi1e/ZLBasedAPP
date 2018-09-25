//
//  BaseContentCell.m
//  SP2P_10
//
//  Created by md005 on 16/5/20.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "BaseContentCell.h"

@implementation BaseContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self initLayout];
	}
	return self;
}

- (void)initLayout
{
	_titLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, MSWIDTH/2 - 15, ITHIGHT-14)];
	_titLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
	_titLabel.textAlignment = NSTextAlignmentLeft;
	_titLabel.textColor = [UIColor blackColor];
	[self.contentView addSubview:_titLabel];
	
	
	_conLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH/2, 10, MSWIDTH/2 - 15, ITHIGHT-14)];
	_conLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
	_conLabel.textColor = [UIColor blackColor];
	_conLabel.textAlignment = NSTextAlignmentRight;
	[self.contentView addSubview:_conLabel];
    
	
	_lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ITHIGHT -1, MSWIDTH, 0.5)];
	_lineLabel.backgroundColor = baseGrayColor;
	[self.contentView addSubview:_lineLabel];
}


@end
