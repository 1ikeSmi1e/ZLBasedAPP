//
//  ZLSettingAboutUsController.m
//  ZLBasedAPP
//
//  Created by admin on 2018/9/26.
//  Copyright © 2018年 zlbased. All rights reserved.
//

#import "ZLSettingAboutUsController.h"
#import "ZLSettingFeedBackController.h"
#import <QuickLook/QuickLook.h>


@interface ZLSettingAboutUsController ()<QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@end

@implementation ZLSettingAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *title = [@"关于" stringByAppendingString:app_Name];
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:title leftName:nil rightName:nil delegate:self];
    
    UIView *header = [UIView viewWithFrame:RECT(0, bar.maxY, MSWIDTH, 150) backgroundColor:nil superview:self.view];
    CGFloat imgVH = 70.f;
    UIImageView *imgV = [UIImageView imageViewWithFrame:RECT((MSWIDTH-imgVH)/2, 30, imgVH, imgVH) imageFile:@"flogo" superview:header];
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *app_VersionShow = [NSString stringWithFormat:@"%@ V%@", app_Name, app_Version];
    UILabel *app_VersionL = [UILabel labelWithFrame:RECT(0, imgV.maxY+5, MSWIDTH, 20) text:app_VersionShow textColor:UIColor.ys_black textFont:15 fitWidth:NO superview:header];
    app_VersionL.textAlignment = NSTextAlignmentCenter;
    
    UIView *feedbackView = [UIView viewWithFrame:RECT(0, header.maxY, MSWIDTH, 50) backgroundColor:AJWhiteColor superview:self.view];
    UIImageView *feedbackimgV = [UIImageView imageViewWithFrame:RECT(13, 0, 20, 50) imageFile:@"Mine_AboutUs_feedback" superview:feedbackView];
    UILabel *label = [UILabel labelWithFrame:RECT(feedbackimgV.maxX + 5, 0, 100, 50) text:@"意见与反馈" textColor:UIColor.ys_black textFont:15 fitWidth:NO superview:feedbackView];
    feedbackimgV.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat imgVW = 8.f;
    UIImageView *imgVArrow = [UIImageView imageViewWithFrame:RECT(feedbackView.width - imgVW - 15, 0, imgVW, feedbackView.height) imageFile:@"Payments_arrow" superview:feedbackView];
    imgVArrow.contentMode = UIViewContentModeScaleAspectFit;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(feedbackViewTapped:)];
    [feedbackView addGestureRecognizer:tapGes];
    
    UIView *privacyView = [UIView viewWithFrame:RECT(0, feedbackView.maxY+1, MSWIDTH, 50) backgroundColor:AJWhiteColor superview:self.view];
    UIImageView *privacyimgV = [UIImageView imageViewWithFrame:RECT(13, 0, 20, 50) imageFile:@"Mine_AboutUs_privacy" superview:privacyView];
    privacyimgV.contentMode = UIViewContentModeScaleAspectFit;
    UILabel *label2 = [UILabel labelWithFrame:RECT(feedbackimgV.maxX + 5, 0, 100, 50) text:@"隐私政策" textColor:UIColor.ys_black textFont:15 fitWidth:NO superview:privacyView];
    feedbackimgV.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImageView *imgVArrow2 = [UIImageView imageViewWithFrame:RECT(feedbackView.width - imgVW - 15, 0, imgVW, feedbackView.height) imageFile:@"Payments_arrow" superview:privacyView];
    imgVArrow2.contentMode = UIViewContentModeScaleAspectFit;
    
    UITapGestureRecognizer *tapGes2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(privacyViewTapped:)];
    [privacyView addGestureRecognizer:tapGes2];
    
    
    UIView *longpressGesView = [UIView viewWithFrame:RECT(0, MSHIGHT-90, MSWIDTH, 90) backgroundColor:nil superview:self.view];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    gesture.numberOfTapsRequired = 1;
//    gesture.numberOfTouchesRequired = 1;
    gesture.minimumPressDuration = 1.5;
    [longpressGesView addGestureRecognizer:gesture];
//    longpressGesView.backgroundColor = UIColor.ys_red;
}

- (void)longPress:(UILongPressGestureRecognizer *)sender
{
    ShowLightMessage(kRequestUrlPath_appstore);
}

- (void)feedbackViewTapped:(UITapGestureRecognizer *)sender
{
    
    ZLSettingFeedBackController *controller = [ZLSettingFeedBackController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)privacyViewTapped:(UITapGestureRecognizer *)sender
{
    QLPreviewController *QLPVC = [[QLPreviewController alloc] init];
    QLPVC.dataSource = self;
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"隐私政策" leftName:nil rightName:nil delegate:QLPVC];
    [QLPVC.view addSubview:bar];
//    ZLNavigationController *navController = [[ZLNavigationController alloc] initWithRootViewController:QLPVC];
    [self.navigationController pushViewController:QLPVC animated:YES];
//    [self presentViewController:navController animated:YES completion:^{
//        navController.navigationBar.hidden = NO;
//        QLPVC.nav
////        QLPVC.navigationController.navigationBar.tintColor = [UIColor ys_blue];
//    }];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
    NSString *wordTextPath = [[NSBundle mainBundle] pathForResource:@"SHB_privacyPolicy" ofType:@"docx"];
    NSURL *url = [NSURL fileURLWithPath:wordTextPath];
    return url;
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller{
    DLOG_METHOD;
}


/*!
 * @abstract Invoked after the preview controller is closed.
 */
- (void)previewControllerDidDismiss:(QLPreviewController *)controller{
    DLOG_METHOD;
}
@end
