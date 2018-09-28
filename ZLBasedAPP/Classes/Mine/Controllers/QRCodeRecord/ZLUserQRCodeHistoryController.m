

//
//  ZLUserQRCodeHistoryController.m
//  ZLBasedAPP
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import "ZLUserQRCodeHistoryController.h"
#import "ZLQRResultHistoryCell.h"

@interface ZLUserQRCodeHistoryController ()

@end

static NSString * const reuseIdentifier = @"ZLQRResultHistoryCell";
@implementation ZLUserQRCodeHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 读取记录
    NSMutableArray *arr2 = [FAccountRecordSaveTool QRCodeRecords];
    
    if (!arr2 && [AppDelegateInstance.userInfo.phone isEqualToString:defName]) {// 审核账号的测试数据
        
        self.dataArray = [FAccountRecordSaveTool QRCodeRecordsFromDefault];
        
        [self.tableView reloadData];
    }else{
        
        self.dataArray = arr2;
        [self.tableView reloadData];
    }
}

- (void)nextItemClick{
    

    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定清空所有记录？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCon addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        if ([AppDelegateInstance.userInfo.phone isEqualToString:defName]) {
            UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到此账号为测试账号，不能清空！" preferredStyle:UIAlertControllerStyleAlert];
            [alertCon addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertCon animated:YES completion:nil];
        }else{
            [FAccountRecordSaveTool clearQRCodeRecords];
            
        }
    }]];
    
    [alertCon addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertCon animated:YES completion:nil];

}

- (void)initView {
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"二维码识别结果" leftName:nil rightName:@"清空记录" delegate:self];
    
    
    UITableView *tableView = [UITableView tableViewWithFrmae:RECT(0, bar.maxY, MSWIDTH, MSHIGHT - bar.maxY) backgroundColor:AJGrayBackgroundColor delegate:self tableViewStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone superview:self.view];
    self.tableView = tableView;
    tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
//    UIView *header = [UIView viewWithFrame:RECT(0, 0, MSWIDTH, 40) backgroundColor:nil superview:nil];
//    UILabel *headL = [UILabel labelWithFrame:RECT(15, 0, MSWIDTH, 40) text:@"历史记录" textColor:UIColor.ys_darkGray textFont:14 fitWidth:NO superview:header];
//    self.tableView.tableHeaderView = header;
    
    UILabel *footer = [UILabel labelWithFrame:RECT(0, 0, MSWIDTH, 100) text:@"暂无记录" textColor:UIColor.ys_lightGray textFont:15 fitWidth:NO superview:nil];
    footer.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count == 0) {
        self.tableView.tableFooterView.hidden = NO ;
    }else{
        self.tableView.tableFooterView.hidden = YES;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZLQRResultHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *qrcodeInfo = self.dataArray[indexPath.row];
    cell.timeL.text = qrcodeInfo[JLBQRCodeTimeKey];
    cell.textView.text = qrcodeInfo[JLBQRCodeStringKey];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self openUrlInSafari:self.dataArray[indexPath.row]];
}

- (void)openUrlInSafari:(NSString *)sender
{
    if (sender.length > 0 ) {
        
        NSString *urlPath = [sender stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlPath];
        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            
        }else{
            
            ShowLightMessage(@"此网络链接路径不合法！");
        }
        
    }else{
        
        ShowLightMessage(@"路径为空！");
    }
}

@end
