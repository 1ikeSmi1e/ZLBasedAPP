//
//  BaseWKWebViewController.h
//  微金在线
//
//  Created by 首控微金财富 on 2017/10/20.
//  Copyright © 2017年 zhouli. All rights reserved.
//

#import "ZLBaseViewController.h"
#import <WebKit/WebKit.h>
#import "DejalActivityView.h"

/*
 * UIWebView: 打开ituns.apple.com跳转到appStore, 拨打电话, 唤起邮箱等一系列操作UIWebView默认支持的.
 * WKWebView: 默认禁止了以上行为,除此之外,js端通过alert()`弹窗的动作也被禁掉了.需要实现WKUIDelegate里面方法，使之可用
 */
@interface BaseWKWebViewController : ZLBaseViewController<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic ,weak) WKWebView *webView;
@end
