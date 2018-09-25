//
//  HomeHeader.m
//  微金在线
//
//  Created by 首控微金财富 on 2017/5/17.
//  Copyright © 2017年 zhouli. All rights reserved.
//

#import "HomeHeader.h"
#import "AJCustomUI.h"
#import "SDCycleScrollView.h"

@interface HomeHeader ()<SDCycleScrollViewDelegate>

@property (nonatomic, weak) SDCycleScrollView *adScrollView;

@end

@implementation HomeHeader
{
    int _countInt;
}


- (instancetype)initWithFixedHeght
{
//    CGFloat cycleH = (205/375.f)*MSWIDTH;
    CGFloat cycleH = (496/1000.f)*MSWIDTH;
//    CGFloat newsH = 40.f;
//    CGFloat toolBarH = 105.f;
//    CGFloat grayviewH = 9.f;

    CGRect frame = CGRectMake(0, 0, 0, cycleH);
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        // 顶部广告业
        SDCycleScrollView *adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MSWIDTH, cycleH) delegate:self placeholderImage:[UIImage imageNamed:@"Banner_Bitmap"]];
        adScrollView.currentPageDotImage = [UIImage imageNamed:@"Dot_current"];
        adScrollView.pageDotImage = [UIImage imageNamed:@"Dot_normal"];;
        adScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        adScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        adScrollView.backgroundColor = AJGrayBackgroundColor;
        adScrollView.autoScrollTimeInterval = 5.0;//轮播时间为5s
        adScrollView.showPageControl = YES; //隐藏分页控件,有需要可打开
        adScrollView.contentMode =  UIViewContentModeScaleAspectFill;
        self.adScrollView = adScrollView;
        adScrollView.delegate =self;
        [self addSubview:adScrollView];
    

    }
    return self;
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup
{
    _imageURLStringsGroup = imageURLStringsGroup;
    
//    NSMutableArray *imgUrls = [NSMutableArray array];
//    for (HomeAds *bean in imageURLStringsGroup) {
//
//        [imgUrls addObject:bean.img.imgPath];
//    }
    self.adScrollView.imageURLStringsGroup = imageURLStringsGroup;
}


#pragma mark - FocusImageFrameDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (!self.imageURLStringsGroup) return;
    if (self.tapImgBlock) self.tapImgBlock(self.imageURLStringsGroup[index]);
}

@end
