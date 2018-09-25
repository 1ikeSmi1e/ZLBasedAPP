//
//  UIButton+Custom.m
//  MobilePaymentOS
//
//  Created by admin on 2018/4/18.
//  Copyright © 2018年 yinsheng. All rights reserved.
//

#import "UIButton+Custom.h"
#import "UIColor+custom.h"
#import "UIImage+AJ.h"
#import "NSString+AJ.h"

@implementation UIButton (Custom)

@end

@implementation AJCornerCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    self.adjustsImageWhenHighlighted = NO;
    if (!self.currentBackgroundImage) {
        [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:UIControlStateNormal];
        UIColor *HighlightedColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self setBackgroundImage:[UIImage imageWithColor:HighlightedColor] forState:UIControlStateHighlighted];
        UIColor *disabledColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        [self setBackgroundImage:[UIImage imageWithColor:disabledColor] forState:UIControlStateDisabled];
    }
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
}

@end

@implementation AJBorderBtn

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderColor = UIColor.ys_red.CGColor;
    self.layer.borderWidth = 0.8f;
    [self setTitleColor:UIColor.ys_red forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.borderColor = UIColor.ys_red.CGColor;
        self.layer.borderWidth = 0.8f;
        [self setTitleColor:UIColor.ys_red forState:UIControlStateNormal];
    }
    return self;
}
@end


@implementation CheckBoxBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.adjustsImageWhenHighlighted = NO;
        [self setImage:[UIImage imageNamed:@"Regiser_disagree"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"Regiser_agree"] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(changeCheckBoxState:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)changeCheckBoxState:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
@end

@interface ShadowCornerBtn()

@property (nonatomic, assign) BOOL ys_enabled;// default is YES
@property (nonatomic, weak) CAGradientLayer *gradientLayer;
@end
@implementation ShadowCornerBtn

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.ys_enabled = YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.ys_enabled = YES;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
}

- (void)drawRect:(CGRect)rect
{
    UIColor *color_middle = [UIColor colorWithHexString:@"#ff6a00"];
    CGFloat selfH = rect.size.height;
    self.layer.cornerRadius = selfH/2;
    self.layer.shadowColor = color_middle.CGColor;
    self.layer.shadowOpacity = 0.35f;
    CGFloat shadowH = MIN(3.5 * selfH/41, 5);
    self.layer.shadowOffset = CGSizeMake(0, shadowH);
    
    if (self.gradientLayer) return;
    UIColor *color_start = RGB(251,138,36);// [UIColor redColor];
    UIColor *color_end = RGB(255,102,0);//[UIColor greenColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    CGFloat alpha = self.ys_enabled?1.f:.5;
    gradientLayer.opacity = alpha;
    self.gradientLayer = gradientLayer;
    gradientLayer.colors = @[(__bridge id)color_start.CGColor, (__bridge id)color_middle.CGColor, (__bridge id)color_end.CGColor];
    //    gradientLayer.position = self.center;
    gradientLayer.locations = @[@0.0, @.5, @1.0];
    gradientLayer.type = kCAGradientLayerAxial;
    gradientLayer.startPoint = CGPointMake(0, .5);
    gradientLayer.endPoint = CGPointMake(1.f, .6);
    gradientLayer.cornerRadius = selfH/2;
    gradientLayer.masksToBounds = YES;
    gradientLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [self.layer insertSublayer:gradientLayer atIndex:0];
    //    DLOG(@"gradientLayerdrawRect");
    gradientLayer.shouldRasterize = self.layer.shouldRasterize = YES;
    gradientLayer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setEnabled:(BOOL)enabled
{
    CGFloat alpha = 0;
    if (enabled == YES) {
        
        alpha = 1.f;
    }else{
        alpha = .5f;
    }
    self.alpha = alpha;
    //    [super setEnabled:enabled];
    self.userInteractionEnabled = enabled;
    self.ys_enabled = enabled;
}

- (void)setAlpha:(CGFloat)alpha
{
    CALayer *gradientLayer = self.layer.sublayers.firstObject;
    if ([gradientLayer isKindOfClass:[CAGradientLayer class]]) {
        
        gradientLayer.opacity = alpha;
        //        DLOG(@"gradientLayer");
    }
}
@end

@implementation AJLeftImgBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}
@end
@implementation AJRightImgBtn
{
    CGSize _textSize;
    CGSize _imgSize;
}

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
    // 计算出字体长度，
    _textSize = [@"按时间发布" textSizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:16]];
    _imgSize = CGSizeMake(15, 7) ;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    //    CGFloat x = contentRect.size.width/2 - _imgSize.width + _textSize.width/2+10;
    //    CGFloat imageX = ((x + _imgSize.width)>contentRect.size.width)? (contentRect.size.width - _imgSize.width): x;
    CGFloat imageX = contentRect.size.width  - _imgSize.width;
    
    return CGRectMake( imageX, 0, _imgSize.width, contentRect.size.height );
}

// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageX = contentRect.size.width - _imgSize.width;
    CGFloat titleX = imageX - _textSize.width  - 10;
    //    CGFloat titleX = 0;
    
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, 0, _textSize.width, titleH);
}

@end


static CGFloat const AJaxTabBarButtonImageRatio = 0.60;// 图标的高度比例
static CGFloat const AJTopBottomHeight = (15.f+10.f);
@implementation AJBottomTitleBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.font= [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 20.f;
    CGFloat imageH = 45;//(contentRect.size.height - AJTopBottomHeight)*AJaxTabBarButtonImageRatio;
    return CGRectMake(0, imageY, contentRect.size.width, imageH);
}

// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 10.f + (contentRect.size.height) *AJaxTabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY - 10;
    return CGRectMake(0, titleY, titleW, titleH);
}

@end
