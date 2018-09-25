//
//  YGCTradeWindow.m
//  DaGangCheng
//
//  Created by zhoubaitong on 16/3/9.
//  Copyright © 2016年 zhoubaitong. All rights reserved.
//

#import "YGCTradeWindow.h"
#import "UIView+YGCExtension.h"


// 屏幕尺寸
#define YGCScreenH [UIScreen mainScreen].bounds.size.height
#define YGCScreenW [UIScreen mainScreen].bounds.size.width

@interface YGCTradeWindow ()

/** 要显示的控制器 */
@property (nonatomic, weak) UIViewController *tradeVC;

///** 导航控制器 */
//@property (nonatomic, strong) UINavigationController *nav;


@property (nonatomic, assign) CGPoint startPoint; ///< <#name#>

@property(nonatomic, assign, getter=isShow) BOOL show; ///< 是否正在显示

//@property(nonatomic, assign) NSInteger beginCount; ///< <#name#>

@end


//static const CGFloat bgViewAlpha = 0.6;
static const CGFloat windowAlpha = 1.0;

static const CGFloat windowWidth = 220;
static const CGFloat windowHeight = 383;



@implementation YGCTradeWindow

// 首先保存keyWindow
+ (void)load
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self shareWindow];
    });
}

//单例
+ (instancetype)shareWindow
{
    static dispatch_once_t onceToken;
    static YGCTradeWindow *tradeWindow;
    dispatch_once(&onceToken, ^{
        tradeWindow = [[self alloc] init];
    });
    return tradeWindow;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self];
    self.startPoint = point;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if (self.width == YGCScreenW) {  // 全屏就不给移动 
        return;
    }
    
    
    //计算位移=当前位置-起始位置
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - self.startPoint.x;
    float dy = point.y - self.startPoint.y;
    
    //计算移动后的view中心点
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    /*
    // 限制用户不可将视图托出屏幕
    float halfx = CGRectGetMidX(self.bounds);
    
    //x坐标左边界
    newcenter.x = MAX(halfx, newcenter.x);
    //x坐标右边界
    newcenter.x = MIN(YGCScreenW - halfx, newcenter.x);
    
    //y坐标同理
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(YGCScreenH - halfy, newcenter.y);
    */
    
    // 限制用户不可将视图托出屏幕
    
    //x坐标左边界
    newcenter.x = MAX(-(self.width*0.5)+35, newcenter.x);
    //x坐标右边界
    newcenter.x = MIN(YGCScreenW + self.width*0.5-35, newcenter.x);
    
    //y坐标同理
    newcenter.y = MAX(-(self.height*0.5)+35, newcenter.y);
    newcenter.y = MIN(YGCScreenH + self.height*0.5-35, newcenter.y);
    
    //移动view
    self.center = newcenter;
    
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake((YGCScreenW - windowWidth)*0.5, (YGCScreenH - windowHeight)*0.5, windowWidth, windowHeight);
        self.alpha = 1;
        [self setBackgroundColor:[UIColor clearColor]];
//        self.windowLevel = UIWindowLevelAlert - 1;
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.keyWD = [UIApplication sharedApplication].keyWindow;
        
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGes:)];
        longGes.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longGes];
        
        // 监听键盘, 保证在最前面
        [self setUpNotifile];
        
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpNotifile
{
    //键盘相关
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowing:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHided:) name:UIKeyboardWillHideNotification object:nil];
    
//    // 监听后台前台变化
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActiveNotification) name:
//         UIApplicationDidBecomeActiveNotification object:nil];
}

//- (void)becomeActiveNotification  // 无用
//{
//    self.windowLevel = MAXFLOAT;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.windowLevel = MAXFLOAT;
//
//    });
//
//}

- (void)keyboardWillShowing:(NSNotification*)aNotification
{
    self.windowLevel = MAXFLOAT;
}

- (void)keyboardWillHided:(NSNotification*)aNotification
{
    self.windowLevel = UIWindowLevelStatusBar + 1;
}



- (void)longGes:(id)sender
{
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (press.state == UIGestureRecognizerStateBegan) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.center = CGPointMake(YGCScreenW*0.5,YGCScreenH*0.5);
        }];

    }
}


// 显示
+ (void)showWithVc:(UIViewController *)showVc
{
    [[self shareWindow] showWithVc:showVc];
}

- (void)showWithVc:(UIViewController *)showVc
{
    
    if (self.isShow) { // 如果已经显示, 就返回
        if (self.keyWD == nil) {
            self.keyWD = [UIApplication sharedApplication].keyWindow;
            self.show = NO;
        }
        return;
    }
    
    if (!showVc) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请设置要显示的控制器" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [av show];
        return;
    }
    
    self.show = YES;
    self.tradeVC = showVc;
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGCScreenW, YGCScreenH)];
//    self.bgView = bgView;
//    bgView.backgroundColor = YGCRGBAColor255(0, 0, 0, bgViewAlpha * 255.0);
    
//    self.bgView.alpha = 0.0;
    self.alpha = 0.0;
    [self showAnimate];
    
    NSLog(@"\nkeyWindow = %@\n", self.keyWD);
    if (!self.keyWD) return;
    
//    [self.keyWD addSubview:bgView];
    
    self.hidden = NO;
    
    self.tradeVC.hidesBottomBarWhenPushed = YES;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.tradeVC];
//    self.nav = nav;
//    self.tradeVC.navigationController.navigationBarHidden = YES;
//    [nav setNavigationBarHidden:YES animated:NO];
    
    self.rootViewController = self.tradeVC;
    self.rootViewController.view.frame = CGRectMake(0, 0, windowWidth, windowHeight);
    
}

+ (BOOL)isShow
{
    return [YGCTradeWindow shareWindow].show;
}
// 隐藏
+ (void)hide
{
    [[self shareWindow] hide];
}
- (void)hide
{
    self.show = NO;
    [self hideAnimate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.tradeVC removeFromParentViewController];
        self.rootViewController= nil;
        self.tradeVC = nil;

        self.hidden = YES;
    });
}

- (UIWindow *)getKeyWindow
{
    if (self.keyWD) {
        return self.keyWD;
    }
    return [UIApplication sharedApplication].keyWindow;
}

+ (CGFloat)getWindowHeight
{
    return 275;
}

/** 不释放控制器隐藏 */
- (void)hideNoDellocVc
{
//    self.bgView.alpha = bgViewAlpha;
    self.alpha = windowAlpha;
    
    [self hideAnimate];
    
}
/** 不释放控制器显示 */
- (void)showNoDellocVc
{
    [self showAnimate];
}

- (void)showNoDellocVcNoAnima
{
//    self.bgView.alpha = bgViewAlpha;
    self.alpha = windowAlpha;
    
}

// 全屏modal
- (void)presentFullScreenWithVc:(UIViewController *)vc
{
    [self.keyWD.rootViewController presentViewController:vc animated:YES completion:nil];
}

// 显示view的动画
- (void)showAnimate
{
    [UIView animateWithDuration:0.1 animations:^{
//        self.bgView.alpha = bgViewAlpha;
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = windowAlpha;
    }];
}
// 隐藏view的动画
- (void)hideAnimate
{
    [UIView animateWithDuration:0.25 animations:^{
//        self.bgView.alpha = 0.0;
        self.alpha = 0.0;
    }];
    
}


@end
