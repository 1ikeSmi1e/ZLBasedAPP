//
//  UIView+AJ.h
//
#import <UIKit/UIKit.h>
//
//* 这个枚举是配合UIViewOutterDelegate使用的，自定义view面向协议<UIViewOutterDelegate>，事件向外传递需添加一个代理属性，
// 见方法可知是内部view的事件，- (void)customView:(UIView *)sectionView didClickWithType:(ClickType)type，
//  通过ClickType来判断是点击的什么事件，
// @property (nonatomic, weak) id<UIViewOutterDelegate> outterDelegate;
//
typedef NS_ENUM(NSInteger, ClickType){
    ClickType_editCategory = 1,
    ClickType_didEndeditMonthBudget = 1,   
};

@protocol UIViewOutterDelegate <NSObject>
// 自定义uiview向外部发消息的方法，UIview告知代理
//
@optional
/**区块view里面的各个按钮点击事件，代理传递 */
- (void)customView:(UIView *)sectionView didClickWithType:(ClickType)type;
@end


@protocol UIViewInnerDelegate <NSObject>
// uiview的内部实现的方法，外部可调用uiview的UIViewInnerDelegate协议方法
@optional
/** 给外界提供更新view的数据的方法声明*/
- (void)reloadDataWithObject:(id)bean;
@end


@interface UIView (AJ)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;
@property (assign, nonatomic, readonly) CGFloat maxX;
@property (assign, nonatomic, readonly) CGFloat maxY;
@property (assign, nonatomic, readonly) CGFloat minX;
@property (assign, nonatomic, readonly) CGFloat minY;


/**
  梯度背景色
 */
- (void)gradientView;
- (void)gradientViewWithFrame:(CGRect)frame;

/** 屏幕适配不成比例的UI设计稿时 根据屏幕获取值的方法*/
+ (CGFloat)getValueFromArray:(NSArray *)arr;


- (void)setCornerRadiu:(CGFloat)radius borderWidth:(CGFloat)border borderColor:(UIColor *)color;
/**
  移除梯度背景色
 */
- (void)removeGradientView;


/**
  抖动动画
 */
- (void)shakeAnimation;

- (UIViewController*)viewController;
@end


//@interface UIControl (AJ)
//@property (nonatomic, assign) NSTimeInterval custom_acceptEventInterval;// 可以用这个给重复点击加间隔
//@end

