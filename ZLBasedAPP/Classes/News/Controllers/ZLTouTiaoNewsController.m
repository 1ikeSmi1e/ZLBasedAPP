//
//  ZLTouTiaoNewsController.m
//  ZLBasedAPP
//
//  Created by admin on 2018/9/27.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import "ZLTouTiaoNewsController.h"
#import "AFNetworking.h"
#import "HomeHeader.h"
#import "JLBNews.h"
#import "ZLTouTiaoNewsCell.h"
#import "FWebController.h"

@interface ZLTouTiaoNewsController ()

@property (nonatomic, weak) HomeHeader *header;
@end
static NSString * const reuseIdentifier = @"ZLTouTiaoNewsCell";
@implementation ZLTouTiaoNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];
    
    [self.tableView.mj_header beginRefreshing];
//    [self requestData];
}

- (void)requestData{
    
    //有网络发起请求
    AFHTTPSessionManager *afn = [AFHTTPSessionManager manager];
    //记得把这个链接替换
    
    NSString *urlPath = @"http://ic.snssdk.com/2/article/v25/stream/";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"count"] = @"20";
    params[@"min_behot_time"] = @"1504621700";
    params[@"bd_latitude"] = @"4.9E-324";
    params[@"bd_longitude"] = @"4.9E-324";
    params[@"bd_loc_time"] = @"1504622133";
    params[@"loc_mode"] = @"5";
    params[@"loc_time"] = @"1504564532";
    params[@"latitude"] = @"35.00125";
    params[@"longitude"] = @"113.56358166666665";
    params[@"city"] = @"%E7%84%A6%E4%BD%9C";
    params[@"lac"] = @"34197";
    params[@"cid"] = @"23201";//@"23201";
    params[@"iid"] = @"14534335953";
    params[@"device_id"] = @"38818211465";
    params[@"ac"] = @"wifi";
    params[@"channel"] = @"baidu";
    params[@"aid"] = @"14";
    params[@"app_name"] = @"news_article";
    params[@"version_code"] = @"460";
    params[@"device_platform"] = @"ios";
    params[@"device_type"] = @"SM-E7000";
    params[@"os_api"] = @"19";
    params[@"os_version"] = @"11.4.1";
    params[@"uuid"] = @"357698010742401";
    params[@"openudid"] = @"74f06d2f9d8c9664";
    
    [afn GET:urlPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideRefreshHeaderFooter];
        DLOG(@"============================>>>");
        DLOG(@"%@", [responseObject mj_JSONString]);
        if ([responseObject[@"message"] isKindOfClass:NSString.class] && [responseObject[@"message"] isEqualToString:@"success"]) {
             NSMutableArray *newsArr = [JLBNews mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            self.dataArray = newsArr;
            
            [self.tableView reloadData];
        }else{
            
            NSString *message = [NSString stringWithFormat:@"回调数据出错%@", responseObject[@"message"]];
            ShowLightMessage(message);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideRefreshHeaderFooter];
        
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        
        
        [alertCon addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alertCon animated:YES completion:nil];
    }];

}


- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"资讯" leftName:nil rightName:@"" delegate:self];
    bar.leftBtnHiden = YES;
    UITableView *tableView = [UITableView tableViewWithFrmae:RECT(0, bar.maxY, MSWIDTH, MSHIGHT-self.tabBarController.tabBar.height - bar.maxY) backgroundColor:AJGrayBackgroundColor delegate:self tableViewStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone superview:self.view];
    self.tableView = tableView;
    tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    HomeHeader *header = [[HomeHeader alloc] initWithFixedHeght];
    self.tableView.tableHeaderView = header;
    self.header = header;
    __weak typeof(self) weakSelf = self;
    header.tapImgBlock = ^(id item){
        
        NSInteger index = [weakSelf.header.imageURLStringsGroup indexOfObject:item];
        NSArray *urlArr = @[ @"http://sports.qq.com/a/20180927/000374.htm",
                             @"http://sports.qq.com/a/20180927/001655.htm?tdsourcetag=s_pctim_aiomsg#p=3",
                             @"https://new.qq.com/omn/20180927/20180927A0XIJJ.html",
                             @"https://new.qq.com/omn/20180927/20180927A10DL2.html"];
        
        FWebController *controller = [FWebController new];
        controller.urlStr = urlArr[index];//[NSString stringWithFormat:@"%@/AccountController/wealthinfoNewsDeatil?id=%@", baseUrl, bean.ID];
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];

    };
    self.header.imageURLStringsGroup = @[ @"News_banner_1",
                                         @"News_banner_2",
                                         @"News_banner_3",
                                          @"News_banner_4"];
    
    [self addTableViewRefreshHeader];
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
//    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier2 bundle:nil] forCellReuseIdentifier:reuseIdentifier2];
    
    UILabel *noMore = [UILabel labelWithFrame:RECT(0, 0, MSWIDTH, 90) text:@"没有更多了" textColor:UIColor.ys_lightGray textFont:13 textAligment:NSTextAlignmentCenter superview:nil];
    self.tableView.tableFooterView = noMore;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZLTouTiaoNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    JLBNews *news = self.dataArray[indexPath.row];
    cell.aJLBNews = news;
    return cell;
    
//    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JLBNews *news = self.dataArray[indexPath.row];
    FWebController *controller = [FWebController new];
    controller.urlStr = news.display_url;//[NSString stringWithFormat:@"%@/AccountController/wealthinfoNewsDeatil?id=%@", baseUrl, bean.ID];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];

}

@end
