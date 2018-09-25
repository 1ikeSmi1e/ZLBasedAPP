//
//  FHouseCounterViewController.m
//  ftool
//  房贷计算器
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FHouseCounterViewController.h"
#import "SPPageMenu.h"
#import "FHouseCounterSimpleViewController.h"
#import "FHouseCounterHybirdViewController.h"

@interface FHouseCounterViewController ()<SPPageMenuDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;

@end

@implementation FHouseCounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}


- (void)initView
{
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"房贷计算器" leftName:nil rightName:nil delegate:self];
    //    bar.leftBtnHiden = YES;
    //    CGFloat pageMenuW = 90 + 60 + 30 + 70;
    //    CGFloat MenuX = (MSWIDTH - pageMenuW)/2;
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, bar.maxY, MSWIDTH, 44) trackerStyle:SPPageMenuTrackerStyleLineAttachment];
    // 传递数组，默认选中第1个
    [pageMenu setItems:@[@"纯商业贷", @"纯公积金", @"组合贷"] selectedItemIndex:0];
    // 设置代理
    pageMenu.needTextColorGradients = NO;
    pageMenu.delegate = self;
    pageMenu.backgroundColor = NavgationColor;
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
    pageMenu.itemPadding = 30;
    pageMenu.itemTitleFont = [UIFont systemFontOfSize:17];
    pageMenu.selectedItemTitleColor = AJWhiteColor;
    pageMenu.unSelectedItemTitleColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.6f];
    pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollAdaptContent;
    
    UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Counters" bundle:nil];
    //纯商业贷
    FHouseCounterSimpleViewController *controller =  [homeStoryboard instantiateViewControllerWithIdentifier:@"simpleLoanCounter"];
    controller.isBusiness = YES;
    [self addChildViewController:controller];
    [self.myChildViewControllers addObject:controller];
    
    //纯公积金
    FHouseCounterSimpleViewController *controlle = [homeStoryboard instantiateViewControllerWithIdentifier:@"simpleLoanCounter"];
    [self addChildViewController:controlle];
    [self.myChildViewControllers addObject:controlle];
    
    //组合贷
    FHouseCounterHybirdViewController *CreditorCon = [homeStoryboard instantiateViewControllerWithIdentifier:@"HouseCounterHybird"];
    [self addChildViewController:CreditorCon];
    [self.myChildViewControllers addObject:CreditorCon];
    [CreditorCon setValue:@(NO) forKeyPath:@"tableView.scrollsToTop"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, pageMenu.maxY, MSWIDTH, MSHIGHT - pageMenu.maxY)];
    scrollView.delegate = self;
    scrollView.scrollsToTop = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    self.pageMenu.bridgeScrollView = scrollView;
    
    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        
        FHouseCounterSimpleViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [scrollView addSubview:baseVc.view];
        baseVc.view.frame = CGRectMake(MSWIDTH*self.pageMenu.selectedItemIndex, 0, MSWIDTH, scrollView.height);
        
        scrollView.contentOffset = CGPointMake(MSWIDTH*self.pageMenu.selectedItemIndex, 0);
        scrollView.contentSize = CGSizeMake(self.myChildViewControllers.count*MSWIDTH, 0);
    }
}

- (NSMutableArray *)myChildViewControllers {
    
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
    }
    return _myChildViewControllers;
}

#pragma mark - SPPageMenu的代理方法
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (fromIndex == toIndex) return;
    [self.scrollView setContentOffset:CGPointMake(MSWIDTH * toIndex, 0) animated:YES];
    if (self.myChildViewControllers.count <= toIndex) return;
    UIViewController *currController = self.myChildViewControllers[fromIndex];
    [currController setValue:@(NO) forKeyPath:@"tableView.scrollsToTop"];
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    [targetViewController setValue:@(YES) forKeyPath:@"tableView.scrollsToTop"];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    targetViewController.view.frame = CGRectMake(MSWIDTH * toIndex, 0, MSWIDTH, self.scrollView.height);
    [_scrollView addSubview:targetViewController.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
