//
//  InputView.m
//  SP2P_10
//
//  Created by md005 on 16/3/26.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "UnderlineView.h"

//#define kImgHeight  self.frame.size.height * 0.9
@interface UnderlineView()
@property (nonatomic,strong) UIView *superView;
@property (nonatomic,strong) UILabel *lineLabel;
@end

@implementation UnderlineView

//storyboard 中引用不会调用此方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addUnderLine];
    }
    NSLog(@"%s", __FUNCTION__);
    return self;
}

//添加下划线
- (void) addUnderLine{
    _lineLabel = [[UILabel alloc]init];
    _lineLabel.backgroundColor = RGB(235, 235, 235);
    [self addSubview:_lineLabel];
    _superView = self;
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_superView.mas_left).with.offset(0);
        make.right.equalTo(_superView.mas_right).with.offset(0);
        make.bottom.equalTo(_superView.mas_bottom).with.offset(1);
        make.height.mas_equalTo(1);
        
    }];
    
}

- (void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    
    // 确定子控件的frame（这里得到的self的frame/bounds才是准确的）
//    CGFloat width = self.bounds.size.width;
//    CGFloat height = self.bounds.size.height;
     [self addUnderLine];
    
}


- (id)initWithImgName:(NSString *)imgName WithSelectImgName:(NSString *)selectImgName placeContent:(NSString *)content{
	if (self = [super init]) {
		
		_superView = self;
		// 左边的图片
//        _leftImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName] highlightedImage:[UIImage imageNamed:selectImgName]];
//        [self addSubview:_leftImg];
//        [_leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_superView.mas_top).with.offset(5);
//            make.left.equalTo(_superView.mas_left).with.offset(10);
//            make.size.mas_equalTo(CGSizeMake(20 ,20));
//        }];
		
		// 中间的输入框
//        _inputField = [[UITextField alloc]init];
//        _inputField.placeholder = content;
//        _inputField.keyboardType = UIKeyboardTypePhonePad;
//        [_inputField setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0]];
//        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [self addSubview:_inputField];
//        [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_superView.mas_top).with.offset(5);
//            make.left.equalTo(_superView.mas_left).with.offset(40);
//            make.right.equalTo(_superView.mas_right).with.offset(-5);
//            make.height.mas_equalTo(20);
//        }];

		
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
