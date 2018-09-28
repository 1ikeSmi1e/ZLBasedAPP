//
//  MyTools.m
//

#import "MyTools.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
//#import "ConverUtil.h"

#define DESkey  @"6rizGiKIQPiwExSQ"// 加密 key
@implementation MyTools

singletonM(Tools)


/**
 打开APP的系统设置页面
 */
+ (void)openSystemSetting{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (void)tenderbtn:(UIButton *)tenderBtn updateWithBidStatus:(int)bid_status
{
    NSString *btnTitle = nil;
    switch (bid_status) {
        case 0:// 投资记录进来的，没有标的的信息
        {
            btnTitle = @"--";
        }
            break;
        case 2:// 借款中
        {
            btnTitle = @"立即投资";
        }
            break;
        case 3:// 流标
        {
            btnTitle = @"流标";
        }
            break;
        case 4:// 标满，放款复审中
        {
            btnTitle = @"复审中";
        }
            break;
        case 5:// 放款复审未通过
        {
            btnTitle = @"复审未通过";
        }
            break;
        case 6:// 放款复审通过，还款中
        {
            btnTitle = @"还款中";
        }
            break;
        default:// 已完成 （ 7=已完成；8= 已逾期；9=合作方代偿）
        {
            btnTitle = @"已完成";
        }
            break;
    }
    [tenderBtn setTitle:btnTitle forState:UIControlStateNormal];
}

+ (void)gotoFinanceVCFromController:(UIViewController *)currentVC
{
    UITabBarController *tabVC = currentVC.tabBarController;
    if (tabVC.selectedIndex == 1) {
        
        [currentVC.navigationController popToRootViewControllerAnimated:YES];
    }else{
        
        tabVC.selectedIndex = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [currentVC.navigationController popToRootViewControllerAnimated:YES];
        });
    }
}

//当前时间 是否在这个时间内
+(BOOL)isInTimeFromString:(NSString*)formString addMonth:(NSInteger) addMonths  day:(NSInteger) days {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *formDate = [formatter dateFromString:formString];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];//需要的格式
    //    NSDate *newDate = [NSDate setYear:year month:month day:day hour:formDate.hour minute:formDate.minute];
    NSString *defaultShow = [formatter stringFromDate:formDate];
    
    NSString *currTime = [formatter stringFromDate:[NSDate date]];
    
    NSInteger delay = [NSDate deltaDays:defaultShow endDate:currTime];
    NSLog(@"currTime = %@, 过去天数：%ld",currTime, delay);
    return delay <= days;
}

#if (istest==1)
+ (void)transformToModelByDictionary:(NSDictionary *)dict{
    
    // 根据类别拼接属性字符串代码
    NSMutableString *str = [NSMutableString string];
    // 遍历字典,把字典中的所有key取出来;生成对应的属性代码
    [dict enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key,id _Nonnull obj,BOOL * _Nonnull stop) {
        // 对各类新进行分类, 抽取出来
        NSString *type;
        // 需要 理解 系统底层 数据结构类型
        // 可以自行断点查看 各类型底层类型
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
            
            type = @"NSString";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSArrayI")]) {
            
            type = @"NSArray";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSArrayM")]) {
            
            type = @"NSMutableArray";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            
            type = @"NSNumber";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSDictionaryI")]) {
            
            type = @"NSDictionary";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSDictionaryM")]) {
            
            type = @"NSMutableDictionary";
        }else{
            type = @"CGFloat";
        }
        // 属性字符串
        NSString *property;
        if ([type containsString:@"NS"]) {
            property = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;", type, key];
        }else {
            property = [NSString stringWithFormat:@"@property (nonatomic, assign) %@ %@;", type, key];
        }
        // 每生成一对属性字符串 就自动换行
        [str appendFormat:@"\n%@\n", property];
    }];// 打印出拼接的字符串
    DLOG(@"对应属性 -> %@", str);
}
#endif

/**清除缓存和cookie*/
+ (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

+ (NSString *)filterHTML:(NSString *)html
{
    return [html filterHTML];
}
//获取图片路径
+ (NSString *)getImageUrlPath:(NSString *)path
{
    if (![path isEqual:[NSNull null]] && path != nil)
    {
        if ([path hasPrefix:@"http"]) {
            return path;
        } else{
            
            return path;
        }
    }else{
        return @"";
    }
}

// 设置可变字体
+ (void)setAttributedLabel:(UILabel *)label rangeStr:(NSString *)rangeStr color:(UIColor *)color font:(UIFont *)font
{
    if (label.text.length > 0)
    {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:label.text];
        if (color != nil) {
            [attrString addAttribute:NSForegroundColorAttributeName value:color range:[label.text rangeOfString:rangeStr]];
        }
        if (font != nil) {
            [attrString addAttribute:NSFontAttributeName value:font range:[label.text rangeOfString:rangeStr]];
        };
        label.attributedText = attrString;
    }
}
// 设置可变字体、行距，获取可变字符串
+ (NSMutableAttributedString *)getAttributedWithText:(NSString *)text rangeStr:(NSString *)rangeStr color:(UIColor *)color font:(UIFont *)font lineSpace:(CGFloat)lineSpace
{
    if (text.length > 0)
    {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
        
        if (color != nil) {
            [attrString addAttribute:NSForegroundColorAttributeName value:color range:[text rangeOfString:rangeStr]];
        }
        if (font != nil) {
            [attrString addAttribute:NSFontAttributeName value:font range:[text rangeOfString:rangeStr]];
        };
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];//调整行间距
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
        
        return attrString;
    }else{
        return nil;
    }
}

+ (void)showNetworkActivityIndicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
+ (void)hidenNetworkActitvityIndicator
{
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
// 设置可变字体
+ (void)setAttributedString:(UILabel *)label rangeStr:(NSString *)rangeStr color:(UIColor *)color font:(UIFont *)font
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:label.text];
    if (color != nil) {
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:[label.text rangeOfString:rangeStr]];
    }
    if (font != nil) {
        [attrString addAttribute:NSFontAttributeName value:font range:[label.text rangeOfString:rangeStr]];
    };
    label.attributedText = attrString;
}
// 设置字体间距
+ (void)setAttributedString:(UILabel *)label lineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    label.attributedText = attributedString;
}

+ (NSMutableAttributedString *)getNSMutableAttributedStringWithText:(NSString *)text
                                                              start:(NSInteger)textStart
                                                                end:(NSInteger)textEnd
                                                          textColor:(UIColor *)textColor
                                                           textFont:(UIFont *)textFont
{
    NSString *string = text;
    NSInteger textLong = textEnd - textStart;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:textFont?:[UIFont systemFontOfSize:12] range:NSMakeRange(textStart, textLong)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:textColor?:[UIColor blackColor] range:NSMakeRange(textStart, textLong)];
    
    return attributedString;
}

+ (NSMutableAttributedString *)getAttributedStringWithText:(NSString *)text
                                                     start:(NSInteger)textStart
                                                       end:(NSInteger)textEnd
                                                 textColor:(UIColor *)textColor
                                                  textFont:(UIFont *)textFont
{
    return [self getNSMutableAttributedStringWithText:text start:textStart end:textEnd textColor:textColor textFont:textFont];
}

+ (CGSize)getSizeOfString:(NSString *)string
                 maxWidth:(float)width
                maxHeight:(float)height
             withFontSize:(CGFloat)fontSize
{
    CGSize size =  [string boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

+ (CGSize)getTypeFaceSizeOfString:(NSString *)string
                         maxWidth:(float)width
                        maxHeight:(float)height
                         withFont:(UIFont *)font
{
    CGSize size =  [string boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return size;
}

+ (UIButton *)leftBarButton
{
    // 导航条返回按钮
    UIImage *leftImage = [UIImage imageNamed:@"nav_back"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame =  CGRectMake(0, 0, 60, 44);
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftButton setImage:leftImage forState:UIControlStateNormal];
    
    return leftButton;
}

+ (UIView *)textFieldLeftViewWithImageSize:(CGSize)imageSize
                                 imageName:(NSString *)imageName
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake((leftView.frame.size.width - 6 - imageSize.width)/2, (leftView.frame.size.height - imageSize.height)/2, imageSize.width, imageSize.height)];
    leftImage.image = [UIImage imageNamed:imageName];
    leftImage.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:leftImage];
    
    UIView *lineNameWindow = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.size.width - 6, (leftView.frame.size.height-20)/2, 1, 20)];
    lineNameWindow.backgroundColor = [UIColor lightGrayColor];
    [leftView addSubview:lineNameWindow];
    
    return leftView;
}
@end

@implementation UIStoryboard (Ajax)

+ (UIViewController *)getControllerWithStoryboardID:(NSString *)storyboardID
{
   return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardID];
}

@end
@implementation UIFont (MyTools)

+ (UIFont *)customFontWithSize:(CGFloat)size
{
//    return [UIFont systemFontOfSize:size];
//    return <#expression#>
   return [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:size];
//    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}
@end

#pragma mark ----- UILabel
@implementation UILabel (MyTools)
+ (id)labelWithFrame:(CGRect)frame
                text:(NSString *)text
           textColor:(UIColor *)textColor
            textFont:(float)textFont
            fitWidth:(BOOL)fitWidth
           superview:(id)superview {
    
    UILabel *label = [[self alloc] initWithFrame:frame];
    if (text.length > 0) {
        label.text = text;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (textFont > 0) {
        label.font = [UIFont systemFontOfSize:textFont];
    }
    if (fitWidth) {
        label.adjustsFontSizeToFitWidth = YES;
    }else {
        label.adjustsFontSizeToFitWidth = NO;
    }
    label.textAlignment = NSTextAlignmentLeft;
    if (superview) {
        [superview addSubview:label];
    }
    return label;
}
+ (id)labelWithFrame:(CGRect)frame text:(NSString *)text textFont:(float)fontSize backColor:(UIColor *)backColor superview:(id)superview{
    
    UILabel *label = [[self alloc] initWithFrame:frame];
    
    if (text.length > 0)  label.text = text;
    if (backColor) label.backgroundColor = backColor;
    label.font = [UIFont systemFontOfSize:(fontSize >0 ? fontSize: 13.0f)];
    label.adjustsFontSizeToFitWidth = NO;
    label.textAlignment = NSTextAlignmentCenter;
    if (superview) [superview addSubview:label];
    
    return label;
}

+ (id)labelWithFrame:(CGRect)frame
                text:(NSString *)text
           textColor:(UIColor *)textColor
            textFont:(float)textFont
        textAligment:(NSTextAlignment)textaligment
           superview:(id)superview{
    
    UILabel *label = [[self alloc] initWithFrame:frame];
    if (text.length > 0) {
        label.text = text;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (textFont > 0) {
        label.font = [UIFont systemFontOfSize:textFont];
    }
    if(textaligment){
        label.textAlignment = textaligment;
    }
    if (superview) {
        [superview addSubview:label];
    }
    return label;

}

@end

#pragma mark ----- UIImageView
@implementation UIImageView (MyTools)
+ (id)imageViewWithFrame:(CGRect)frame
               imageFile:(NSString *)imageFile
               superview:(id)superview {
    
    UIImageView *imageView = [[self alloc] initWithFrame:frame];
    if (imageFile.length > 0) {
        imageView.image = [UIImage imageNamed:imageFile];
    }
    [superview addSubview:imageView];
    return imageView;
    
}
@end

@implementation UIView (JDControls)
+ (instancetype)viewWithFrame:(CGRect)frame
    backgroundColor:(UIColor *)backgroundColor
          superview:(id)superview {
    
    UIView *view = [[self alloc] initWithFrame:frame];
    if (backgroundColor) {
        view.backgroundColor = backgroundColor;
    }
    [superview addSubview:view];
    return view;
}

@end

#pragma mark ----- UIButton
@implementation UIButton (MyTools)
+(id)buttonWithFrame:(CGRect)frame
     backgroundColor:(UIColor *)backgroundColor
               title:(NSString *)title
          titleColor:(UIColor *)titleColor
           titleFont:(CGFloat)titleFont
              target:(id)target
              action:(SEL)action
           superview:(id)superview {
    
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (backgroundColor) {
        [button setBackgroundColor:backgroundColor];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (titleFont > 0) {
        button.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    }
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (superview) {
        [superview addSubview:button];
    }
    return button;
}

@end

#pragma mark ----- UITextField
@implementation UITextField (MyTools)
+ (id)textFieldWithFrame:(CGRect)frame
                delegate:(id)delegate
                    text:(NSString *)text
               textColor:(UIColor *)textColor
                textFont:(float)textFont
             placeholder:(NSString *)placeholder
               superview:(id)superview {
    
    UITextField *textField = [[self alloc] initWithFrame:frame];
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
    if (textColor) {
        
        textField.textColor = textColor;
    }
    textField.returnKeyType = UIReturnKeyDone;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone; //取消自动大写
    textField.autocorrectionType = UITextAutocorrectionTypeNo;  //取消自动修正
    textField.borderStyle = UITextBorderStyleNone;  //取消边框
    [superview addSubview:textField];
    return textField;
}
@end

#pragma mark ----- UITableView
@implementation UITableView (MyTools)
+ (id)tableViewWithFrmae:(CGRect)frame
         backgroundColor:(UIColor *)backgroundColor
                delegate:(id)delegate
          tableViewStyle:(UITableViewStyle)tableViewStyle
          separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
               superview:(id)superview {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:tableViewStyle];
    if (backgroundColor) {
        tableView.backgroundColor = backgroundColor;
    }
    if (delegate) {
        tableView.delegate = delegate;
        tableView.dataSource = delegate;
    }
   
    if (separatorStyle) {
        tableView.separatorStyle = separatorStyle; //分割线样式
    }else {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    [superview addSubview:tableView];
    return tableView;
}
@end

#pragma mark ----- UIScrollView
@implementation UIScrollView (MyTools)
+ (id)scrollViewWithFrame:(CGRect)frame
                 delegate:(id)delegate
          backgroundColor:(UIColor *)backgroundColor
                superview:(id)superview {
    
    UIScrollView *scrollView = [[self alloc] initWithFrame:frame];
    if (backgroundColor) {
        scrollView.backgroundColor = backgroundColor;
    }
    if (delegate) {
        scrollView.delegate = delegate;
    }
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [superview addSubview:scrollView];
    return scrollView;
}
@end

@implementation UIBarButtonItem(MyTools)
+ (UIBarButtonItem *)leftBarButtonItemWithImage:(UIImage *)image
                                    highlighted:(UIImage *)highlightedImage
                                         target:(id)target
                                       selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)rightBarButtonItemWithImage:(UIImage *)image
                                     highlighted:(UIImage *)highlightedImage
                                          target:(id)target
                                        selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    button.adjustsImageWhenHighlighted = NO;
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)leftBarButtonItemWithTitle:(NSString *)title
                                          target:(id)target
                                        selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 40, 40);
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)rightBarButtonItemWithTitle:(NSString *)title
                                      titleColor:(UIColor *)titleColor
                                          target:(id)target
                                        selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 40, 40);
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [button setTitleColor:titleColor?:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textColor = titleColor?:[UIColor whiteColor];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


@end
@implementation UITextView (MyTools)

+ (instancetype)textViewWithFrame:(CGRect)frame textColor:(UIColor *)textColor bgColor:(UIColor *)color font:(CGFloat)fontsize superV:(UIView *)superView
{
    UITextView *textView = [self viewWithFrame:frame backgroundColor:color superview:superView];
    textView.font = [UIFont systemFontOfSize:fontsize];
    textView.textColor = textColor;
    return textView;
}

@end
@implementation UIImage (MyTools)

+ (instancetype)placeholderImg
{
    return [self imageNamed:@"news_image_default"];
}

@end
@implementation NSString (MyTools)

+ (instancetype)numberformatStrFromDouble:(CGFloat)value
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###,##0.00"];
    return [formatter stringFromNumber:[NSNumber numberWithDouble:value]];
}

+ (instancetype)strFromDouble:(CGFloat)value
{
    NSString *str = [NSString stringWithFormat:@"%.2f元", value];
    return str;
}

+ (instancetype)stringWithFormatNumberstring:(NSString *)value
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###,##0.00"];
    return [NSString stringWithFormat:@"%@", [formatter numberFromString:value]];

}

- (instancetype)appendStr:(NSString *)str
{
    if (!str)  return self;
    return [self stringByAppendingString:str];
}

/**
 * 判断字符串是否是email格式
 */
- (BOOL)isEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/**
 * 判断字符串是否是手机号码格式
 */
- (BOOL)isPhone
{
    if (self.length != 11)
    {
        return NO;
    }else{
//        /**
//         * 移动号段正则表达式
//         */
//        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//        /**
//         * 联通号段正则表达式
//         */
//        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//        /**
//         * 电信号段正则表达式
//         */
//        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSString *regular = @"^1(3|4|5|7|8)\\d{9}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
        BOOL isMatch1 = [pred1 evaluateWithObject:self];
//        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//        BOOL isMatch2 = [pred2 evaluateWithObject:self];
//        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//        BOOL isMatch3 = [pred3 evaluateWithObject:self];
        
        if (isMatch1 /*|| isMatch2 || isMatch3*/) {
            return YES;
        }else{
            return NO;
        }
    }
}

/**
 * 判断正则匹配用户身份证号15或18位
 */
- (BOOL)isCheckUserIdCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}
/**
 * 判断是否不是全中文
 */
- (BOOL) deptNameInputShouldChinese
{
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

/*
 * 给字符串md5加密
 */
- (NSString*)md5
{
    const char *ptr = [self UTF8String];
    
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

+ (NSString *)encrypt3DES:(NSString *)src
{
    NSString *key = DESkey;
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData* data = [src dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    plainTextBufferSize = [data length];
    vplainText = (const void *)[data bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySizeDES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    if (ccStatus == kCCSuccess) {
//        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//        return [ConverUtil NSDataToHexString:myData];

    }
    return @"";
    
   
}
+ (NSString *)decrypt3DES:(NSString *)src
{
     NSString *key = DESkey;
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData *EncryptData = nil;//[ConverUtil hexStrToNSData:src];
    plainTextBufferSize = [EncryptData length];
    vplainText = [EncryptData bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySizeDES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    if (ccStatus == kCCSuccess) {
        NSData *dataBuf = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        return [[NSString alloc] initWithData:dataBuf
                                     encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]
        ;
        
    }
    return @"";
   
}

+ (instancetype)strWithPeriod:(NSString *)period unit:(NSString*)periodUnit
{
    NSString *periodStr = nil;
    switch ([periodUnit intValue]) {
        case -1:
            periodStr = [period stringByAppendingString:@"年"];
            break;
        case 0:
            periodStr = [period stringByAppendingString:@"个月"];
            break;
        case 1:
            periodStr = [period stringByAppendingString:@"天"];
    }
    return periodStr;

}

- (NSComparisonResult)timeCompareNow
{
    NSString *timeStr = [self timeToSecondWithFormat2];
    //剩余时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSDate *senddate = [NSDate date];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:timeStr];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    //得到相差秒数
    NSTimeInterval time =[endDate timeIntervalSinceDate:senderDate];
    if (time>0) {
        
        return NSOrderedDescending;
    }else if (time == 0){
         return NSOrderedSame;
    }else{
         return NSOrderedAscending;
        
    }
}

- (instancetype)getRedPacketStatusStr
{
    if ([@"OVERDUE" isEqualToString:self]) {
        
        return @"已过期";
    }else if ([@"INACTIVATED" isEqualToString:self]) {
            
            return @"未激活";
    }else if ([@"UNRECEIVED" isEqualToString:self]) {
        /** 1:未领取/未使用 */
        return @"未使用";
    }else if ([@"RECEIVED" isEqualToString:self]) {
        /** 2:已领取/使用 */
        return @"已使用";
    }
    return @"未激活";
}

- (instancetype)imgPath
{
    if (self.length == 0) {
        return @"";
    }else if ([self rangeOfString:@"http"].location == NSNotFound) {
        
//        NSString *imageUrl = [[[[[GainAllocationURL shareInstance] getBaseImageUrl] stringByAppendingString:KImageURL]stringByAppendingString:[VerifyTools getSafeString:self]]stringByAppendingString:@".png"];
//        return imageUrl;
        return nil;
    }
    return self;
}

- (NSString *)ys_appendParam
{
    if (self.length == 0) {
        return self;
    }
    NSString *urlStr = self;
    if ([urlStr rangeOfString:@"client=ios"].location != NSNotFound) {// 已经添加过的
        return self;
    }
    NSRange range = [urlStr rangeOfString:@"?"];
    NSString *appendParam = (range.location==NSNotFound)?@"?":@"&";
    urlStr = [urlStr stringByAppendingString:appendParam];
    urlStr = [urlStr stringByAppendingString:@"client=ios"];
    return urlStr.imgPath;
}

- (NSString *)timeToSecondWithFormat1
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [self doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    return [dateFormatter stringFromDate:date];
}

- (NSString *)timeToMinuteWithFormat1
{
    return [[self timeToSecondWithFormat1] substringToIndex:15];
}

- (NSString *)timeToDayWithFormat1
{
   return [[self timeToSecondWithFormat1] substringToIndex:10];
}

- (NSString *)timeToMonthDayWithFormat1
{
    return [[self timeToDayWithFormat1] substringFromIndex:5];
}

- (NSString *)timeToSecondWithFormat2
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [self doubleValue]/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    return [dateFormatter stringFromDate:date];
}

- (NSString *)timeToMinuteWithFormat2
{
     return [[self timeToSecondWithFormat2] substringToIndex:15];
}

- (NSString *)timeToDayWithFormat2
{
    return [[self timeToSecondWithFormat2] substringToIndex:10];
}

- (NSString *)timeToMonthDayWithFormat2
{
     return [[self timeToDayWithFormat2] substringFromIndex:5];
}
- (NSString *)filterHTML
{
    NSString *html = [self copy];
    NSScanner * scanner = [NSScanner scannerWithString:html];
    
    NSString * text = nil;
    
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    return html;
}

@end

