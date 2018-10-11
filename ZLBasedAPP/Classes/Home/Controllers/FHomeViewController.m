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
#import "ProductItem.h"
#import "AFNetworking.h"
#import "ZLQRcodeScanController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZTAppCalculatorViewController.h"
#import "ZLQRCodeGeneratorController.h"
#import "FHouseCounterViewController.h"

#define baseUrl @"https://wechat.meipenggang.com"
@interface FHomeViewController ()

@property (nonatomic, strong) NSMutableArray *toolArr;
@property (nonatomic, strong) NSMutableArray *caculatorArr;
@property (nonatomic, weak) HomeHeader *header;
@end
static NSString * const reuseIdentifier = @"FHomeCell";
static NSString * const reuseIdentifier2 = @"FHomeNewsCell";
@implementation FHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    ProductItem *itme1 = [ProductItem itemWithTitle:@"利率看板" icon:@"Home_interest"];
    ProductItem *itme2 = [ProductItem itemWithTitle:@"快速记账" icon:@"Home_takeRecord"];
    self.dataArray = @[itme1, itme2].mutableCopy;
    
    
    
    ProductItem *itme3 = [ProductItem itemWithTitle:@"二维码扫描" icon:@"Home_QRScan"];
    ProductItem *itme4 = [ProductItem itemWithTitle:@"便利计算器" icon:@"Home_caculator"];
    ProductItem *itme5 = [ProductItem itemWithTitle:@"二维码生成器" icon:@"Home_QRCodeGenerator"];
   
    [self.toolArr addObject:itme3];
    [self.toolArr addObject:itme4];
    [self.toolArr addObject:itme5];
   
    
    ProductItem *itme6 = [ProductItem itemWithTitle:@"存款计算器" icon:@"Home_depositCaculator"];
    ProductItem *itme7 = [ProductItem itemWithTitle:@"房贷计算器" icon:@"Home_buyHourseCaculator"];
    ProductItem *itme8 = [ProductItem itemWithTitle:@"普通贷款计算器" icon:@"Home_loanCaculator"];
    ProductItem *itme9 = [ProductItem itemWithTitle:@"投资收益计算器" icon:@"Home_earningCaculator"];
    [self.caculatorArr addObject:itme6];
    [self.caculatorArr addObject:itme7];
    [self.caculatorArr addObject:itme8];
    [self.caculatorArr addObject:itme9];
    
    self.header.imageURLStringsGroup = @[
//                                         @"https://static.weijinzaixian.com/ad_0603403dc18654ec40c34a63c5eb5dd8.jpg",
                                         @"Home_banner1",
                                         @"Home_banner2"
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
    
    UITableView *tableView = [UITableView tableViewWithFrmae:RECT(0, 0, MSWIDTH, MSHIGHT-self.tabBarController.tabBar.height) backgroundColor:AJGrayBackgroundColor delegate:self tableViewStyle:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleSingleLineEtched superview:self.view];
    self.tableView = tableView;
    tableView.tableFooterView = [UIView new];
    tableView.estimatedRowHeight = tableView.rowHeight = 50.f;
    self.tableView.contentInset = EDGEINSET(0, 0, 20, 0);
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
    if (indexPath.section == 0 && indexPath.row >= 2) {
        return 90;
    }
    return 55.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row >= 2) {
        return 90;
    }
    return 55.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 50.f;
    }
    return 0.2f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"工具箱";
    }else if (section == 2) {
        return @"计算器";
    }
    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
//
//    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return self.toolArr.count;
    }else if (section == 2) {
        return self.caculatorArr.count;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        if (indexPath.row >=2) {
            
            FHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2 forIndexPath:indexPath];
            
            FHomeNews *bean = self.dataArray[indexPath.row];
            cell.titleL.text = bean.title;
            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[baseUrl stringByAppendingString:bean.image_filename]]];
            cell.detailL.text = bean.time;
            return cell;
        }else {
            
            
            FHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
            ProductItem *itme1 = self.dataArray[indexPath.row];
            
            cell.titleL.text = itme1.title;
            cell.imgV.image = [UIImage imageNamed:itme1.icon];
            return cell;
        }
        
    }else if(indexPath.section == 1){
        
        FHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        ProductItem *itme1 = self.toolArr[indexPath.row];
        
        cell.titleL.text = itme1.title;
        cell.imgV.image = [UIImage imageNamed:itme1.icon];
        return cell;
    }else{
        
        FHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        ProductItem *itme1 = self.caculatorArr[indexPath.row];
        
        cell.titleL.text = itme1.title;
        cell.imgV.image = [UIImage imageNamed:itme1.icon];
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
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
    }else  if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            if (!AppDelegateInstance.userInfo) {
                //如果未登录，则跳转登录界面
                FLoginViewController *loginView = [[FLoginViewController alloc] init];
                UINavigationController *loginNVC = [[UINavigationController alloc] initWithRootViewController:loginView];
                //        loginView.backType = MyWealth;
                [((UINavigationController *)self.tabBarController.selectedViewController) presentViewController:loginNVC animated:YES completion:nil];
                return;
            }
            ZLQRcodeScanController *controller = [ZLQRcodeScanController new];
            controller.hidesBottomBarWhenPushed = YES;
            [self QRCodeScanVC:controller];
        }else if (indexPath.row == 1){
            
            ZTAppCalculatorViewController *controller =  [[ZTAppCalculatorViewController alloc] init];
            controller.isNew = YES;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 2){
            
            ZLQRCodeGeneratorController *controller =  [[ZLQRCodeGeneratorController alloc] init];
        
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }else if(indexPath.section == 2){
        
        UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Counters" bundle:nil];
        if (indexPath.row == 0){//存款计算器
            
            UIViewController *controller = [homeStoryboard instantiateViewControllerWithIdentifier:@"SaveCounter"];
            //            ZLQRCodeGeneratorController *controller =  [[ZLQRCodeGeneratorController alloc] init];
            
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 1){//房贷计算器
            FHouseCounterViewController *controller = [[FHouseCounterViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 2){//普通贷款计算器
            UIViewController *controller = [homeStoryboard instantiateViewControllerWithIdentifier:@"CommonCounter"];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 3){// 投资收益计算器
            UIViewController *controller = [homeStoryboard instantiateViewControllerWithIdentifier:@"FinanceCounter"];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
    
}



- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.navigationController pushViewController:scanVC animated:YES];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [self.navigationController pushViewController:scanVC animated:YES];
                break;
            }
            case AVAuthorizationStatusDenied: {
                NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Name = [infoDict objectForKey:@"CFBundleDisplayName"];
                if (app_Name == nil) {
                    app_Name = [infoDict objectForKey:@"CFBundleName"];
                }
                NSString *message = [NSString stringWithFormat:@"请去-> [设置 - 隐私 - 相机 - %@] 打开访问开关", app_Name];
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [MyTools openSystemSetting];
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}


- (NSMutableArray *)toolArr
{
    if (!_toolArr) {
        self.toolArr = [NSMutableArray array];
        
    }
    return _toolArr;
}

- (NSMutableArray *)caculatorArr
{
    if (!_caculatorArr) {
        self.caculatorArr = [NSMutableArray array];
        
    }
    return _caculatorArr;
}
@end
