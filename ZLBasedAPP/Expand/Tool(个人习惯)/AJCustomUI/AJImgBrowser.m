//
//  AJImgBrowser.m
//  SP2P_7
//
//  Created by eims on 16/11/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJImgBrowser.h"
#import "MyTools.h"
//#import "UIImageView+WebCache.h"
#import "AJExtension.h"

@interface AJImgBrowser ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollV;
@property (nonatomic, weak) UIButton *closeBtn;
@property (nonatomic, weak) UILabel *indexLabel;
@end

@implementation AJImgBrowser
{
    UIView *_originalView;
}

- (void)lookSingleImg:(NSString *)name
{
    if (!name.length)return;
    self.indexLabel.hidden = YES;
    UIScrollView *scrollV = [UIScrollView scrollViewWithFrame:RECT(0, 0, MSWIDTH, MSHIGHT) delegate:self backgroundColor:[UIColor blackColor] superview:self];
    [self.scrollV addSubview:scrollV];
    scrollV.minimumZoomScale = .5;
    scrollV.maximumZoomScale = 2.f;
    scrollV.tag = 999;

     UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.scrollV.bounds];
    imgV.tag = 999;
    [scrollV addSubview:imgV];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    if ([name rangeOfString:@"http"].location != NSNotFound) {
        
//        [imgV sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:kDefalutImage];
    }else{
        
        imgV.image = [UIImage imageNamed:name];
    }
    [self bringSubviewToFront:self.closeBtn];
}

- (void)setImageUrls:(NSArray *)imgurls
{
    self.indexLabel.hidden = NO;
    // 算出scrollV里面的图片个数，不够则继续创建
//    if (self.scrollV.subviews.count>0) {
    if (![imgurls isKindOfClass:[NSArray class]]) return;
    for (NSString *imgpath in imgurls) {
        
        NSInteger index = [imgurls indexOfObject:imgpath];
        if (index >= self.scrollV.subviews.count) {
            
            UIScrollView *scrollV = [UIScrollView scrollViewWithFrame:RECT(index*MSWIDTH+2, 0, MSWIDTH-4, MSHIGHT) delegate:self backgroundColor:[UIColor blackColor] superview:self];
            [self.scrollV addSubview:scrollV];
            scrollV.minimumZoomScale = .5;
            scrollV.maximumZoomScale = 2.f;
            scrollV.tag = index+999;
//                scrollV.contentSize = 
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:scrollV.bounds];
            imgV.tag = 1999;
            imgV.contentMode = UIViewContentModeScaleAspectFit;
            [scrollV addSubview:imgV];
//            [imgV sd_setImageWithURL:[NSURL URLWithString:imgpath.imgPath] placeholderImage:kDefalutImage];
        }else{
            UIScrollView *scrollV = [self.scrollV viewWithTag:index+999];
            UIImageView *imgV = [scrollV viewWithTag:999];
            imgV.image = nil;
//            [imgV sd_setImageWithURL:[NSURL URLWithString:imgpath.imgPath] placeholderImage:kDefalutImage];
        }
        
    }

//    }else{ // 之前没有
//        
//        for (NSString *imgpath in imgurls) {
//            
//            NSInteger index = [imgurls indexOfObject:imgpath];
//                
//            UIImageView *imgV = [[UIImageView alloc] initWithFrame:RECT(index*MSWIDTH, 0, MSWIDTH, MSHIGHT)];
//            imgV.tag = index;
//            imgV.contentMode = UIViewContentModeScaleAspectFit;
//            [self.scrollV addSubview:imgV];
//            [imgV sd_setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:KDefaultImage];
//        }
//    }
    self.scrollV.contentSize = CGSizeMake(MSWIDTH*imgurls.count, MSHIGHT);
    self.indexLabel.text = [NSString stringWithFormat:@"1/%d", (int)imgurls.count];
    [self bringSubviewToFront:self.indexLabel];
    [self bringSubviewToFront:self.closeBtn];
}

#pragma  mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollV) {
        
        CGFloat index = (scrollView.contentOffset.x+scrollView.bounds.size.width)/scrollView.bounds.size.width;
        int indexInt = (int)index;
        self.indexLabel.text = [NSString stringWithFormat:@"%.0f/%d", index, (int)scrollView.subviews.count];
        UIScrollView *subScrollV = [scrollView viewWithTag:indexInt+999-1];
        [UIView animateWithDuration:0.1 animations:^{
            
        }];
        subScrollV.zoomScale = 1.0f;

    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView != self.scrollV) {
        UIImageView *imgV = [scrollView viewWithTag:1999];
        return imgV;
    }
    return nil;
}

#pragma  mark - 弹出自身
- (void)showWithBeginView:(UIView *)view
{
    _originalView = view;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
//    CGRect rect=[view convertRect:view.frame toView:window];
//    self.frame = (CGRect){(CGPoint){view.frame.origin.x, rect.origin.y}, CGSizeZero};
//    self.frame = RECT(MSWIDTH/2, MSHIGHT/2, 0, 0);
//    self.center = window.center;
//    self.bounds = RECT(0, 0, 0, 0);
    [window addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.f;
//        self.bounds = RECT(0, 0, MSWIDTH, MSHIGHT);
    }];
}

#pragma  mark - 退下自身
- (void)closeSelf:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
//        self.center = window.center;
//        self.bounds = RECT(0, 0, 0, 0);
        self.alpha = 0.0;
//        self.frame = RECT(MSWIDTH/2, MSHIGHT/2, 0, 0);
//        self.frame = (CGRect){(CGPoint){_originalView.frame.origin.x, rect.origin.y}, CGSizeZero};
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = RECT(0, 0, MSWIDTH, MSHIGHT);
    self = [super initWithFrame:frame];

    if (self) {
        
        UIScrollView *scrollV = [UIScrollView scrollViewWithFrame:frame delegate:self backgroundColor:[UIColor blackColor] superview:self];
        self.scrollV = scrollV;
        self.scrollV.pagingEnabled = YES;
        
        UIButton *closeBtn = [UIButton buttonWithFrame:RECT(MSWIDTH-64, 20, 44, 44) backgroundColor:nil title:nil titleColor:nil titleFont:0 target:self action:@selector(closeSelf:) superview:self];
        [closeBtn setImage:[UIImage imageNamed:@"close_btn_icon"] forState:UIControlStateNormal];
        self.closeBtn = closeBtn;
        
        UILabel *indexLabel = [UILabel labelWithFrame:RECT(0, 20, MSWIDTH, 44) text:nil textFont:15 backColor:nil superview:self];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.textColor = [UIColor whiteColor];
        self.indexLabel = indexLabel;
    }
    return self;
}

@end
