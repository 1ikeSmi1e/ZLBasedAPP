//
//  ZTAppCalculatorViewController.m
//  RCloudMessage
//
//  Created by zt on 17/7/6.
//  Copyright © 2017年 ZongTian. All rights reserved.
//

#import "ZTAppCalculatorViewController.h"
#import "CalculateMethod.h"
#import "YGCTradeWindow.h"
#import "UIView+YGCExtension.h"
#define lineWidth 1


// 屏幕尺寸
#define YGCScreenH [UIScreen mainScreen].bounds.size.height
#define YGCScreenW [UIScreen mainScreen].bounds.size.width
#define YGCRGBAColor255(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define YGCRGBColor255(r, g, b) YGCRGBAColor255(r, g, b, 255.0)


@interface ZTAppCalculatorViewController ()
{
    UIView *_container;
    UITextField *showLabel; // 显示运算的label
    UILabel *formulaLabel;  // 显示公式的label
    UIButton *closeBtn;   // 关闭按钮
    UIButton *enlargeBtn;   // 放大按钮
    int n;  // 用来计算button的位置
    
    long double currentNumber;  // 当前输入的数字
    CalculateMethod *calMethod;
    int totalDecimals;//总位数，规定计算位数最多16位
    BOOL isdecimal; //是否是小数
    int decimals;   //小数位数
    int op;   //记录的运算符
    
    BOOL isEqualClick; //上一次点击的是否是等于
    
    int nowTag ; // 记录本次是点击的什么;
    int realPreTag; // 记录上一次是点击的什么;
    
    UIButton *cButton;  // 保存的的clabel
    
    int marginTop ;
    BOOL isNewSetEnd; //以viewConroller形式显示后
}


@property (nonatomic, weak) UIView *showView; ///< <#name#>
@property(nonatomic, assign) BOOL isEnlarge; ///< 是否是全屏

-(void)displayString:(NSString *)str withMethod:(NSString *)method;
-(void)processDigit:(int)digit;
-(void)processOp:(int)theOp;
-(void)clear;

@end

@implementation ZTAppCalculatorViewController


- (void)closeClick:(id)sender
{
    [YGCTradeWindow hide];
}

- (void)enlargeClick:(id)sender
{
    if (isNewSetEnd)  return;
    
    if (self.isEnlarge) {
        
        [YGCTradeWindow shareWindow].frame =  CGRectMake((YGCScreenW - 220)*0.5, (YGCScreenH - 383)*0.5, 220, 383);
        
        self.showView.frame = CGRectMake(0, marginTop, 220, 108);
        closeBtn.frame = CGRectMake(220-40, 0, 40, 40);
        [enlargeBtn setImage:[UIImage imageNamed:@"计算器_放大.png"] forState:UIControlStateNormal];
        
        enlargeBtn.frame = CGRectMake(220-80, 0, 40, 40);
        formulaLabel.frame = CGRectMake( 10,_isNew? 10: 40, 200, 28);
        formulaLabel.font = [UIFont systemFontOfSize:18];
        showLabel.frame =  CGRectMake(10, _isNew? 30:68, 200, 40);
        showLabel.font = [UIFont systemFontOfSize:32];
        
        _container.frame = CGRectMake(0,108, 220, 383-108);
        float containerWidth = CGRectGetWidth(_container.frame);
        float containerHeight = CGRectGetHeight(_container.frame);
        
        n = 0;
        [_container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self addBtnWithFloatWidthContainerWidth:containerWidth containerHeight:containerHeight btnSize:16];
        
        self.isEnlarge = NO;
    } else {
        
        [YGCTradeWindow shareWindow].frame = CGRectMake(0, 0, YGCScreenW, YGCScreenH);
        
        self.showView.frame = CGRectMake(0, marginTop, YGCScreenW, 200);
        closeBtn.frame = CGRectMake(YGCScreenW-40, 10, 40, 40);
        enlargeBtn.frame = CGRectMake(YGCScreenW-80, 10, 40, 40);
        [enlargeBtn setImage:[UIImage imageNamed:@"计算器_缩小.png"] forState:UIControlStateNormal];
        
        formulaLabel.frame = CGRectMake( 10, _isNew? 10:60, YGCScreenW-20, 50);
        formulaLabel.font = [UIFont systemFontOfSize:34];
        showLabel.frame =  CGRectMake( 10, _isNew? 60:120, YGCScreenW-20, 70);
        showLabel.font = [UIFont systemFontOfSize:56];
        
        _container.frame = CGRectMake(0,200, YGCScreenW, YGCScreenH-200);
        float containerWidth = CGRectGetWidth(_container.frame);
        float containerHeight = CGRectGetHeight(_container.frame);
        
        n = 0;
        [_container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self addBtnWithFloatWidthContainerWidth:containerWidth containerHeight:containerHeight btnSize:32];
        self.isEnlarge = YES;
        if (_isNew) {
            isNewSetEnd = YES;
        }
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    marginTop = 0;
    if(_isNew){
        ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"小计算器" leftName:nil rightName:@"" delegate:self];
        marginTop = bar.maxY;
    }
    
    //加阴影- 设置阴影
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.view.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.view.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    self.view.layer.shadowRadius = 4;//阴影半径，默认3
    
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0,marginTop, 220, 108)];
    showView.backgroundColor = YGCRGBColor255(79, 83, 102);
    self.showView = showView;
    [self.view addSubview:showView];
    
    
    // 添加按钮
    UIButton *closeB = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn = closeB;
    closeBtn.frame = CGRectMake(220-40, 0, 40, 40);
    [closeBtn setImage:[UIImage imageNamed:@"计算器_叉.png"] forState:UIControlStateNormal];
    //    closeBtn.image = [UIImage imageNamed:@"计算器_叉.png"];
    closeBtn.contentMode = UIViewContentModeCenter;
    closeBtn.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick:)];
    //    [closeBtn addGestureRecognizer:closeTap];
    [closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [showView addSubview:closeBtn];
    
    
    UIButton *enlargeB = [UIButton buttonWithType:UIButtonTypeCustom];
    enlargeBtn = enlargeB;
    enlargeBtn.frame = CGRectMake(220-80, 0, 40, 40);
    [enlargeBtn setImage:[UIImage imageNamed:@"计算器_放大.png"] forState:UIControlStateNormal];
    
    //    enlargeBtn.image = [UIImage imageNamed:@"计算器_放大.png"];
    enlargeBtn.contentMode = UIViewContentModeCenter;
    enlargeBtn.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *enlargeBtnTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeClick:)];
    //    [enlargeBtn addGestureRecognizer:enlargeBtnTap];
    [enlargeBtn addTarget:self action:@selector(enlargeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [showView addSubview:enlargeBtn];
    
    UILabel *formulaLab = [[UILabel alloc] initWithFrame:CGRectMake( 10, 40, 200, 28)];
    formulaLabel = formulaLab;
    formulaLabel.backgroundColor = YGCRGBColor255(79, 83, 102);
    formulaLabel.text = @"";
    [formulaLabel setTextColor:YGCRGBColor255(156, 160, 181)];
    formulaLabel.textAlignment = NSTextAlignmentRight;
    formulaLabel.font = [UIFont systemFontOfSize:18];
    formulaLabel.userInteractionEnabled = NO;
    [showView addSubview:formulaLabel];
    
    //添加显示
    showLabel = [[UITextField alloc]initWithFrame:CGRectMake(10, 68, 200, 40)];
    showLabel.backgroundColor = YGCRGBColor255(79, 83, 102);
    showLabel.text = @"0";
    [showLabel setTextColor:[UIColor whiteColor]];
    showLabel.textAlignment = NSTextAlignmentRight;
    showLabel.font = [UIFont systemFontOfSize:32];
    showLabel.userInteractionEnabled = NO;
    [showView addSubview:showLabel];
    
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGes:)];
    longGes.minimumPressDuration = 1.0;
    [showView addGestureRecognizer:longGes];
    
    
    //初始化各参数
    totalDecimals=0;
    isdecimal=NO;
    decimals=0;
    op=0;
    [self displayString:@"0" withMethod:@"cover"];
    calMethod=[[CalculateMethod alloc]init];
    
    
    _container = [[UIView alloc]initWithFrame:CGRectMake(0,108, 220, 383-108)];
    
    [self.view addSubview:_container];
    
    float containerWidth = CGRectGetWidth(_container.frame);
    float containerHeight = CGRectGetHeight(_container.frame);
    
    [_container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addBtnWithFloatWidthContainerWidth:containerWidth containerHeight:containerHeight btnSize:16];
    
    if(_isNew){
        [self enlargeClick:enlargeBtn];
        [enlargeBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)longGes:(id)sender
{
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (press.state == UIGestureRecognizerStateBegan) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = showLabel.text;
        
        //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_container animated:YES];
        //        hud.mode = MBProgressHUDModeText;
        //        hud.labelText = @"计算结果已复制到剪切板";
        //        hud.margin = 10.f;
        //        hud.removeFromSuperViewOnHide = YES;
        //        [hud hide:YES afterDelay:2.0];
        
    }
}




- (void)addBtnWithFloatWidthContainerWidth:(CGFloat)containerWidth containerHeight:(CGFloat)containerHeight btnSize:(CGFloat)fontsize
{
    
    float buttonHeight = containerHeight/5; //获取每个button的高度
    float buttonWidth = containerWidth/4; //获取每个Button的宽度
    
    
    /*-----------------------------添加按钮-------------------------------------*/
    NSArray *titleArray = @[@"AC",@"⇦",@"%",@"÷",@"7",@"8",@"9",@"x",@"4",@"5",@"6",@"-",@"1",@"2",@"3",@"+",@"0",@".",@"="];
    
    NSArray *tagArray = @[@"10",@"11",@"12",@"13",@"7",@"8",@"9",@"14",@"4",@"5",@"6",@"15",@"1",@"2",@"3",@"16",@"0",@"-1",@"17"];
    
    for (int i=0; i<5; i++) {
        if (i<4) {
            for (int j=0; j<4; j++) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(j*(containerWidth/4), i*(containerHeight/5), buttonWidth, buttonHeight);
                
                [button addTarget:self action:@selector(caculate:) forControlEvents:UIControlEventTouchUpInside];
                
                //                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(caculate:)];
                //                [button addGestureRecognizer:tap];
                //                button.userInteractionEnabled = YES;
                
                button.tag = [tagArray[n] intValue];
                NSString *title = titleArray[n++];
                //                [button setBackgroundColor:[UIColor whiteColor]];
                
                //                [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor] widthHeight:20] forState:UIControlStateNormal];
                //                [button setBackgroundImage:[UIImage createImageWithColor:YGCRGBColor255(238, 238, 238) widthHeight:20] forState:UIControlStateHighlighted];
                
                [button setBackgroundColor:[UIColor whiteColor]];
                
                button.titleLabel.font = [UIFont fontWithName:@"Heiti TC" size:fontsize];
                [button setTitle:title forState:UIControlStateNormal];
                [button setTitleColor:YGCRGBColor255(102, 102, 102) forState:UIControlStateNormal];
                //                button.textAlignment = NSTextAlignmentCenter;
                //                button.textColor = YGCRGBColor255(102, 102, 102);
                
                if (i==0 && j==0) {
                    [button setTitleColor:YGCRGBColor255(255, 130, 55) forState:UIControlStateNormal];
                    
                    //                    button.textColor = YGCRGBColor255(255, 130, 55);
                    cButton = button;
                    if (currentNumber > 0 ||isdecimal) {
                        [button setTitle:@"C" forState:UIControlStateNormal];
                    }
                }
                
                [_container addSubview:button];
            }
        }
        if (i==4) {
            for (int j=0; j<3; j++) {
                if (j==0) {
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(0, (buttonHeight*4), buttonWidth*2, buttonHeight);
                    
                    [button addTarget:self action:@selector(caculate:) forControlEvents:UIControlEventTouchUpInside];
                    
                    //                    button.backgroundColor = [UIColor whiteColor];
                    
                    //                    [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor] widthHeight:20] forState:UIControlStateNormal];
                    //                    [button setBackgroundImage:[UIImage createImageWithColor:YGCRGBColor255(238, 238, 238) widthHeight:20] forState:UIControlStateHighlighted];
                    
                    [button setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    [button setTitle:titleArray[n] forState:UIControlStateNormal];
                    
                    button.tag = [tagArray[n] intValue];
                    
                    button.titleLabel.font = [UIFont fontWithName:@"Heiti TC" size:fontsize];
                    [button setTitleColor:YGCRGBColor255(102, 102, 102) forState:UIControlStateNormal];
                    //                    button.font = [UIFont fontWithName:@"Heiti TC" size:fontsize];
                    //                    button.textAlignment = NSTextAlignmentCenter;
                    //                    button.textColor = YGCRGBColor255(102, 102, 102);
                    
                    [_container addSubview:button];
                    n++;
                }else {
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(j*buttonWidth+buttonWidth, (buttonHeight*4), buttonWidth, buttonHeight);
                    NSLog(@"%@",titleArray[n]);
                    [button addTarget:self action:@selector(caculate:) forControlEvents:UIControlEventTouchUpInside];
                    
                    //                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(caculate:)];
                    //                    [button addGestureRecognizer:tap];
                    //                    button.userInteractionEnabled = YES;
                    
                    //                    [button setBackgroundColor:[UIColor whiteColor]];
                    //                    button.text = titleArray[n];
                    
                    //                    [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor] widthHeight:20] forState:UIControlStateNormal];
                    //                    [button setBackgroundImage:[UIImage createImageWithColor:YGCRGBColor255(238, 238, 238) widthHeight:20] forState:UIControlStateHighlighted];
                    
                    [button setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    [button setTitle:titleArray[n] forState:UIControlStateNormal];
                    
                    button.tag = [tagArray[n] intValue];
                    
                    [button setTitleColor:YGCRGBColor255(102, 102, 102) forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont fontWithName:@"Heiti TC" size:fontsize];
                    
                    
                    //                    button.font = [UIFont fontWithName:@"Heiti TC" size:fontsize];
                    //                    button.textAlignment = NSTextAlignmentCenter;
                    //                    button.textColor = YGCRGBColor255(102, 102, 102);
                    
                    [_container addSubview:button];
                    if (n==18) {
                        //                        [button setBackgroundColor:[UIColor orangeColor]];
                        
                        //                        [button setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xf99012) widthHeight:20] forState:UIControlStateNormal];
                        //                        [button setBackgroundImage:[UIImage createImageWithColor:YGCRGBColor255(235, 110, 35) widthHeight:20] forState:UIControlStateHighlighted];
                        
                        [button setBackgroundColor:[UIColor orangeColor]];
                        
                        
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    n++;
                    
                }
            }
            
        }
    }
    
    //添加横线
    for (int i=0; i<6; i++) {
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, i*buttonHeight, containerWidth, lineWidth)];
        lable.backgroundColor = YGCRGBColor255(233, 233, 233);
        [_container addSubview:lable];
    }
    //添加竖线
    for (int i=0; i<5; i++) {
        UILabel *label = [[UILabel alloc]init];
        if (i==1) {
            label.frame = CGRectMake(i*buttonWidth, 0, lineWidth, containerHeight-buttonHeight);
        }else {
            label.frame = CGRectMake(i*buttonWidth, 0, lineWidth, containerHeight);
        }
        label.backgroundColor = YGCRGBColor255(233, 233, 233);
        [_container addSubview:label];
    }
    
}


- (void)caculate:(UIButton *)sender{
    
    //    UILabel *label;
    //    if ([gestureRecognizer.view isKindOfClass:[UILabel class]]) {
    //        label = (UILabel *)gestureRecognizer.view;
    //    }
    //    showLabel.text = [NSString stringWithFormat:@"%@",label.text];
    [self clickButtonsWithTag:sender.tag];
}


-(void)clickButtonsWithTag:(int)digit
{
    
    if (((digit == nowTag) && digit == 13)
        || ((digit == nowTag) && digit == 14)
        || ((digit == nowTag) && digit == 15)
        || ((digit == nowTag) && digit == 16)) {
        
        return;
    }
    nowTag = digit;
    
    if(digit==-1 && isdecimal==NO)   //若点击了小数点“.”
    {
        isdecimal=YES;
        
        if (realPreTag == 13 || realPreTag == 14 || realPreTag == 15 || realPreTag == 16 || realPreTag == 17)
        {
            [self displayString:@"0." withMethod:@"cover"];
            
        } else {
            [self displayString:@"." withMethod:@"add"];
        }
        isEqualClick = NO;
        [cButton setTitle:@"C" forState:UIControlStateNormal];
        
    }
    else if(digit>=0 && digit<=9 && totalDecimals<=9)   //若点击了数字键
    {
        [self processDigit:digit];
        totalDecimals++;
        isEqualClick = NO;
        [cButton setTitle:@"C" forState:UIControlStateNormal];
        
        
    }else if(digit==10)  // 点击了"c"键
    {
        if ([cButton.currentTitle isEqualToString:@"C"]) {
            
            [cButton setTitle:@"AC" forState:UIControlStateNormal];
            showLabel.text = @"0";
            currentNumber = 0;
            isdecimal=NO;
            decimals = 0;
            totalDecimals = 0;
            
            
        } else {
            [self clear];
        }
        
        isEqualClick = NO;
    }
    else if(digit>=11 && digit<=17)  // 点击了功能键
    {
        [self processOp:digit];
        
    } else if(digit==-1)   //额外补充的 , 点击运算符号和等号进来
    {
        isdecimal=YES;
        decimals = 0;
        
        if (realPreTag == 13 || realPreTag == 14 || realPreTag == 15 || realPreTag == 16 || realPreTag == 17)
        {
            [self displayString:@"0." withMethod:@"cover"];
            
        }
        isEqualClick = NO;
        [cButton setTitle:@"C" forState:UIControlStateNormal];
        
    }
    
    realPreTag = digit;
}

// 点击了数字键
-(void)processDigit:(int)digit
{
    
    BOOL cover = NO;
    if (realPreTag == 13 || realPreTag == 14 || realPreTag == 15 || realPreTag == 16) {
        cover = YES;
        isdecimal=NO;
        totalDecimals=0;
        decimals=0;
    }
    
    
    
    if (isEqualClick) {
        currentNumber = 0;
        formulaLabel.text = @"";
        isdecimal=NO;
        decimals = 0;
    }
    
    if((currentNumber==0 && isdecimal==NO) || cover || isEqualClick)
        [self displayString:[NSString stringWithFormat:@"%i",digit] withMethod:@"cover"];
    else
        [self displayString:[NSString stringWithFormat:@"%i",digit] withMethod:@"add"];
    
    if(isdecimal==NO)
        if(currentNumber>=0)
            currentNumber=currentNumber*10+digit;
        else
            currentNumber=currentNumber*10-digit;
        else
        {
            decimals++;
            if(currentNumber>=0)
                currentNumber=currentNumber+digit*pow(10, (-1)*decimals);
            else
                currentNumber=currentNumber-digit*pow(10, (-1)*decimals);
        }
    NSLog(@"%.18Lf",currentNumber);
    
}

-(void)processOp:(int)theOp
{
    switch (theOp) {
        case 11:    //  删除键
            
        {
            if (showLabel.text.length <1) {
                return;
            }
            NSMutableString *positive=[NSMutableString stringWithString:showLabel.text];
            [positive deleteCharactersInRange:NSMakeRange(positive.length-1,1)];
            if (!positive || !positive.length) {
                positive = [NSMutableString stringWithString:@"0"];
            }
            [self displayString:positive withMethod:@"cover"];
            
            totalDecimals = positive.length;
            
            NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:positive];
            
            currentNumber = [num1 doubleValue];
            //            currentNumber=-currentNumber;
            isEqualClick = NO;
        }
            break;
        case 12:    //按下“％”
            currentNumber=currentNumber*0.01;
            [self displayString:[NSString stringWithFormat:@"%Lg",currentNumber] withMethod:@"cover"];
            totalDecimals=(int)showLabel.text.length-1;
            decimals=(int)showLabel.text.length-(int)[showLabel.text rangeOfString:@"."].location-1;
            if([showLabel.text rangeOfString:@"."].length>0)
                isdecimal=YES;
            isEqualClick = NO;
            
            break;
        case 13:    //按下“÷”
        case 14:    //按下“×”
        case 15:    //按下“-”
        case 16:    //按下“+”
        {
            // 如果上一个是+-X/, 就保存了后返回;
            if (realPreTag == 13 || realPreTag == 14 || realPreTag == 15 || realPreTag == 16) {
                op = theOp;
                // 设置公式----------
                NSString *O1Str = [NSString stringWithFormat:@"%Lf",  calMethod.operand1];
                NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:O1Str];
                NSString *strD1  = [num1 stringValue];
                
                if (op == 13) {  // / * - +
                    formulaLabel.text = [NSString stringWithFormat:@"%@÷",strD1];
                } else  if (op == 14) {  // / * - +
                    formulaLabel.text = [NSString stringWithFormat:@"%@x",strD1];
                } else  if (op == 15) {  // / * - +
                    formulaLabel.text = [NSString stringWithFormat:@"%@-",strD1];
                } else  if (op == 16) {  // / * - +
                    formulaLabel.text = [NSString stringWithFormat:@"%@+",strD1];
                }
                //----------------
                break;
            }
            
            
            totalDecimals=0;
            if(op==0)
            {
                op=theOp;
                calMethod.operand1=currentNumber;
                currentNumber=0;
                
                
                // 设置公式----------
                NSString *O1Str = [NSString stringWithFormat:@"%Lf",  calMethod.operand1];
                NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:O1Str];
                NSString *strD1  = [num1 stringValue];
                
                if (op == 13) {  // / * - +
                    formulaLabel.text = [NSString stringWithFormat:@"%@÷",strD1];
                } else  if (op == 14) {  // / * - +
                    formulaLabel.text = [NSString stringWithFormat:@"%@x",strD1];
                } else  if (op == 15) {  // / * - +
                    formulaLabel.text = [NSString stringWithFormat:@"%@-",strD1];
                } else  if (op == 16) {  // / * - +
                    formulaLabel.text = [NSString stringWithFormat:@"%@+",strD1];
                }
                //----------------
                
                
                
            }else
            {
                calMethod.operand2=currentNumber;
                currentNumber=[calMethod performOperation:op];
                [self displayString:[NSString stringWithFormat:@"%Lg",currentNumber] withMethod:@"cover"];
                
                // 设置公式----------
                NSString *O1Str = [NSString stringWithFormat:@"%Lf",  calMethod.operand1];
                NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:O1Str];
                NSString *strD1  = [num1 stringValue];
                
                NSString *O2Str = [NSString stringWithFormat:@"%Lf",  calMethod.operand2];
                NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:O2Str];
                NSString *strD2  = [num2 stringValue];
                
                if (op == 13) {  // / * - +
                    formulaLabel.text = [NSString stringWithFormat:@"%@÷%@=",strD1,strD2];
                } else  if (op == 14) {  // / * - +
                    formulaLabel.text = [NSString stringWithFormat:@"%@x%@=",strD1,strD2];
                } else  if (op == 15) {  // / * - +
                    formulaLabel.text = [NSString stringWithFormat:@"%@-%@=",strD1,strD2];
                } else  if (op == 16) {  // / * - +
                    formulaLabel.text = [NSString stringWithFormat:@"%@+%@=",strD1,strD2];
                }
                //----------------
                
                calMethod.operand1=calMethod.result;
                currentNumber=0;
                op=theOp;
            }
            isEqualClick = NO;
        }
            break;
        case 17:    //按下“=”
            
        {
            totalDecimals=0;
            calMethod.operand2=currentNumber;
            currentNumber=[calMethod performOperation:op];
            //            [self displayString:[NSString stringWithFormat:@"%Lg",currentNumber] withMethod:@"cover"];
            
            NSString *result = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:currentNumber]];
            NSArray *arr = [result componentsSeparatedByString:@"."];
            
            NSString *temp;
            NSString *tempFirst;
            if (arr.count == 2) {
                temp = arr.lastObject;
                tempFirst = arr.firstObject;
                
                if (tempFirst.length >= 9) {
                    
                    result = [NSString stringWithFormat:@"%.0Lf",currentNumber];
                    
                } else if (temp.length > (9-tempFirst.length)) {
                    
                    NSInteger count = (9-tempFirst.length);
                    
                    switch (count) {
                        case 8:
                            result = [NSString stringWithFormat:@"%.8Lf",currentNumber];
                            
                            break;
                        case 7:
                            result = [NSString stringWithFormat:@"%.7Lf",currentNumber];
                            
                            break;
                        case 6:
                            result = [NSString stringWithFormat:@"%.6Lf",currentNumber];
                            
                            break;
                        case 5:
                            result = [NSString stringWithFormat:@"%.5Lf",currentNumber];
                            
                            break;
                        case 4:
                            result = [NSString stringWithFormat:@"%.4Lf",currentNumber];
                            
                            break;
                        case 3:
                            result = [NSString stringWithFormat:@"%.3Lf",currentNumber];
                            
                            break;
                        case 2:
                            result = [NSString stringWithFormat:@"%.2Lf",currentNumber];
                            
                            break;
                        case 1:
                            result = [NSString stringWithFormat:@"%.1Lf",currentNumber];
                            
                            break;
                        default:
                            result = [NSString stringWithFormat:@"%.0Lf",currentNumber];
                            
                            break;
                    }
                    
                }
                
                
            }
            
            
            NSDecimalNumber *numResult = [NSDecimalNumber decimalNumberWithString:result];
            NSString *resultReal  = [numResult stringValue];
            if (resultReal.length>10) {
                resultReal  = [NSString stringWithFormat:@"%.4e", [result floatValue]];
            }
            [self displayString:resultReal withMethod:@"cover"];
            
            
            // 设置公式-----------
            NSString *O1Str = [NSString stringWithFormat:@"%Lf",  calMethod.operand1];
            NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:O1Str];
            NSString *strD1  = [num1 stringValue];
            
            NSString *O2Str = [NSString stringWithFormat:@"%Lf",  calMethod.operand2];
            NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:O2Str];
            NSString *strD2  = [num2 stringValue];
            
            if (op == 13) {  // / * - +
                formulaLabel.text = [NSString stringWithFormat:@"%@÷%@=",strD1,strD2];
            } else  if (op == 14) {  // / * - +
                formulaLabel.text = [NSString stringWithFormat:@"%@x%@=",strD1,strD2];
            } else  if (op == 15) {  // / * - +
                formulaLabel.text = [NSString stringWithFormat:@"%@-%@=",strD1,strD2];
            } else  if (op == 16) {  // / * - +
                formulaLabel.text = [NSString stringWithFormat:@"%@+%@=",strD1,strD2];
            }
            // -----------------
            
            calMethod.operand1=calMethod.result;
            op=0;
            
            isEqualClick = YES;
        }
            break;
            
        default:
            isEqualClick = NO;
            break;
    }
    //NSLog(@"%.18Lf",currentNumber);
}

-(void)clear
{
    op=0;
    currentNumber=0;
    totalDecimals=0;
    isdecimal=NO;
    decimals=0;
    calMethod.result = 0;
    calMethod.operand1 = 0;
    calMethod.operand2 = 0;
    formulaLabel.text = @"";
    
    [self displayString:@"0" withMethod:@"cover"];
}

-(void)displayString:(NSString *)str withMethod:(NSString *)method
{
    if (!showLabel.text) {
        showLabel.text = @"0";
    }
    NSMutableString *displayString=[NSMutableString stringWithString:showLabel.text];
    if([method isEqualToString:@"cover"])   //覆盖
        displayString=[NSMutableString stringWithString:str];
    else if([method isEqualToString:@"add"])    //追加
        [displayString appendString:str];
    else
        NSLog(@"Error: 不存在此方法！");
    showLabel.text=displayString;
}

- (void)dealloc
{
    //    YGCFunc;
}

@end

