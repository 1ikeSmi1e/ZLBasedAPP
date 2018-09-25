//
//  FTakeRecordFatherController.m
//  ftool
//
//  Created by admin on 2018/6/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FTakeRecordFatherController.h"
#import "SPPageMenu.h"
#import "FTakeRecordIncomeController.h"
#import "FTakeRecordExpandController.h"
#import "MJRefreshConst.h"

@interface FTakeRecordFatherController ()<SPPageMenuDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@end

@implementation FTakeRecordFatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView
{
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"记一笔" leftName:nil rightName:nil delegate:self];
//    bar.leftBtnHiden = YES;
//    CGFloat pageMenuW = 90 + 60 + 30 + 70;
//    CGFloat MenuX = (MSWIDTH - pageMenuW)/2;
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, bar.maxY, MSWIDTH, 44) trackerStyle:SPPageMenuTrackerStyleLineAttachment];
    // 传递数组，默认选中第1个
    [pageMenu setItems:@[@"支出", @"收入"] selectedItemIndex:0];
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
    
    FTakeRecordExpandController *controller = [[FTakeRecordExpandController alloc] init];
    [self addChildViewController:controller];
    [self.myChildViewControllers addObject:controller];
    
    FTakeRecordIncomeController *CreditorCon = [[FTakeRecordIncomeController alloc] init];
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
        FTakeRecordExpandController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
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
    
//    if ([currController respondsToSelector:NSSelectorFromString(@"saveRecord")]) {
//        MJRefreshMsgSend(MJRefreshMsgTarget(currController), NSSelectorFromString(@"saveRecord"), self);
//    }

    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    [targetViewController setValue:@(YES) forKeyPath:@"tableView.scrollsToTop"];
    
//    if ([targetViewController respondsToSelector:NSSelectorFromString(@"saveRecord")]) {
//        MJRefreshMsgSend(MJRefreshMsgTarget(targetViewController), NSSelectorFromString(@"saveRecord"), self);
//    }
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    targetViewController.view.frame = CGRectMake(MSWIDTH * toIndex, 0, MSWIDTH, self.scrollView.height);
    [_scrollView addSubview:targetViewController.view];
    
}



- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    if (!self.navigationController) {
    
        if (!AppDelegateInstance.userInfo) {
            
            ShowLightMessage(@"保存失败！未登录！");
        }else{
            
            [FAccountRecordSaveTool saveCurrentMonthBlanceRecords];
        }
    }
}
@end
