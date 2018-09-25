//
//  InputView.m
//  SP2P_10
//
//  Created by md005 on 16/3/26.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "InputView.h"

#define kImgHeight  self.frame.size.height * 0.9
@interface InputView()
@property (nonatomic,strong) UIView *superView;

@end

@implementation InputView

- (id)initWithImgName:(NSString *)imgName WithSelectImgName:(NSString *)selectImgName placeContent:(NSString *)content{
	if (self = [super init]) {
		
		_superView = self;
		// 左边的图片
		_leftImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName] highlightedImage:[UIImage imageNamed:selectImgName]];
		[self addSubview:_leftImg];
		[_leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(_superView.mas_top).with.offset(5);
			make.left.equalTo(_superView.mas_left).with.offset(10);
			make.size.mas_equalTo(CGSizeMake(20 ,20));
		}];
		
		// 中间的输入框
		_inputField = [[UITextField alloc]init];
		_inputField.placeholder = content;
		_inputField.keyboardType = UIKeyboardTypePhonePad;
		[_inputField setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0]];
		_inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
		[self addSubview:_inputField];
		[_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(_superView.mas_top).with.offset(5);
			make.left.equalTo(_superView.mas_left).with.offset(40);
			make.right.equalTo(_superView.mas_right).with.offset(-5);
			make.height.mas_equalTo(20);
		}];

		
		// 底部线条
		UILabel *lineLabel = [[UILabel alloc]init];
		lineLabel.backgroundColor = [UIColor lightGrayColor];
		[self addSubview:lineLabel];
		[lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(_superView.mas_left).with.offset(0);
			make.right.equalTo(_superView.mas_right).with.offset(0);
			make.bottom.equalTo(_superView.mas_bottom).with.offset(1);
			make.height.mas_equalTo(0.5);
		}];
	}
	return self;
}

@end
