//
//  FTakeRecordIncomeController.m
//  ftool
//
//  Created by admin on 2018/6/23.
//  Copyright © 2018年 apple. All rights reserved.
// 记录会在FTakeRecordFatherController离开时保存在本地文件，请放心编辑

#import "FTakeRecordIncomeController.h"
#import "FTakeRecordIncomeView.h"

@interface FTakeRecordIncomeController ()<UIViewOutterDelegate>
@property (nonatomic, weak) FTakeRecordIncomeView *contentV;

@property (nonatomic, strong) FAccountRecord *lastsaveRecord;

@end

@implementation FTakeRecordIncomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

#pragma  mark - UIViewOutterDelegate
- (void)customView:(UIView *)sectionView didClickWithType:(ClickType)type{
    
    if (ClickType_editCategory == type) {
        
//        FEditFirstTypeController *controller = [FEditFirstTypeController new];
//        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)initView {
    
    self.view.backgroundColor = AJGrayBackgroundColor;
    UIScrollView *tableview = [UIScrollView viewWithFrame:CGRectMake(0, 0, MSWIDTH, self.view.height-70) backgroundColor:AJWhiteColor superview:self.view];
    //    tableview.tableFooterView = [UIView new];
    tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    FTakeRecordIncomeView *contentV = [FTakeRecordIncomeView viewWithFrame:RECT(0, 0, MSWIDTH, 500) backgroundColor:nil superview:tableview];
    contentV.delegate = self;
    tableview.contentSize = CGSizeMake(0, contentV.height+30);
    self.contentV = contentV;
    CGFloat leading = 15.f;
    CGFloat btnW = (MSWIDTH - 2*leading - 40)/2;
    UIButton *saveBtn = [AJCornerCircle buttonWithFrame:RECT(leading, tableview.maxY+15, btnW, 35) backgroundColor:NavgationColor title:@"保存" titleColor:AJWhiteColor titleFont:15 target:self action:@selector(saveBtnClick:) superview:self.view];
    // 再来
    UIButton *oneMoreBtn = [AJCornerCircle buttonWithFrame:RECT(saveBtn.maxX + 40, saveBtn.y, btnW, 35) backgroundColor:AJWhiteColor title:@"再来一笔" titleColor:NavgationColor titleFont:15 target:self action:@selector(oneMoreBtnClick:) superview:self.view];
    oneMoreBtn.layer.borderColor = NavgationColor.CGColor;
    oneMoreBtn.layer.borderWidth = .7f;
    
    saveBtn.autoresizingMask = oneMoreBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
}

- (void)oneMoreBtnClick:(UIButton *)sender
{
    // 先保存，再翻页
    if ([self saveRecord]) {
        ShowLightMessage(@"已保存");
        [[NSNotificationCenter defaultCenter] postNotificationName:FToolUserDidSaveARecordNotification object:nil];

        NSString *subtypeString = kCATransitionFromBottom;
        [self transitionWithType:@"pageCurl" WithSubtype:subtypeString ForView:self.contentV];
        
        [self.contentV clear];
        self.lastsaveRecord = nil;
    }
}


- (BOOL)saveRecord{
    
    FAccountRecord *incomeRecord = [self.contentV incomeReord];
    NSMutableArray *incomeArr = AppDelegateInstance.currentMonthRecord.incomeArr.mutableCopy;
    if (!incomeRecord) return NO;
    
    if (self.lastsaveRecord && self.lastsaveRecord == AppDelegateInstance.currentMonthRecord.incomeArr.firstObject) {
      // 替换
        [incomeArr replaceObjectAtIndex:0 withObject:incomeRecord];
    }else{
        
        if (incomeArr.count > 1) {
            [incomeArr insertObject:incomeRecord atIndex:0];
            
        }else if(incomeArr){
            [incomeArr addObject:incomeRecord];
        }else{
            incomeArr = [NSMutableArray arrayWithObject:incomeRecord];
        }
        
    }
    
    self.lastsaveRecord = incomeRecord;
   
    if (!AppDelegateInstance.currentMonthRecord) {
        // 支出收入都没有
        AppDelegateInstance.currentMonthRecord = [[FCurrentMonthRecord alloc] init];
    }
    AppDelegateInstance.currentMonthRecord.incomeArr = incomeArr;
    return YES;
}


- (void)saveBtnClick:(UIButton *)sender
{
    if ([self saveRecord]) {
        ShowLightMessage(@"已保存");
       
        [[NSNotificationCenter defaultCenter] postNotificationName:FToolUserDidSaveARecordNotification object:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *arrPoped = [self.navigationController popToRootViewControllerAnimated:YES];
            for (UIViewController *popVC in arrPoped) {
                [popVC viewDidDisappear:NO];
            }        });
        
    }
}


#pragma CATransition动画实现
/**
 *  动画效果实现
 *
 *  @param type    动画的类型 在开头的枚举中有列举,比如 CurlDown//下翻页,CurlUp//上翻页
 ,FlipFromLeft//左翻转,FlipFromRight//右翻转 等...
 *  @param subtype 动画执行的起始位置,上下左右
 *  @param view    哪个view执行的动画
 */
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.7f;
    animation.type = type;
    if (subtype) {
        animation.subtype = subtype;
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:animation forKey:@"animation"];
}
@end
