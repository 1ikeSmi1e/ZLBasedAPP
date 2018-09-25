//
//  AJNetWorkController.m
//  SP2P
//
//  Created by Ajax on 16/2/29.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJNetWorkController.h"
#import "DejalActivityView.h"
#import "SVProgressHUD.h"

@interface AJNetWorkController ()//<HTTPClientDelegate>
@end

@implementation AJNetWorkController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
    [DejalActivityView removeView];
//    if (self.requestClient != nil) {
//        [self.requestClient cancel];
//    }
}

@end
