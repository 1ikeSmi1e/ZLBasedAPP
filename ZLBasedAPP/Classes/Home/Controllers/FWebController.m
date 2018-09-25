//
//  FWebController.m
//  ftool
//
//  Created by admin on 2018/6/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FWebController.h"

@interface FWebController ()

@end

@implementation FWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ZLNavBar *bar = [[ZLNavBar alloc] initWithTitle:@"咨询详情" leftName:nil rightName:nil delegate:self];

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:RECT(0, bar.maxY, MSWIDTH, MSHIGHT-bar.maxY) configuration:config];
    self.webView = webView;
    self.webView.navigationDelegate = self;
    [self.webView setBackgroundColor:AJWhiteColor];
    self.webView.scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview: self.webView];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    if (!self.urlStr.length) {
//        return;
//    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
}

@end
