//
//  ZLSettingsController.m
//  ZLBasedAPP
//
//  Created by admin on 2018/9/26.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import "ZLSettingsController.h"
#import "ProductItem.h"
#import "AJMonthSectionHeader.h"
#import "ZLSettingNormalCell.h"
#import "ZLSettingAboutUsController.h"

@interface ZLSettingsController ()

@end

static NSString * const reuseIdHeader = @"AJMonthSectionHeader";
static NSString * const reuseIdentifier = @"ZLSettingNormalCell";
static NSString * const WJServicePhone = @"0755-29987655";
@implementation ZLSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *group0 = @[@"隐私设置",@"账户同步"];
    NSArray *group1 = @[@"清除缓存", @"上次登录时间"];
    NSArray *group2 = @[@"关于", @"客服电话"];
    self.dataArray = @[group0, group1, group2].mutableCopy;
    [self initView];
}

- (void)initView {
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"设置" leftName:nil rightName:@"" delegate:self];
    
    UITableView *header = [UIView viewWithFrame:RECT(0, 0, MSWIDTH, 150) backgroundColor:nil superview:nil];
    
    
    CGFloat imgVH = 70.f;
    UIImageView *imgV = [UIImageView imageViewWithFrame:RECT((MSWIDTH-imgVH)/2, 30, imgVH, imgVH) imageFile:@"flogo" superview:header];
    NSString *accountPhone = AppDelegateInstance.userInfo.phone;
    UILabel *phoneL = [UILabel labelWithFrame:RECT(0, imgV.maxY+5, MSWIDTH, 20) text:accountPhone textColor:UIColor.ys_black textFont:15 fitWidth:NO superview:header];
    phoneL.textAlignment = NSTextAlignmentCenter;
    self.tableView = [UITableView tableViewWithFrmae:RECT(0, bar.maxY, MSWIDTH, MSHIGHT-bar.maxY) backgroundColor:AJGrayBackgroundColor delegate:self tableViewStyle:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleSingleLineEtched superview:self.view];
    [self.tableView registerClass:[AJMonthSectionHeader class] forHeaderFooterViewReuseIdentifier:reuseIdHeader];
    self.tableView.estimatedRowHeight = self.tableView.rowHeight = 54.f;
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.tableHeaderView = header;
    UIView *footer = [UIView viewWithFrame:RECT(0, 0, MSWIDTH, 100) backgroundColor:nil superview:nil];
    UIButton *btn = [UIButton buttonWithFrame:RECT(50, 30, MSWIDTH-100, 37) backgroundColor:AJWhiteColor title:@"退出登录" titleColor:[UIColor ys_black] titleFont:15 target:self action:@selector(signOut:) superview:footer];
    self.tableView.tableFooterView = footer;
//    btn;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZLSettingNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.titleL.text = self.dataArray[indexPath.section][indexPath.row];
    if ([cell.titleL.text isEqualToString:@"上次登录时间"]) {
        
        NSDate *date = [AppDefaultUtil lastLoginTime];
        if (date) {
            
            NSString *dateStr = [NSDate getDateString:date format:@"yyyy-MM-dd HH:mm:ss"];
            cell.detailL.text = dateStr;
        }
        cell.detailL.hidden = NO;
    }else if ([cell.titleL.text isEqualToString:@"客服电话"]) {
        
        cell.detailL.text = WJServicePhone;
        cell.detailL.hidden = NO;
    }else {
        cell.detailL.hidden = YES;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    FAccountRecord *bean = [self.dataArray[section] firstObject];
    AJMonthSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdHeader];
    header.contentView.backgroundColor = nil;
    if (section == 0) {
        [header setText:@"账号"];
    }else if(section == 1){
        
         [header setText:@""];
    }else{
        [header setText:@""];
    }
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
// MARK:- 退出登录
- (void)signOut:(UIButton *)sender
{
    [SVProgressHUD show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
        ShowLightMessage(@"已退出登录");
        self.tabBarController.selectedIndex = 0;
        [ZLUserModel clearUser];
        AppDelegateInstance.userInfo = nil;
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {// 清除缓存
            
            UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除缓存后，您在下次进入程序时，将重新下载数据！" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertCon addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                [SVProgressHUD show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showImage:kSuccessImage status:@"清除缓存成功!"];
                });
            }]];
           
            [alertCon addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertCon animated:YES completion:nil];

        }
        
    }else if (indexPath.section == 2){
        
        
        if (indexPath.row == 0) {
            ZLSettingAboutUsController *controller = [ZLSettingAboutUsController new];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            
#if TARGET_IPHONE_SIMULATOR
            [SVProgressHUD showErrorWithStatus:@"请在真机情况下拨打"];
#elif TARGET_OS_IPHONE
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",WJServicePhone];
            // NSLog(@"str======%@",str);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
#endif
        }
        
    }
}

@end
