//
//  FHomeViewController.m
//  ftool
//
//  Created by apple on 2018/6/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FHomeViewController.h"
#import "HomeHeader.h"
#import "FHomeCell.h"
#import "FTakeRecordFatherController.h"
#import "FRateViewController.h"
#import "FLoginViewController.h"
#import "FHomeNews.h"
#import "FHomeNewsCell.h"
#import "UIImageView+WebCache.h"
#import "FWebController.h"

#define baseUrl @"https://wechat.meipenggang.com"
@interface FHomeViewController ()

@property (nonatomic, weak) HomeHeader *header;
@end
static NSString * const reuseIdentifier = @"FHomeCell";
static NSString * const reuseIdentifier2 = @"FHomeNewsCell";
@implementation FHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    self.dataArray = @[@"最新利率", @"记一笔"].mutableCopy;
    self.header.imageURLStringsGroup = @[
//                                         @"https://static.weijinzaixian.com/ad_0603403dc18654ec40c34a63c5eb5dd8.jpg",
                                         @"https://static.weijinzaixian.com/ad_15bf2acdc7a3119e37d3fae7bcdbd10f.jpg",
                                         @"WechatIMG608.jpeg"
//                                         @"https://static.weijinzaixian.com/ad_261360cfeb807ef46adbf76b69f5c8a2.jpg"
                                         ];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestData];
//    });
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [UITableView tableViewWithFrmae:RECT(0, 0, MSWIDTH, MSHIGHT-self.tabBarController.tabBar.height) backgroundColor:AJGrayBackgroundColor delegate:self tableViewStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLineEtched superview:self.view];
    self.tableView = tableView;
    tableView.tableFooterView = [UIView new];
    tableView.estimatedRowHeight = tableView.rowHeight = 50.f;
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    HomeHeader *header = [[HomeHeader alloc] initWithFixedHeght];
    self.tableView.tableHeaderView = header;
    self.header = header;
    __weak typeof(self) weakSelf = self;
    header.tapImgBlock = ^(id item){ };
    
    [self addTableViewRefreshHeader];
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier2 bundle:nil] forCellReuseIdentifier:reuseIdentifier2];
}


- (void)requestData{
    [MyTools hidenNetworkActitvityIndicator];
    
    NSMutableString *mutableUrl = [[NSMutableString alloc] initWithString:@"https://wechat.meipenggang.com/AccountController/wealthinfoNewsList?currPage=1"];
    
//    NSString *urlEnCode = [[mutableUrl substringToIndex:mutableUrl.length - 1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:mutableUrl]];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        [self.tableView.mj_header endRefreshing];
        if (error) {
            NSString *errorDescription = error.localizedDescription;
            ShowLightMessage(errorDescription);
        } else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            NSArray *newsArr = [FHomeNews mj_objectArrayWithKeyValuesArray:dic[@"list"]];
            
            if (self.dataArray.count > 2) {
                [self.dataArray removeObjectsInRange:NSMakeRange(2, self.dataArray.count-2)];
            }
            
            [self.dataArray addObjectsFromArray:newsArr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
            });
           
            DLOG(@"%@", dic);
        }
    }];
    [dataTask resume];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >=2) {
        return 90;
    }
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row >=2) {
        return 90;
    }
    return 50.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row >=2) {
        
        FHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2 forIndexPath:indexPath];
        
        FHomeNews *bean = self.dataArray[indexPath.row];
        cell.titleL.text = bean.title;
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[baseUrl stringByAppendingString:bean.image_filename]]];
        cell.detailL.text = bean.time;
        return cell;
    }else{
        
        
        FHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = self.dataArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        
        if (!AppDelegateInstance.userInfo) {
            //如果未登录，则跳转登录界面
            FLoginViewController *loginView = [[FLoginViewController alloc] init];
            UINavigationController *loginNVC = [[UINavigationController alloc] initWithRootViewController:loginView];
            //        loginView.backType = MyWealth;
            [((UINavigationController *)self.tabBarController.selectedViewController) presentViewController:loginNVC animated:YES completion:nil];
            return;
        }
       
        
        FTakeRecordFatherController *controller = [[FTakeRecordFatherController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 0) {

        UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Counters" bundle:nil];
        UIViewController *tenderVC = [homeStoryboard instantiateViewControllerWithIdentifier:@"rateController"];
        tenderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tenderVC animated:YES];
    }else{
        
        FHomeNews *bean = self.dataArray[indexPath.row];
        FWebController *controller = [FWebController new];
        controller.urlStr = [NSString stringWithFormat:@"%@/AccountController/wealthinfoNewsDeatil?id=%@", baseUrl, bean.ID];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
