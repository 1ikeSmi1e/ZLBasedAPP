//
//  NavBar.m
//  SP2P_9
//
#import "NavBar.h"
#import "UIColor+custom.h"
#import "Macros_AJ.h"
#import "MyTools.h"

@interface NavBar ()


/**  中间title*/
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation NavBar

- (void)setTypeWhite:(BOOL)typeWhite
{
    _typeWhite = typeWhite;
    
    self.backgroundColor = [UIColor whiteColor];
    [_leftBtn setImage:[UIImage imageNamed:@"back_arrows_black"] forState:UIControlStateNormal];
    _titleLabel.textColor = RGB(51,51,51);
    [_rightBtn setTitleColor:RGB(255,121,0) forState:UIControlStateNormal];
}

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title WithleftName:(NSString *)leftName WithRightName:(NSString *)rightName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = NavgationColor;
        
//        NSLog(@"%@", self.backgroundColor);
        // 中间title
        if (title.length) {
            //            CGFloat titleLW =
            _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(MSWIDTH/2 - 60, 20, MSWIDTH-110, self.frame.size.height - 20)];
            _titleLabel.textColor = [UIColor whiteColor];
            _titleLabel.text = title;
            _titleLabel.font = [UIFont systemFontOfSize:18.0];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_titleLabel];
        }
        
        // 左边btn
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:_leftBtn];
        if (leftName.length) {
//
            [_leftBtn setTitle:leftName forState:UIControlStateNormal];
            _leftBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
//            CGSize leftBtnSize = [_leftBtn sizeWithTitle:leftName font:_leftBtn.titleLabel.font];
//            _leftBtn.frame = CGRectMake(0, 20, leftBtnSize.width + 20, self.frame.size.height - 20);
//        }else{
//            _leftBtn.hidden = YES;
            _leftBtn.frame = CGRectMake(15, 20, 60, self.frame.size.height - 20);

        }else{
            [_leftBtn setImage:[UIImage imageNamed:@"back_arrows_White"] forState:UIControlStateNormal];
            _leftBtn.frame = CGRectMake(15, 20, 25, self.frame.size.height - 20);

        }
        
        // 右边btn
        if(rightName.length){
            if ([rightName deptNameInputShouldChinese]) {
                _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_rightBtn setImage:[UIImage imageNamed:rightName] forState:UIControlStateNormal];
                [_rightBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
                _rightBtn.adjustsImageWhenHighlighted = NO;
                _rightBtn.frame = CGRectMake(MSWIDTH-20-15, 20, 20, self.frame.size.height - 20);
            }else{
                _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_rightBtn setTitle:rightName forState:UIControlStateNormal];
                _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                CGSize rightBtnSize = [rightName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
                CGFloat btnW = MAX(rightBtnSize.width+10, 34);
                _rightBtn.frame = CGRectMake(MSWIDTH - rightBtnSize.width - 15, 20, btnW , self.frame.size.height - 20);
                [_rightBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [self addSubview:_rightBtn];
        }
        CGFloat maxW = MSWIDTH - (MAX(CGRectGetWidth(_rightBtn.frame) + _rightBtn.frame.origin.x, CGRectGetWidth(_leftBtn.frame)+10)*2 +10);
        _titleLabel.frame = CGRectMake((MSWIDTH-maxW)/2, 20, maxW, frame.size.height-20);
    }
    return self;
}

- (id)initWithTitle:(NSString *)title leftName:(NSString *)leftName rightName:(NSString *)rightName delegate:(id<NavBarDelegate>)delegate
{
    UIViewController *controller = (UIViewController *)delegate;
    NavBar *bar = [self initWithFrame:CGRectMake(0, 0, MSWIDTH, 64) WithTitle:title WithleftName:leftName WithRightName:rightName];
    [controller.view addSubview:bar];
    bar.delegate = delegate;
    
    if ([UIScreen mainScreen].bounds.size.height == 812) {
        bar.height += 20;
        for (UIView *subV in bar.subviews) {
            subV.y += 20;
        }
    }
    return bar;
}

- (void)setLeftBtnHiden:(BOOL)leftBtnHiden
{
    _leftBtnHiden = leftBtnHiden;
    _leftBtn.hidden = leftBtnHiden;// defaults
}

- (void)backAction
{
    if ([self.delegate respondsToSelector:@selector(backItemClick)]) {
        [self.delegate backItemClick];
    }else{
        
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            
            UIViewController *controller = (UIViewController *)self.delegate;
            [controller.view endEditing:YES];
            [controller.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)nextAction
{
    if ([self.delegate respondsToSelector:@selector(nextItemClick)]) {
        [self.delegate nextItemClick];
    }
}
@end
