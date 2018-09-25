//
//  NoDataView.m
//  微金在线
//
//  Created by 首控微金财富 on 2017/5/25.
//  Copyright © 2017年 zhouli. All rights reserved.
//

#import "NoDataView.h"
#import "AJExtension.h"

@interface NoDataView ()
@property (nonatomic, weak) UIImageView *imgV;
@property (nonatomic, weak) UILabel *lable1;
@property (nonatomic, weak) UILabel *lable2;
@property (nonatomic, weak) UIButton *reloadBtn;
@end

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame
{    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = AJGrayBackgroundColor;
      
        UIImage *img = [UIImage imageNamed:@"Request_Error"];
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = img;
        [self addSubview:imgV];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        self.imgV = imgV;
        self.imgV.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        UILabel *lable = [UILabel labelWithFrame:CGRectZero text:@"网络出问题了~" textFont:14 backColor:nil superview:self];
        self.lable1 = lable;
        
        lable = [UILabel labelWithFrame:CGRectZero text:@"网络或服务器出问题，刷新试试吧~" textFont:14 backColor:nil superview:self];
        self.lable2 = lable;
        
        UIButton *reloadBtn = [AJCornerCircle buttonWithFrame:CGRectZero backgroundColor:AJWhiteColor title:@"点击刷新" titleColor:UIColor.ys_black titleFont:15 target:self action:@selector(reloadDatas:) superview:self];
        self.reloadBtn = reloadBtn;
        reloadBtn.layer.borderColor = RGB(165,165,165).CGColor;
        reloadBtn.layer.borderWidth = .8f;
    }
    return self;
}

- (void)setDelegate:(id<NoDataViewDelegate>)delegate
{
    _delegate = delegate;
    
    if ([self.delegate respondsToSelector:@selector(noDataViewFrame:)]) {
        
        CGRect frame = [self.delegate noDataViewFrame:self];
        self.frame = frame;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImage *img = self.imgV.image;
    CGFloat imgW = img.size.width;
    CGFloat imgH = img.size.height;
    CGFloat imgVY = 134.f * (self.height/MSHIGHT) - self.y;
    if (self.delegate ) {// 检测代理控制器是否嵌套在别的控制器里面，如果嵌套则向上缩进50以适配4S上刷新按钮显示不出来
        UIViewController *vc = (UIViewController *)self.delegate;
        UIViewController *parentVC = vc.parentViewController;
        if (![parentVC isKindOfClass:[UINavigationController class]] && ![parentVC isKindOfClass:[UITabBarController class]]) {
            imgVY -= 50;
        }
        
    }
    self.imgV.frame = RECT((self.width - imgW)/2, imgVY, imgW, imgH);
    self.lable1.frame = RECT(30, self.imgV.maxY+23, self.width-60, 14);
    self.lable2.frame = RECT(10, self.lable1.maxY+10, self.width-20, 12);
    
    CGFloat btnW = 113.f;
    CGFloat btnH = 36.f;
    self.reloadBtn.frame = RECT((self.width - btnW)/2, self.lable2.maxY + 25, btnW, btnH);
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<NoDataViewDelegate>)delegate
{
    NoDataView *view = [self initWithFrame:frame];
    view.delegate = delegate;
    return view;
}

- (void)reloadDatas:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(noDataViewDidClickView:)]) {
        
        [self.delegate noDataViewDidClickView:self];
    }
}
@end
