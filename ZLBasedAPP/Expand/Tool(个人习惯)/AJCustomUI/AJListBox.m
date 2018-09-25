//
//  AJListBox.m
//  SP2P
//
//  Created by Ajax on 16/3/5.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJListBox.h"
#import "UIColor+custom.h"

@implementation AJListBox
{
    CGFloat _tableY;
    CGFloat _tableX;
}

- (void)__show {
    [self setNeedsLayout];
    viewControl.alpha = 0.0f;
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    
    [mainWindow addSubview:viewControl];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         viewControl.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {}];
}

- (void)__hide {
    [UIView animateWithDuration:0.2f
                     animations:^{
                         viewControl.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [viewControl removeFromSuperview];
                         
                         if ([self.delegate respondsToSelector:@selector(listBoxDidHidden:)]) {
                             
                             [self.delegate listBoxDidHidden:self];
                         }
                     }];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button = button;
        [button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//                [button setTitle:@"请选择银行" forState:UIControlStateNormal];
        //        UIImage *bg =  [UIImage imageNamed:@"combo_bg"];
        //        CGFloat top = 4; // 顶端盖高度
        //        CGFloat bottom =  4; // 底端盖高度
        //        CGFloat left = 10; // 左端盖宽度
        //        CGFloat right = 1; // 右端盖宽度
        //        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        //        bg = [bg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        //        [button setBackgroundImage:bg forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.backgroundColor = [UIColor whiteColor];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        button.backgroundColor = UIColor.ys_red;
        //        button.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        [self addSubview:button];
        
        viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [viewControl setBackgroundColor:[UIColor clearColor]];
        [viewControl addTarget:self action:@selector(__hide) forControlEvents:UIControlEventTouchDown];
        
        
        UITableView *tabV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tabV.dataSource = self;
        tabV.delegate = self;
        CALayer *layer = tabV.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 3.0f;
        layer.borderWidth = 0.5f;
        [layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [viewControl addSubview:tabV];
        self.table = tabV;
//        tabV.backgroundColor = [UIColor blueColor];
        
        self.rowHeight = 30.f;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    [self.button setEnabled:enabled];
}

- (void)setArrayData:(NSArray *)arrayData
{
    _arrayData = arrayData;
    
    [self setNeedsLayout];
    [self.table reloadData];
}

- (void) buttonPressed
{
    [self __show];
    if([self.delegate respondsToSelector:@selector(didClickAjComboBox:)]){
        [self.delegate didClickAjComboBox:self];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat selfH = self.bounds.size.height;
    _tableY = self.frame.origin.y + selfH;
    _tableX = self.frame.origin.x;
    [self superViewX:self];
    [self superViewY:self];
    CGFloat height = [self.arrayData count]*self.rowHeight;
    height = height>5*self.rowHeight ? 5*self.rowHeight:height;
    
    // 如果y值 + height >  screenHeight,则选择框在出现在上面
    if ((_tableY + height) > [UIScreen mainScreen].bounds.size.height) {
        
        _tableY -= selfH + height;
    }
    
    self.table.frame = CGRectMake(_tableX, _tableY, self.bounds.size.width, height);
}

- (void)superViewY:(UIView*)subView
{
    UIView *superview = subView.superview;
    if (superview) {
        
        if ([superview isKindOfClass:[UIScrollView class]]) {
            _tableY += [(UIScrollView *)superview contentInset].top;
            _tableY -= [(UIScrollView *)superview contentOffset].y;
        }
        _tableY += superview.frame.origin.y;
        [self superViewY:superview];
        
        
    }
}
- (void)superViewX:(UIView*)subView
{
    if (subView.superview) {
        
        _tableX += subView.superview.frame.origin.x;
        [self superViewX:subView.superview];
        
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return [self.arrayData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseIdentifier = @"AJListBoxCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell.textLabel setFont:self.button.titleLabel.font];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    cell.textLabel.text = self.arrayData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = [indexPath row];
    [self __hide];
  
}
// 代码设置选择第几个
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
//    [self.button setTitle:self.arrayData[selectedIndex] forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(didChangeComboBoxValue:selectedIndex:)]) {
        
            [self.delegate didChangeComboBoxValue:self selectedIndex:selectedIndex];
    }
}
@end
