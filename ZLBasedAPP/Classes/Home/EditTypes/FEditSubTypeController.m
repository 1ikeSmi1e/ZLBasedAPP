//
//  FEditSubTypeController.m
//  ftool
//
//  Created by admin on 2018/6/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FEditSubTypeController.h"
#import "FEditFirstTypeCell.h"
#import "FAddSubTypeController.h"
#import "FModifySubTypeController.h"

static NSString * const reuseIdentifier = @"FEditFirstTypeCell";
@interface FEditSubTypeController ()<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *bugetF;
@property (nonatomic, weak) FSubType *selectSubType;
@end

@implementation FEditSubTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initView];
    
    
    FFirstType *firstBena = AppDelegateInstance.aFAccountCategaries.expensesTypeArr[self.selectFirstTypeIndex];
    self.dataArray = firstBena.subTypeArr.mutableCopy;
    [self.tableView reloadData];
    self.bugetF.text = [NSString stringWithFormat:@"%.2f", firstBena.budget];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddSubtypeNotiHandler:) name:FAddSubTypeControllerDidAddSubTypeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didModifySubtypeNotiHandler:) name:FModifySubTypeControllerDidAddSubTypeNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self.tableView reloadData];
}

//- (void)didModifySubtypeNotiHandler:(NSNotification *)note
//{
//    NSInteger index = [self.dataArray indexOfObject:self.selectSubType];
//    [self.dataArray replaceObjectAtIndex:index withObject:note.object];
//    [self.tableView reloadData];
//}

- (void)didAddSubtypeNotiHandler:(NSNotification *)note
{
    [self.dataArray addObject:note.object];
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initView {
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:self.title?:@"编辑子分类" leftName:nil rightName:@"保存" delegate:self];
    
    UIView *bugetView = [UIView viewWithFrame:RECT(0, bar.maxY, MSWIDTH, 70) backgroundColor:AJWhiteColor superview:self.view];
    
    UILabel *leftLabel = [UILabel labelWithFrame:RECT(15, 0, 55, bugetView.height) text:@"预算：" textColor:[UIColor ys_darkGray] textFont:17 textAligment:NSTextAlignmentLeft superview:bugetView];
  
    CGFloat bugetFY = (bugetView.height - 45)/2;
    UITextField *bugetF = [AJTextField textFieldWithFrame:RECT(leftLabel.maxX, bugetFY, MSWIDTH-leftLabel.maxX-15, 45) delegate:self text:nil textColor:[UIColor ys_green] textFont:20 placeholder:@"0.00" superview:bugetView];
    self.bugetF = bugetF;
    bugetF.borderStyle = UITextBorderStyleNone;
    bugetF.keyboardType = UIKeyboardTypeDecimalPad;
    ViewBorderRadius(bugetF, 0, .7, [UIColor ys_grayBorder]);
    
    CGFloat tabelY = bugetView.maxY+8;
    self.tableView = [UITableView tableViewWithFrmae:RECT(0, tabelY, MSWIDTH, MSHIGHT-tabelY) backgroundColor:AJGrayBackgroundColor delegate:self tableViewStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLineEtched superview:self.view];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.rowHeight = 55.f;
    UIView *footer = [UIView viewWithFrame:RECT(0, 0, MSWIDTH, 100) backgroundColor:nil superview:nil];
    UIButton *btn = [UIButton buttonWithFrame:RECT(50, 30, MSWIDTH-100, 37) backgroundColor:AJWhiteColor title:@"添加分类" titleColor:[UIColor ys_black] titleFont:15 target:self action:@selector(addSubType:) superview:footer];
    [btn setImage:[UIImage imageNamed:@"FirstType_add"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = EDGEINSET(7, 0, 7, -10);
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.tableView.tableFooterView = footer;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string.length ==0) {
        return YES;
    }
    NSString *checkStr = [textField.text stringByAppendingString:string];
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL canInput = [predicte evaluateWithObject:checkStr] && (checkStr.doubleValue < 10000000);
    
    return canInput;
}

- (void)nextItemClick{
    
    // 预算
    // 分类修改
    FFirstType *firstBena = AppDelegateInstance.aFAccountCategaries.expensesTypeArr[self.selectFirstTypeIndex];
    firstBena.subTypeArr = self.dataArray.mutableCopy;
    firstBena.budget = self.bugetF.text.doubleValue;
    
    [SVProgressHUD showImage:kSuccessImage status:@"已保存"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (!self.navigationController) {
        [self nextItemClick];
    }
    
}

- (void)addSubType:(UIButton *)sender
{
    if (self.dataArray.count >= 15) {
        ShowLightMessage(@"最多可添加15个子分类, 谢谢！");
        return;
    }
    FAddSubTypeController *controller = [FAddSubTypeController new];
    [self presentViewController:controller animated:YES completion:^{}];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FEditFirstTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    FSubType *bean = self.dataArray[indexPath.row];
    cell.textL.text = bean.name;
    cell.imgV.image = [UIImage imageNamed:bean.iconName];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FSubType *bean = self.dataArray[indexPath.row];
    if (!bean.isEditable) {
        
        ShowLightMessage(@"APP设定的分类不可编辑");
    }else{
       
        self.selectSubType = bean;
        FModifySubTypeController *controller = [FModifySubTypeController new];
        controller.subType = bean;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FSubType *bean = self.dataArray[indexPath.row];
    if (!bean.isEditable) {
        
        return NO;
    }
    return YES;
}

@end
