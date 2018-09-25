//
//  UITextField+custom.m
//  MobilePaymentOS
//
//  Created by admin on 2018/4/18.
//  Copyright © 2018年 yinsheng. All rights reserved.
//

#import "UITextField+custom.h"
#import "Macros_AJ.h"
#import "UIColor+custom.h"

@implementation UITextField (custom)
+ (id)textFieldWithFrame:(CGRect)frame
                 leftImg:(NSString *)leftImg
                delegate:(id)delegate
                    text:(NSString *)text
               textColor:(UIColor *)textColor
                textFont:(float)textFont
             placeholder:(NSString *)placeholder
               superview:(id)superview {
    
    UITextField *textField = [[AJLeftImgField alloc] initWithFrame:frame leftImg:leftImg];
    textField.borderStyle = UITextBorderStyleNone;
    if (delegate) {
        textField.delegate = delegate;
    }
    if (text.length > 0) {
        textField.text = text;
    }
    if (placeholder.length > 0) {
        textField.placeholder = placeholder;
    }
    if (textFont > 0) {
        textField.font = [UIFont systemFontOfSize:textFont];
    }
    textField.returnKeyType = UIReturnKeyDone;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone; //取消自动大写
    textField.autocorrectionType = UITextAutocorrectionTypeNo;  //取消自动修正
    textField.borderStyle = UITextBorderStyleNone;  //取消边框
    [superview addSubview:textField];
    return textField;
}
@end

@implementation AJTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.spellCheckingType = UITextSpellCheckingTypeNo;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
}
//- (void)drawPlaceholderInRect:(CGRect)rect {
//
//    [[UIColor blueColor] setFill];
//    [self.placeholder drawInRect:rect withAttributes:@{NSFontAttributeName :self.font}];
//    [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
//}

@end

@interface AJLeftImgField ()

@property (nonatomic, weak) UIImageView *leftImg;
@property (nonatomic, weak) UIView *leftSpace;
@end


@implementation AJLeftImgField

- (instancetype)initWithFrame:(CGRect)frame leftImg:(NSString *)leftImg
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *leftview = [[UIView alloc] init];
        self.leftView = leftview;
        
        UIImageView *leftImage = [[UIImageView alloc] init];
        //        leftImage.contentMode = UIViewContentMode;
        leftImage.image = [UIImage imageNamed:leftImg];
        [leftview addSubview:leftImage];
        self.leftImg = leftImage;
        
        UIView *leftSpace = [[UIView alloc] init];
        [leftview addSubview:leftSpace];
        self.leftViewMode = self.rightViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.leftSpace = leftSpace;
        
        CGFloat selfH  = self.bounds.size.height;
        
        self.leftView.frame = CGRectMake(0, 0, 35, selfH);
        
        self.leftImg.frame = CGRectMake(0, (selfH - 33)/2, 30, 33);
        self.leftSpace.frame = CGRectMake(30, 0, 5, 0);
        
    }
    return self;
}

@end


@implementation AJRoundConerField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.borderStyle = UITextBorderStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.spellCheckingType = UITextSpellCheckingTypeNo;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    //    NSDictionary *attrs =@{ NSFontAttributeName : [UIFont customFontWithSize:14] , NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#999999"]};
    //     self.textColor = [UIColor colorWithHexString:@"#333333"];
    //    if (self.placeholder) {
    //        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    //    }
}

@end

@implementation AJBorderField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.borderStyle = UITextBorderStyleNone;
    self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.layer.borderWidth = 1.f;
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.autocapitalizationType = UITextAutocapitalizationTypeNone; //取消自动大写
    self.autocorrectionType = UITextAutocorrectionTypeNo;  //取消自动修正
    self.textColor = UIColor.ys_black;
}

@end
