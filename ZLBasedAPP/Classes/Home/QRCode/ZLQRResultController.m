//
//  ZLQRResultController.m
//  ZLBasedAPP
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import "ZLQRResultController.h"
#import "ZLQRResultHistoryCell.h"

@interface ZLQRResultController ()

@property (nonatomic, weak) UITextView *resultTextView;
@end
static NSString * const reuseIdentifier = @"ZLQRResultHistoryCell";
@implementation ZLQRResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    self.resultTextView.text = self.QRResultString;
  
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSString *timeStr = [NSDate getDateString:NSDate.date format:@"yyyy-MM-dd HH:mm:ss"];
    [FAccountRecordSaveTool saveANewQRCodeRecord:@{JLBQRCodeStringKey : self.QRResultString, JLBQRCodeTimeKey : timeStr}];
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



- (void)initView {
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"二维码识别结果" leftName:nil rightName:@"" delegate:self];
 
    // 结果展示板
    UIView *resultBoard = [UIView viewWithFrame:RECT(0, bar.maxY, MSWIDTH, 130) backgroundColor:AJWhiteColor superview:self.view];
    UITextView *resultTextView = [UITextView textViewWithFrame:RECT(10, 10, MSWIDTH-20, resultBoard.height-20) textColor:UIColor.ys_orange bgColor:nil font:14 superV:resultBoard];
    resultTextView.editable = NO;
    self.resultTextView = resultTextView;
    UIButton *btn1 = [UIButton buttonWithFrame:RECT(0, resultBoard.height - 40, MSWIDTH, 40) backgroundColor:nil title:@"使用浏览器打开" titleColor:UIColor.ys_blue titleFont:15 target:self action:@selector(openUrl:) superview:resultBoard];
    
    UITableView *tableView = [UITableView tableViewWithFrmae:RECT(0, resultBoard.maxY, MSWIDTH, MSHIGHT - resultBoard.maxY) backgroundColor:AJGrayBackgroundColor delegate:self tableViewStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone superview:self.view];
    self.tableView = tableView;
    tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
     [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    UIView *header = [UIView viewWithFrame:RECT(0, 0, MSWIDTH, 40) backgroundColor:nil superview:nil];
    UILabel *headL = [UILabel labelWithFrame:RECT(15, 0, MSWIDTH, 40) text:@"历史记录" textColor:UIColor.ys_darkGray textFont:14 fitWidth:NO superview:header];
    self.tableView.tableHeaderView = header;
    
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
    [self openUrlInSafari:self.dataArray[indexPath.row][JLBQRCodeStringKey]];
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
- (void)openUrl:(UIButton *)sender
{
    [self openUrlInSafari:self.QRResultString];
    
}

@end
